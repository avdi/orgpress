When /^I set "(.*?)" to "(.*?)"$/ do |name, value|
  ENV[name]=value
end

When /^I unset "(.*?)"$/ do |name|
  ENV.delete(name)
end
