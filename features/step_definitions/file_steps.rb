Given /^a file named "(.*?)"$/ do |name|
  step(%Q{a 1 byte file named "#{name}"})
end
