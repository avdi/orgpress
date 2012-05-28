require 'aruba/cucumber'
ENV['PATH'] = File.expand_path('../../bin',File.dirname(__FILE__)) +
  File::PATH_SEPARATOR + ENV['PATH'].to_s

Before do
  @aruba_io_wait_seconds = 5
end
