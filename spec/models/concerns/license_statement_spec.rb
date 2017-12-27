require 'rails_helper'

RSpec.describe LicenseStatement, :vcr do
  before do
    class ExampleWork < ActiveFedora::Base
      property :license_nested, predicate: ::RDF::Vocab::DC.rights, class_name:"LicenseStatement"
      accepts_nested_attributes_for :license_nested
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  it 'creates a rights active triple resource with an id, label, definition and webpage' do
    @obj = ExampleWork.new
    @obj.attributes = {
      license_nested_attributes: [
        {
          label: 'A rights label',
          definition: 'A definition of the rights',
          webpage: 'http://example.com/rights'
        }
      ]
    }
    expect(@obj.license_nested.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.license_nested.first.label).to eq ['A rights label']
    expect(@obj.license_nested.first.definition).to eq ['A definition of the rights']
    expect(@obj.license_nested.first.webpage).to eq ['http://example.com/rights']
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      license_nested_attributes: [
        {
          label: 'A rights label',
          definition: 'A definition of the rights',
          webpage: 'http://example.com/rights'
        }
      ]
    }
    expect(@obj.license_nested.first.id).to include('#rights')
  end
end
