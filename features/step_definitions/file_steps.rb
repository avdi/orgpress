Given /^a file named "(.*?)"$/ do |name|
  step(%Q{a 1 byte file named "#{name}"})
end

When /^I unpack "(.*?)" into "(.*?)"$/ do |filename, dest|
  step(%Q(I run `unzip -d #{dest} #{filename}`))
end
