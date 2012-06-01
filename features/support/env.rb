require 'aruba/cucumber'
ENV['PATH'] = File.expand_path('../../bin',File.dirname(__FILE__)) +
  File::PATH_SEPARATOR + ENV['PATH'].to_s

module PathHelpers
  def tmp_path
    @tmp_path ||= Pathname("../../..").expand_path(__FILE__) + "tmp"
  end
end

World(PathHelpers)

Before do
  ENV['OP_VENDOR_DIR'] = (tmp_path + "vendor").to_s
end

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
