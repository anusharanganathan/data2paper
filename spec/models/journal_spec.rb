# Generated via
#  `rails generate hyrax:work Journal`
require 'rails_helper'

RSpec.describe Journal do
  it 'has human readable type journal' do
    @obj = build(:journal)
    expect(@obj.human_readable_type).to eq('Journal')
  end

  describe 'title' do
    it 'requires title' do
      @obj = build(:journal, title: nil)
      expect{@obj.save!}.to raise_error(ActiveFedora::RecordInvalid, 'Validation failed: Title Your journal must have a title.')
    end

    it 'has a multi valued title field' do
      @obj = build(:journal, title: ['test journal'])
      expect(@obj.title).to eq ['test journal']
    end
  end

  describe 'identifier' do
    it 'has a multi valued identifier' do
      @obj = build(:journal, identifier: ['14322342134'])
      # expect(@obj.identifier).to be_kind_of Array
      expect(@obj.identifier).to eq ['14322342134']
    end
  end

  describe 'publisher' do
    it 'has a multi valued publisher' do
      @obj = build(:journal, publisher: ['OUP'])
      # expect(@obj.publisher).to be_kind_of Array
      expect(@obj.publisher).to eq ['OUP']
    end
  end

  describe 'resource type' do
    it 'has a single valued resource type' do
      @obj = build(:journal, resource_type: ['Data journal'])
      # expect(@obj.resource_type).to be_kind_of Array
      expect(@obj.resource_type).to eq ['Data journal']
    end
  end

  describe 'description' do
    it 'has a multi valued description' do
      @obj = build(:journal, description: ['Data journal description'])
      # expect(@obj.description).to be_kind_of Array
      expect(@obj.description).to eq ['Data journal description']
    end
  end

  describe 'keyword' do
    it 'has a multi valued keyword' do
      @obj = build(:journal, keyword: ['Data journal keyword'])
      # expect(@obj.keyword).to be_kind_of Array
      expect(@obj.keyword).to eq ['Data journal keyword']
    end
  end

  describe 'subject' do
    it 'has a multi valued subject' do
      @obj = build(:journal, subject: ['Data journal subject'])
      # expect(@obj.subject).to be_kind_of Array
      expect(@obj.subject).to eq ['Data journal subject']
    end
  end

  describe 'language' do
    it 'has a multi valued language' do
      @obj = build(:journal, language: ['Data journal language'])
      # expect(@obj.language).to be_kind_of Array
      expect(@obj.language).to eq ['Data journal language']
    end
  end

  describe 'date_created' do
    it 'has a multi valued date created' do
      @obj = build(:journal, date_created: ['2017-12-15'])
      # expect(@obj.date_created).to be_kind_of Array
      expect(@obj.date_created).to eq ['2017-12-15']
    end
  end

  describe 'source' do
    it 'has a multi valued source' do
      @obj = build(:journal, source: ['Data2paper'])
      # expect(@obj.source).to be_kind_of Array
      expect(@obj.source).to eq ['Data2paper']
    end
  end

  describe 'homepage' do
    it 'has a multi valued homepage' do
      @obj = build(:journal, homepage: ['http://example.com'])
      # expect(@obj.homepage).to be_kind_of Array
      expect(@obj.homepage).to eq ['http://example.com']
    end

    it 'indexes the homepage' do
      @obj = build(:journal, homepage: [
        'http://example.com',
        'http://example2.com'
      ])
      @doc = @obj.to_solr
      expect(@doc['homepage_ssim']).to match_array([
        'http://example.com', 'http://example2.com'])
    end
  end

  describe 'editor' do
    it 'has a multi valued editor' do
      @obj = build(:journal, editor: ['Journal editor'])
      # expect(@obj.editor).to be_kind_of Array
      expect(@obj.editor).to eq ['Journal editor']
    end

    it 'indexes the editor' do
      @obj = build(:journal, editor: [
        'Journal editor 1',
        'Journal editor 2'
      ])
      @doc = @obj.to_solr
      expect(@doc['editor_tesim']).to match_array([
        'Journal editor 1', 'Journal editor 2'])
      expect(@doc['editor_sim']).to match_array([
        'Journal editor 1', 'Journal editor 2'])
    end
  end

  describe 'review process' do
    it 'has a multi valued review process' do
      @obj = build(:journal, review_process: ['review process'])
      # expect(@obj.review_process).to be_kind_of Array
      expect(@obj.review_process).to eq ['review process']
    end

    it 'indexes the review process' do
      @obj = build(:journal, review_process: ['review process'])
      @doc = @obj.to_solr
      expect(@doc['review_process_tesim']).to eq (['review process'])
    end
  end

  describe 'average publish lead time' do
    it 'has a single valued average_publish_lead_time' do
      @obj = build(:journal, average_publish_lead_time: '42 weeks')
      # expect(@obj.average_publish_lead_time).to be_kind_of String
      expect(@obj.average_publish_lead_time).to eq '42 weeks'
    end
  end

  describe 'article guidelines' do
    it 'has a multi valued article guidelines' do
      @obj = build(:journal, article_guidelines: ['Journal publishing guidelines'])
      # expect(@obj.article_guidelines).to be_kind_of Array
      expect(@obj.article_guidelines).to eq ['Journal publishing guidelines']
    end

    it 'indexes the article guidelines' do
      @obj = build(:journal, article_guidelines: ['Journal publishing guidelines'])
      @doc = @obj.to_solr
      expect(@doc['article_guidelines_tesim']).to eq (['Journal publishing guidelines'])
    end
  end

  describe 'needs_apc' do
    it 'has a single valued needs_apc' do
      @obj = build(:journal, needs_apc: 'Yes')
      # expect(@obj.needs_apc).to be_kind_of String
      expect(@obj.needs_apc).to eq 'Yes'
    end

    it 'indexes needs_apc' do
      @obj = build(:journal, needs_apc: 'Yes')
      @doc = @obj.to_solr
      expect(@doc['needs_apc_ssi']).to eq ('Yes')
      expect(@doc['needs_apc_sim']).to eq (['Yes'])
    end
  end

  describe 'apc_statement' do
    it 'has a multi valued apc_statement' do
      @obj = build(:journal, apc_statement: ['APC statement'])
      # expect(@obj.apc_statement).to be_kind_of Array
      expect(@obj.apc_statement).to eq ['APC statement']
    end

    it 'indexes the apc_statement' do
      @obj = build(:journal, apc_statement: ['APC statement'])
      @doc = @obj.to_solr
      expect(@doc['apc_statement_tesim']).to eq (['APC statement'])
    end
  end

  describe 'oa_statement' do
    it 'has a multi valued oa_statement' do
      @obj = build(:journal, oa_statement: ['Open access statement'])
      # expect(@obj.oa_statement).to be_kind_of Array
      expect(@obj.oa_statement).to eq ['Open access statement']
    end

    it 'indexes the oa_statement' do
      @obj = build(:journal, oa_statement: ['Open access statement'])
      @doc = @obj.to_solr
      expect(@doc['oa_statement_tesim']).to eq (['Open access statement'])
    end
  end

  describe 'oa_level' do
    it 'has a single valued oa_level' do
      @obj = build(:journal, oa_level: 'Green')
      # expect(@obj.oa_level).to be_kind_of String
      expect(@obj.oa_level).to eq 'Green'
    end

    it 'indexes oa_level' do
      @obj = build(:journal, oa_level: 'Green')
      @doc = @obj.to_solr
      expect(@doc['oa_level_ssi']).to eq ('Green')
      expect(@doc['oa_level_sim']).to eq (['Green'])
    end
  end

  describe 'supported_license' do
    it 'has a multi valued supported_license' do
      @obj = build(:journal, supported_license: ['License 1', 'License 2'])
      # expect(@obj.supported_license).to be_kind_of Array
      expect(@obj.supported_license).to eq ['License 1', 'License 2']
    end

    it 'indexes the supported_license' do
      @obj = build(:journal, supported_license: ['License 1'])
      @doc = @obj.to_solr
      expect(@doc['supported_license_tesim']).to eq (['License 1'])
    end
  end

  describe 'declaration_statement' do
    it 'has a multi valued declaration_statement' do
      @obj = build(:journal, declaration_statement: ['declaration statement'])
      # expect(@obj.declaration_statement).to be_kind_of Array
      expect(@obj.declaration_statement).to eq ['declaration statement']
    end

    it 'indexes the declaration_statement' do
      @obj = build(:journal, declaration_statement: ['declaration statement'])
      @doc = @obj.to_solr
      expect(@doc['declaration_statement_tesim']).to eq (['declaration statement'])
    end
  end

  describe 'owner' do
    it 'has a multi valued owner' do
      @obj = build(:journal, owner: ['Journal owner'])
      # expect(@obj.owner).to be_kind_of Array
      expect(@obj.owner).to eq ['Journal owner']
    end
  end

  describe 'agent_group' do
    it 'has a multi valued agent_group' do
      @obj = build(:journal, agent_group: ['Journal owner group'])
      # expect(@obj.agent_group).to be_kind_of Array
      expect(@obj.agent_group).to eq ['Journal owner group']
    end
  end

  describe 'nested attributes for account' do
    it 'accepts account attributes' do
      @obj = build(:journal, account_attributes: [{
            label: 'SwordV2',
            account_name: 'Journal sword',
            account_type: 'Sword V2',
            service_homepage: 'http://example.com',
            service_key: '<qwe>qweqew</qwe>',
            service_format: 'DC',
            service_email: 'submit.journal@example.com'
          }]
      )
      expect(@obj.account.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.account.first.label).to eq ['SwordV2']
      expect(@obj.account.first.account_name).to eq ['Journal sword']
      expect(@obj.account.first.service_homepage).to eq ['http://example.com']
      expect(@obj.account.first.service_key).to eq ['<qwe>qweqew</qwe>']
      expect(@obj.account.first.service_format).to eq ['DC']
    end

    it 'has the correct uri' do
      @obj = build(:journal, account_attributes: [{
            label: 'SwordV2',
            account_name: 'Journal email submission',
            account_type: 'Email V2',
            service_homepage: 'http://example.com',
            service_key: '<qwe>qweqew</qwe>',
            service_format: 'Email format',
            service_email: 'submit.journal@example.com'
          }]
      )
      expect(@obj.account.first.id).to include('#account')
    end

    it 'rejects account attributes if account type, format and one of homepage, key, or email is blank' do
      @obj = build(:journal, account_attributes: [{
            account_type: 'Sword V2',
            service_format: 'DC',
            service_homepage: 'http://example.com',
            service_key: '<qwe>qweqew</qwe>'
          }, {
            account_type: 'Sword V2',
            service_format: 'DC',
            service_email: 'sword@example.com'
          }, {
            account_type: 'Sword V2',
            service_format: 'DC',
            service_homepage: 'http://example.com'
          }, {
            account_type: 'Sword V2',
            service_format: 'DC',
            service_key: '<qwe>qweqew</qwe>'
          }, {
            service_format: 'DC',
            service_homepage: 'http://example.com',
            service_key: '<qwe>qweqew</qwe>'
          }, {
            account_type: 'Sword V2',
            service_homepage: 'http://example.com',
            service_key: '<qwe>qweqew</qwe>'
          }, {
            account_type: 'Sword V2',
            service_email: 'sword@example.com'
          }, {
            account_type: 'Sword V2',
            service_format: 'DC',
          }, {
            service_format: 'DC',
            service_email: 'sword@example.com'
          }, {
            label: 'Sword'
          }, {
            account_type: 'Sword V2'
          }
        ]
      )
      expect(@obj.account.size).to eq(2)
    end

    it 'destroys account' do
      @obj = build(:journal, account_attributes: [{
          account_type: 'Sword V2',
          service_format: 'DC',
          service_homepage: 'http://example.com',
          service_key: '<qwe>qweqew</qwe>'
        }]
      )
      expect(@obj.account.size).to eq(1)
      @obj.attributes = {
        account_attributes: [{
          id: @obj.account.first.id,
          account_type: 'Sword V2',
          service_format: 'DC',
          service_homepage: 'http://example.com',
          service_key: '<qwe>qweqew</qwe>',
          _destroy: "1"
        }]
      }
      expect(@obj.account.size).to eq(0)
    end

    it 'indexes the account' do
      @obj = build(:journal, account_attributes: [{
          label: 'Sword',
          account_name: 'Journal sword',
          account_type: 'Sword V2',
          service_format: 'DC',
          service_homepage: 'http://example.com',
          service_key: '<qwe>qweqew</qwe>'
        }, {
          label: 'Email',
          account_name: 'Journal email',
          account_type: 'Email',
          service_format: 'Email format',
          service_email: 'sword@example.com'
        }]
      )
      @doc = @obj.to_solr
      expect(@doc).to include('account_ssm')
      expect(@doc['account_type_sim']).to match_array ['Sword V2', 'Email']
    end
  end

  describe 'nested attributes for contact' do
    it 'accepts contact attributes' do
      @obj = build(:journal, contact_attributes: [{
            label: 'Journal',
            email: 'journal@example.com',
            address: '123 curiosity lane',
            telephone: '1234 567 890'
          }]
      )
      expect(@obj.contact.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.contact.first.label).to eq ['Journal']
      expect(@obj.contact.first.email).to eq ['journal@example.com']
      expect(@obj.contact.first.address).to eq ['123 curiosity lane']
      expect(@obj.contact.first.telephone).to eq ['1234 567 890']
    end

    it 'has the correct uri' do
      @obj = build(:journal, contact_attributes: [{
            email: 'journal@example.com'
          }]
      )
      expect(@obj.contact.first.id).to include('#contact')
    end

    it 'rejects contact attributes if email, address and telephone is blank' do
      @obj = build(:journal, contact_attributes: [{
            email: 'journal@example.com',
            address: '123 curiosity lane',
            telephone: '1234 567 890'
          }, {
            email: 'journal@example.com'
          }, {
            address: '123 curiosity lane'
          }, {
            telephone: '1234 567 890'
          }, {
            label: 'DC',
          }
        ]
      )
      expect(@obj.contact.size).to eq(4)
    end

    it 'destroys contact' do
      @obj = build(:journal, contact_attributes: [{
          label: 'Journal',
          email: 'journal@example.com',
          address: '123 curiosity lane',
          telephone: '1234 567 890'
        }]
      )
      expect(@obj.contact.size).to eq(1)
      @obj.attributes = {
        contact_attributes: [{
          id: @obj.contact.first.id,
          label: 'Journal',
          email: 'journal@example.com',
          address: '123 curiosity lane',
          telephone: '1234 567 890',
          _destroy: "1"
        }]
      }
      expect(@obj.contact.size).to eq(0)
    end

    it 'indexes the contact' do
      @obj = build(:journal, contact_attributes: [{
          label: 'Journal',
          email: 'journal@example.com',
          address: '123 curiosity lane',
          telephone: '1234 567 890'
        }, {
          email: 'journal@example.com'
        }, {
          address: '123 curiosity lane'
        }, {
          label: 'Editor',
          telephone: '1234 567 890'
        }]
      )
      @doc = @obj.to_solr
      expect(@doc).to include('contact_ssm')
      expect(@doc['contact_label_sim']).to match_array ['Journal', 'Editor']
    end
  end

  describe 'associated with data paper' do
    it "have many data papers" do
      t = Journal.reflect_on_association(:data_papers)
      expect(t.macro).to eq(:has_many)
    end
  end

end
