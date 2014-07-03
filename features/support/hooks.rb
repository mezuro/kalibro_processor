Before('@clear_test_dir') do
  `rm -rf /tmp/test`
end

After('@clear_repository') do
  `rm -rf #{@repository.code_directory}`
end