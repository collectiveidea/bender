# Copyright (c) 2013, [Jason Whitehorn](https://github.com/jwhitehorn)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright notice, this
#   list of conditions and the following disclaimer in the documentation and/or
#   other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
# THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
# OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

module GPIO
  extend self

  #Defines an event block to be executed when an pin event occurs.
  #
  # == Parameters:
  # options:
  #   Options hash. Options include `:pin`, `:invert` and `:trigger`.
  #
  def watch(options, &block)
    Thread.new do
      pin = Pin.new(options)
      loop do
        pin.wait_for_change
        if block.arity > 0
          block.call pin
        else
          pin.instance_exec &block
        end
      end
    end.abort_on_exception = true
  end

  # Represents a GPIO pin on the Raspberry Pi
  class Pin
    attr_reader :pin, :last_value, :value, :direction, :invert

    #Initializes a new GPIO pin.
    #
    # @param [Hash] options A hash of options
    # @option options [Fixnum] :pin The pin number to initialize. Required.
    # @option options [Symbol] :direction The direction of communication, either :in or :out. Defaults to :in.
    # @option options [Boolean] :invert Indicates if the value read from the physical pin should be inverted. Defaults to false.
    # @option options [Symbol] :trigger Indicates when the wait_for_change method will detect a change, either :rising, :falling, or :both edge triggers. Defaults to :both.
    def initialize(options)
      options = {:direction => :in, :invert => false, :trigger => :both}.merge options
      @pin = options[:pin]
      @direction = options[:direction]
      @invert = options[:invert]
      @trigger = options[:trigger]

      raise "Invalid direction. Options are :in or :out" unless [:in, :out].include? @direction
      raise "Invalid trigger. Options are :rising, :falling, or :both" unless [:rising, :falling, :both].include? @trigger

      curr_direction = File.read(direction_file).strip
      if (@direction == :out && curr_direction == "in") || (@direction == :in && curr_direction == "out")
        File.open(direction_file, "w") { |f| f.write(@direction == :out ? "out" : "in") }
      end

      if @direction == :in
        File.open(edge_file, "w") { |f| f.write("both") }
      end

      read
    end

    # If the pin has been initialized for output this method will set the logic level high.
    def on
      File.open(value_file, 'w') {|f| f.write("1") } if direction == :out
    end

    # Tests if the logic level is high.
    def on?
      not off?
    end

    # If the pin has been initialized for output this method will set the logic level low.
    def off
      File.open(value_file, 'w') {|f| f.write("0") } if direction == :out
    end

    # Tests if the logic level is low.
    def off?
      value == 0
    end

    # If the pin has been initialized for output this method will either raise or lower the logic level depending on `new_value`.
    # @param [Object] new_value If false or 0 the pin will be set to off, otherwise on.
    def update_value(new_value)
      !new_value || new_value == 0 ? off : on
    end

    # Tests if the logic level has changed since the pin was last read.
    def changed?
      last_value != value
    end

    # blocks until a logic level change occurs. The initializer option `:trigger` modifies what edge this method will release on.
    def wait_for_change
      @fd = nil if @fd && @fd.closed?
      @fd ||= File.open(value_file, "r")
      @waiting = true
      read
      while @waiting
        ready = IO.select(nil, nil, [@fd], 1)
        next unless ready
        read
        if changed?
          next if @trigger == :rising and value == 0
          next if @trigger == :falling and value == 1
          break
        end
      end
    end

    def break_wait_for_change
      @waiting = false
    end

    # Reads the current value from the pin. Without calling this method first, `value`, `last_value` and `changed?` will not be updated.
    # In short, you must call this method if you are curious about the current state of the pin.
    def read
      @last_value = @value
      val = get_val
      @value = invert ? (val ^ 1) : val
    end

    def get_val
      if @fd && !@fd.closed?
        @fd.rewind
        @fd.read.to_i
      else
        File.read(value_file).to_i
      end
    end

    private
    def value_file
      "/sys/class/gpio/gpio#{pin}/value"
    end

    def edge_file
      "/sys/class/gpio/gpio#{pin}/edge"
    end

    def direction_file
      "/sys/class/gpio/gpio#{pin}/direction"
    end

  end
end
