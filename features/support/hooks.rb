Before('@clear_test_dir') do
  `rm -rf /tmp/test`
end

After('@clear_repository') do
  `rm -rf #{@repository.code_directory}`
end

After do |scenario|
  # Do something after each scenario.
  # The +scenario+ argument is optional, but
  # if you use it, you can inspect status with
  # the #failed?, #passed? and #exception methods.

  Rails.cache.clear
end