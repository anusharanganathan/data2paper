require 'rails_helper'

RSpec.describe AccountStatement do
  before do
    class ExampleWork < ActiveFedora::Base
      property :account, predicate: ::RDF::Vocab::FOAF.account, class_name:"AccountStatement"
      accepts_nested_attributes_for :account
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  it 'creates an account active triple resource with its attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      account_attributes: [
        {
          label: 'Sword V2',
          account_type: 'Sword V2',
          account_name: 'Journal sword',
          service_email: 'submission@journal.com',
          service_homepage: 'http://example.com/swordv2',
          service_key: 'asdfwefqwerqwreqwre',
          service_format: ['DC', 'MODS']
        }
      ]
    }
    expect(@obj.account.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.account.first.label).to eq ['Sword V2']
    expect(@obj.account.first.account_type).to eq ['Sword V2']
    expect(@obj.account.first.account_name).to eq ['Journal sword']
    expect(@obj.account.first.service_homepage).to eq ['http://example.com/swordv2']
    expect(@obj.account.first.service_email).to eq ['submission@journal.com']
    expect(@obj.account.first.service_key).to eq ['asdfwefqwerqwreqwre']
    expect(@obj.account.first.service_format).to eq ['DC', 'MODS']
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      account_attributes: [
        {
          label: 'Sword V2',
          account_type: 'Sword V2',
          account_name: 'Journal_sword',
          service_email: 'submission@journal.com',
          service_homepage: 'http://example.com/swordv2',
          service_key: 'asdfwefqwerqwreqwre',
          service_format: ['DC', 'MODS']
        }
      ]
    }
    expect(@obj.account.first.id).to include('#account')
  end
end
