require 'rails_helper'

RSpec.describe ContactStatement, :vcr do
  before do
    class ExampleWork < ActiveFedora::Base
      property :contact, predicate: ::RDF::Vocab::DCAT.contactPoint, class_name: "ContactStatement"
      accepts_nested_attributes_for :contact
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  it 'creates a contact active triple resource with its attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      contact_attributes: [
        {
          label: 'Sword V2',
          email: 'sword@v2.com',
          address: '123 curiosity lane',
          telephone: '00 44 1234 567 890'
        }
      ]
    }
    expect(@obj.contact.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.contact.first.label).to eq ['Sword V2']
    expect(@obj.contact.first.email).to eq ['sword@v2.com']
    expect(@obj.contact.first.address).to eq ['123 curiosity lane']
    expect(@obj.contact.first.telephone).to eq ['00 44 1234 567 890']
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      contact_attributes: [
        {
          label: 'Sword V2',
          email: 'sword@v2.com',
          address: '123 curiosity lane',
          telephone: '00 44 1234 567 890'
        }
      ]
    }
    expect(@obj.contact.first.id).to include('#contact')
  end
end
