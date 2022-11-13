Rails.autoloaders.each do |autoloader|
  autoloader.ignore("#{__dir__}/../../app/frontend")
end