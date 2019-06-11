control 'check_website' do

  describe http(attribute("customized_inspec_attribute")) do
    its('status') { should cmp 200 }
    its('body') { should match 'repositoryCreatedWithTerraform' }
  end

end
