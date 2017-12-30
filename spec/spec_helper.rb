RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Excepton for deleting database-backed minter 
  include ActiveFedora::Noid::RSpec

  config.before(:suite) { disable_production_minter! }
  config.after(:suite) { enable_production_minter! }

end
