require 'pathname'

Given /^a file named "(.*?)"$/ do |name|
  step(%Q{a 1 byte file named "#{name}"})
end

Given /^an executable file named "(.*?)" with:$/ do |filename, contents|
  step(%Q(a file named "#{filename}" with:), contents)
  Pathname(filename).expand_path(current_dir).chmod(0755)
end

When /^I unpack "(.*?)" into "(.*?)"$/ do |filename, dest|
  step(%Q(I run `unzip -d #{dest} #{filename}`))
end
