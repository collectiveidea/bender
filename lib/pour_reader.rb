MESSAGE_DELAY = 0.5
GC_DELAY = 5
SELECT_DELAY = 0.5

@pin = ARGV[0]
@timeout = ARGV[1].to_i
@pin_file = File.open("/sys/class/gpio/gpio#{@pin}/value", "r")
@running = true

Signal.trap(:INT)  { @running = false }
Signal.trap(:TERM) { @running = false }
Signal.trap(:QUIT) { @running = false }

$stdout.sync = true

@read_group = [@pin_file]

def read
  @pin_file.rewind
  @pin_file.read
end

def wait_for_change
  read
  begin
    ready = IO.select(nil, nil, @read_group, SELECT_DELAY)
  end while !ready && @running && (!block_given? || yield)
  ready
end

def send_message
  $stdout.puts "#{@pin},#{@first_tick},#{@last_tick},#{@ticks}"
  $stdout.flush
  @last_message = Time.now
end

GC.start
$stdout.puts "ready"
$stdout.flush
# Loop while we are running or a pour is in progress
while @running
  # Wait for a pour to start
  ticked = wait_for_change

  break if !@running

  # Prevent GC from running during the pour
  # GC.disable
  # Rescue block so we always re-enable GC
  begin
    @now = Time.now
    @first_tick = @last_tick = @now.to_f
    @ticks = 1

    send_message

    while (@now.to_f - @last_tick) < @timeout
      ticked = wait_for_change do
        now = Time.now
        (now.to_f - @last_tick) < @timeout && (now - @last_message) < MESSAGE_DELAY
      end

      @now = Time.now

      if ticked
        @last_tick = @now.to_f
        @ticks += 1
      end

      send_message if @now - @last_message > MESSAGE_DELAY
    end
  ensure
    # GC.enable
    GC.start
  end
end

$stdout.puts "Done"
