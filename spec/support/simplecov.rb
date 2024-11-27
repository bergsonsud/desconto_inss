# frozen_string_literal: true

require 'simplecov'

SimpleCov.start 'rails' do
  minimum_coverage 80
  maximum_coverage_drop 5

  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Services', 'app/services'
  add_group 'Jobs', 'app/jobs'
  add_group 'Libs', 'lib'
  add_group 'Validators', 'app/validators'

  # Ignore folders
  add_filter 'app/channels'
  add_filter 'app/mailers'
  add_filter 'app/models/application_record.rb'
  add_filter 'app/models/user.rb'
  add_filter 'app/helpers'
end
