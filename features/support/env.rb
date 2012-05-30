require 'aruba/cucumber'
ENV['PATH'] = File.expand_path('../../bin',File.dirname(__FILE__)) +
  File::PATH_SEPARATOR + ENV['PATH'].to_s

Before('@slow') do
  @old_io_wait_seconds = @aruba_io_wait_seconds
  @aruba_io_wait_seconds = 5
end

After('@slow') do
  @aruba_io_wait_seconds = @old_io_wait_seconds
end

Before('@reallyslow') do
  @old_io_wait_seconds = @aruba_io_wait_seconds
  @aruba_io_wait_seconds = 10
end

After('@reallyslow') do
  @aruba_io_wait_seconds = @old_io_wait_seconds
end
