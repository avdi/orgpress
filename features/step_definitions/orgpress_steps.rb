require 'pathname'

Given /^prerequisites have been fetched$/ do
  tmp_path.mkpath

  system({"OP_VENDOR_DIR" => (tmp_path + "vendor").to_s},
         "orgpress fetch-prerequisites > /dev/null")
end
