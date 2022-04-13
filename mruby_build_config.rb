MRuby::Build.new do |conf|
  # load specific toolchain settings
  conf.toolchain

  # include the GEM box
  conf.gembox "default"

  conf.gem core: "mruby-io"
  conf.gem github: "ksss/mruby-signal"
  conf.gem github: "iij/mruby-env"

  # Turn on `enable_debug` for better debugging
  # conf.enable_debug
  conf.enable_bintest
  conf.enable_test
end
