# Generated via
#  `rails generate hyrax:work DataPaper`
require 'rails_helper'

RSpec.describe DataPaper do
  it 'has human readable type data paper' do
    @obj = build(:data_paper)
    expect(@obj.human_readable_type).to eq('Data paper')
  end

  describe 'title' do
    it 'requires title' do
      @obj = build(:data_paper, title: nil)
      #@obj.save!
      expect{@obj.save!}.to raise_error(ActiveFedora::RecordInvalid, 'Validation failed: Title Your data paper must have a title.')
    end

    it 'has a multi valued title field' do
      @obj = build(:data_paper, title: ['test data paper'])
      expect(@obj.title).to eq ['test data paper']
    end
  end

  describe 'status' do
    it 'has a single valued status' do
      @obj = build(:data_paper, status: 'In progress')
      expect(@obj.status).to be_kind_of String
      expect(@obj.status).to eq 'In progress'
    end
  end

  describe 'statement_agreed' do
    it 'has statement_agreed' do
      @obj = build(:data_paper, statement_agreed: 'True')
      expect(@obj.statement_agreed).to be_kind_of String
      expect(@obj.statement_agreed).to eq 'True'
    end
  end

  describe 'tagged_version' do
    it 'has tagged_version' do
      @obj = build(:data_paper, tagged_version: '1.0')
      expect(@obj.tagged_version).to be_kind_of String
      expect(@obj.tagged_version).to eq '1.0'
    end
  end

  describe 'note' do
    it 'has note' do
      @obj = build(:data_paper, note: 'Some note')
      expect(@obj.note).to be_kind_of String
      expect(@obj.note).to eq 'Some note'
    end
  end

  describe 'nested attributes for date' do
    it 'accepts date attributes' do
      @obj = build(:data_paper, date_attributes: [{
        date: '2017-01-01',
        description: 'Date definition'
      }])
      expect(@obj.date.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.date.first.date).to eq ['2017-01-01']
      expect(@obj.date.first.description).to eq ['Date definition']
    end

    it 'has the correct uri' do
      @obj = build(:data_paper, date_attributes: [{
        date: '2017-01-01',
        description: 'Date definition'
      }])
      expect(@obj.date.first.id).to include('#date')
    end

    it 'rejects date attributes if date is blank' do
      @obj = build(:data_paper, date_attributes: [{
          date: '2017-01-01',
          description: 'date definition'
        }, {
          description: 'Date definition'
        }, {
          date: '2018-01-01'
        }, {
          date: ''
        }
      ])
      expect(@obj.date.size).to eq(2)
    end

    it 'destroys date' do
      @obj = build(:data_paper, date_attributes: [{
        date: '2017-01-01',
        description: 'date definition'
      }])
      expect(@obj.date.size).to eq(1)
      @obj.attributes = {
        date_attributes: [{
          id: @obj.date.first.id,
          date: '2017-01-01',
          description: 'date definition',
          _destroy: "1"
        }]
      }
      expect(@obj.date.size).to eq(0)
    end

    it 'indexes the date' do
      @obj = build(:data_paper, date_attributes: [{
          date: '2017-01-01',
          description: 'http://purl.org/dc/terms/dateAccepted',
        }, {
          date: '2018-01-01'
        }]
      )
      @doc = @obj.to_solr
      expect(@doc).to include('date_ssm')
      expect(@doc['date_tesim']).to match_array(['2017-01-01', '2018-01-01'])
      expect(@doc['date_accepted_ssi']).to match_array(['2017-01-01'])
    end
  end

  describe 'nested attributes for creator' do
    it 'accepts person attributes' do
      @obj = build(:data_paper,  creator_nested_attributes: [{
          first_name: 'Foo',
          last_name: 'Bar',
          name: 'Hello world',
          orcid: '0000-0000-0000-0000',
          affiliation: 'Author affiliation',
          role: 'Author'
        }]
      )
      expect(@obj.creator_nested.size).to eq(1)
      expect(@obj.creator_nested[0]).to be_kind_of ActiveTriples::Resource
    end

    it 'has the correct uri' do
      @obj = build(:data_paper,  creator_nested_attributes: [{
          first_name: 'Foo',
          last_name: 'Bar',
          orcid: '0000-0000-0000-0000',
          affiliation: 'Author affiliation',
          role: 'Author'
        }]
      )
      expect(@obj.creator_nested.first.id).to include('#person')
    end

    it 'rejects person if first name, last name or name is blank' do
      @obj = build(:data_paper, creator_nested_attributes: [
        {
          first_name: 'Foo',
          last_name: 'Bar'
        }, {
          name: 'Foo Bar',
        }, {
          name: 'Foo Bar',
          role: 'Author',
          orcid: '0000-0000-0000-0000',
        }, {
          first_name: 'Foo'
        }, {
          last_name: 'Bar',
        }, {
          orcid: '0000-0000-0000-0000',
          role: 'Creator'
        }, {
          first_name: '',
          last_name: nil,
          role: 'Author'
        }
      ])
      expect(@obj.creator_nested.size).to eq(5)
    end

    #it 'rejects person if orcid is blank' do
    #  @obj = build(:data_paper, creator_nested_attributes: [
    #    {
    #      first_name: 'Foo',
    #      last_name: 'Bar',
    #      role: 'Author'
    #    },
    #    {
    #      first_name: 'Foo',
    #      last_name: 'Bar',
    #      orcid: '',
    #      role: 'Author'
    #    }
    #  ])
    #  expect(@obj.creator_nested.size).to eq(0)
    #end

    #it 'rejects person if role is blank' do
    #  @obj = build(:data_paper, creator_nested_attributes: [
    #    {
    #      first_name: 'Foo',
    #      last_name: 'Bar',
    #      orcid: '0000-0000-0000-0000'
    #    },
    #    {
    #      first_name: 'Foo',
    #      last_name: 'Bar',
    #      orcid: '0000-0000-0000-0000',
    #      affiliation: 'Author affiliation',
    #      role: nil
    #    }
    #  ])
    #  expect(@obj.creator_nested.size).to eq(0)
    #end

    it 'rejects person if all are blank' do
      @obj = build(:data_paper, creator_nested_attributes: [
        {
          first_name: '',
          last_name: nil,
          role: nil
        }
      ])
      expect(@obj.creator_nested.size).to eq(0)
    end

    it 'destroys creator' do
      @obj = build(:data_paper, creator_nested_attributes: [{
        first_name: 'Foo',
        last_name: 'Bar',
        orcid: '0000-0000-0000-0000',
        affiliation: 'Author affiliation',
        role: 'Author'
      }])
      expect(@obj.creator_nested.size).to eq(1)
      @obj.attributes = {
        creator_nested_attributes: [{
          id: @obj.creator_nested.first.id,
          first_name: 'Foo',
          last_name: 'Bar',
          orcid: '0000-0000-0000-0000',
          affiliation: 'Author affiliation',
          role: 'Author',
          _destroy: "1"
        }]
      }
      expect(@obj.creator_nested.size).to eq(0)
    end

    it 'indexes the creator' do
      @obj = build(:data_paper, creator_nested_attributes: [{
          first_name: ['Foo'],
          last_name: 'Bar',
          orcid: '0000-0000-0000-0000',
          role: 'Author'
        }, {
          name: 'Lorem Ipsum',
          role: 'Author',
          orcid: '0000-0000-0000-0001',
        }
      ])
      @doc = @obj.to_solr
      expect(@doc['creator_nested_sim']).to match_array(['Foo Bar', 'Lorem Ipsum'])
      expect(@doc['creator_nested_tesim']).to match_array(['Foo Bar', 'Lorem Ipsum'])
      expect(@doc).to include('creator_nested_ssm')
    end

    it 'extracts the creator names' do
      @obj = build(:data_paper, creator_nested_attributes: [{
          first_name: ['Foo'],
          last_name: 'Bar',
          orcid: '0000-0000-0000-0000',
          role: 'Author'
        }, {
          name: 'Lorem Ipsum',
          role: 'Author',
          orcid: '0000-0000-0000-0001',
        }
      ])
      expect(@obj.creator_names).to match_array(['Foo Bar', 'Lorem Ipsum'])
    end
  end

  describe 'nested attributes for relation' do
    it 'accepts relation attributes' do
      @obj = build(:data_paper, relation_attributes: [
        {
          label: 'A relation label',
          url: 'http://example.com/relation',
          identifier: '123456',
          identifier_scheme: 'local',
          relationship_name: 'Is part of',
          relationship_role: 'http://example.com/isPartOf'
        }
      ])
      expect(@obj.relation.size).to eq 1
      expect(@obj.relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.relation.first.label).to eq ['A relation label']
      expect(@obj.relation.first.url).to eq ['http://example.com/relation']
      expect(@obj.relation.first.identifier).to eq ['123456']
      expect(@obj.relation.first.identifier_scheme).to eq ['local']
      expect(@obj.relation.first.relationship_name).to eq ['Is part of']
      expect(@obj.relation.first.relationship_role).to eq ['http://example.com/isPartOf']
    end

    it 'has the correct uri' do
      @obj = build(:data_paper, relation_attributes: [{
          label: 'A relation label',
          url: 'http://example.com/relation',
          identifier: '123456',
          identifier_scheme: 'local',
          relationship_name: 'Is part of',
          relationship_role: 'http://example.com/isPartOf'
        }]
      )
      expect(@obj.relation.first.id).to include('#relation')
    end

    it 'rejects relation if label is blank' do
      @obj = build(:data_paper, relation_attributes: [{
          label: 'Test label',
          url: 'http://example.com/url',
          identifier: '123456',
          relationship_name: 'Is part of',
          relationship_role: 'http://example.com/isPartOf'
        }, {
          label: '',
          url: 'http://example.com/url',
          identifier: '123456',
          relationship_name: 'Is part of',
          relationship_role: 'http://example.com/isPartOf'
        }, {
          url: 'http://example.com/url',
          identifier: '123456',
          relationship_name: 'Is part of',
          relationship_role: 'http://example.com/isPartOf'
        }]
      )
      expect(@obj.relation.size).to eq(1)
    end

    it 'rejects relation if url or identifier is blank' do
      @obj = build(:data_paper, relation_attributes: [{
          label: 'Test label',
          url: 'http://example.com/url',
          identifier: '123456',
          relationship_name: 'Is part of',
          relationship_role: 'http://example.com/isPartOf'
        }, {
          label: 'Test label',
          identifier: '123456',
          relationship_name: 'Is part of',
          relationship_role: 'http://example.com/isPartOf'
        }, {
          label: 'Test label',
          url: 'http://example.com/url',
          relationship_name: 'Is part of',
          relationship_role: 'http://example.com/isPartOf'
        }, {
          label: 'Test label',
          url: '',
          identifier: nil,
          relationship_name: 'Is part of',
          relationship_role: 'http://example.com/isPartOf'
        }, {
          label: 'Test label',
          relationship_name: 'Is part of',
          relationship_role: 'http://example.com/isPartOf'
        }]
      )
      expect(@obj.relation.size).to eq(3)
    end

    it 'rejects relation if relationship role or relationship name blank' do
      @obj = build(:data_paper, relation_attributes: [{
          label: 'Test label',
          url: 'http://example.com/url',
          identifier: '123456',
          relationship_name: 'Is part of',
          relationship_role: 'http://example.com/isPartOf'
        }, {
          label: 'Test label',
          url: 'http://example.com/url',
          identifier: '123456',
          relationship_name: 'Is part of'
        }, {
          label: 'Test label',
          url: 'http://example.com/url',
          identifier: '123456',
          relationship_role: 'http://example.com/isPartOf'
        }, {
          label: 'Test label',
          url: 'http://example.com/url',
          identifier: '123456',
          relationship_name: '',
          relationship_role: nil
        }, {
          label: 'Test label',
          url: 'http://example.com/url',
          identifier: '123456',
        }]
      )
      expect(@obj.relation.size).to eq(3)
    end

    it 'destroys relation' do
      @obj = build(:data_paper, relation_attributes: [{
          label: 'test label',
          url: 'http://example.com/relation',
          relationship_name: 'Is part of'
          }]
      )
      expect(@obj.relation.size).to eq(1)
      @obj.attributes = {
        relation_attributes: [{
          id: @obj.relation.first.id,
          label: 'test label',
          url: 'http://example.com/relation',
          relationship_name: 'Is part of',
          _destroy: "1"
        }]
      }
      expect(@obj.relation.size).to eq(0)
    end

    it 'indexes relation' do
      @obj = build(:data_paper, relation_attributes: [{
        label: 'test label',
        url: 'http://example.com/relation',
        identifier: '123456',
        relationship_name: 'Is part of'
      }])
      @doc = @obj.to_solr
      expect(@doc).to include('relation_ssm')
      expect(@doc['relation_url_sim']).to eq ['http://example.com/relation']
      expect(@doc['relation_id_sim']).to eq ['123456']
    end
  end

  describe 'nested attributes for rights' do
    it 'accepts rights attributes' do
      @obj = build(:data_paper, license_nested_attributes: [{
            label: 'A rights label',
            definition: 'A definition of the rights',
            webpage: 'http://example.com/rights',
            start_date: '2017-12-21'
          }]
      )
      expect(@obj.license_nested.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.license_nested.first.label).to eq ['A rights label']
      expect(@obj.license_nested.first.definition).to eq ['A definition of the rights']
      expect(@obj.license_nested.first.webpage).to eq ['http://example.com/rights']
      expect(@obj.license_nested.first.start_date).to eq ['2017-12-21']
    end

    it 'has the correct uri' do
      @obj = build(:data_paper, license_nested_attributes: [{
            label: 'A rights label',
            definition: 'A definition of the rights',
            webpage: 'http://example.com/rights',
            start_date: '2017-12-21'
          }]
      )
      expect(@obj.license_nested.first.id).to include('#rights')
    end

    it 'rejects rights attributes if label, definition and webpage attribute is blank' do
      @obj = build(:data_paper, license_nested_attributes: [{
            label: 'A rights label'
          }, {
            definition: 'A definition of the rights'
          }, {
            webpage: 'http://example.com/rights'
          }, {
            start_date: '2017-12-21'
          }, {
            label: '',
            definition: nil,
            webpage: ''
          }]
      )
      expect(@obj.license_nested.size).to eq(3)
    end

    it 'destroys rights' do
      @obj = build(:data_paper, license_nested_attributes: [{
            label: 'test label'
          }]
      )
      expect(@obj.license_nested.size).to eq(1)
      @obj.attributes = {
        license_nested_attributes: [{
            id: @obj.license_nested.first.id,
            label: 'test label',
            _destroy: "1"
          }]
      }
      expect(@obj.license_nested.size).to eq(0)
    end

    it 'indexes the rights' do
      @obj = build(:data_paper, license_nested_attributes: [{
            label: 'A rights label',
            definition: 'A definition of the rights',
            webpage: 'http://example.com/rights'
          }, {
            label: 'A 2nd rights label',
            webpage: 'http://example.com/rights_2nd'
          }]
      )
      @doc = @obj.to_solr
      expect(@doc['license_nested_sim']).to match_array(
        ['http://example.com/rights', 'http://example.com/rights_2nd'])
      expect(@doc).to include('license_nested_tesim')
    end
  end

  it "should belong to journal" do
    t = DataPaper.reflect_on_association(:journal)
    expect(t.macro).to eq(:belongs_to)
  end

  describe 'should gate edits based on status' do
    it 'should allow edits for new' do
      @obj = build(:data_paper, status: 'new')
      expect(@obj.status_allows_edit?).to be true
    end
    it 'should allow edits for draft' do
      @obj = build(:data_paper, status: 'draft')
      expect(@obj.status_allows_edit?).to be true
    end
    it 'should not allow edits for submitted' do
      @obj = build(:data_paper, status: 'submitted')
      expect(@obj.status_allows_edit?).to be false
    end
    it 'should allow edits for published' do
      @obj = build(:data_paper, status: 'published')
      expect(@obj.status_allows_edit?).to be false
    end
  end

  describe 'should check for required metadata' do
    it 'should return false if no creators' do
      @obj = build(:data_paper, license_nested_attributes: [{
          label: 'A rights label',
          definition: 'A definition of the rights',
          webpage: 'http://example.com/rights',
          start_date: '2017-12-21'
        }],
        status: 'new',
        subject: ['test', 'try'],
        date_attributes: [{
          date: '2017-01-01',
          description: 'Date definition'
        }]
      )
      expect(@obj.has_required_metadata?).to be false
    end

    it 'should have title and creator' do
      @obj = build(:data_paper, license_nested_attributes: [{
          label: 'A rights label',
          definition: 'A definition of the rights',
          webpage: 'http://example.com/rights',
          start_date: '2017-12-21'
        }],
        status: 'new',
        subject: ['test', 'try'],
        date_attributes: [{
          date: '2017-01-01',
          description: 'Date definition'
        }],
        creator_nested_attributes: [{
          first_name: ['Foo'],
          last_name: 'Bar',
          orcid: '0000-0000-0000-0000',
          role: 'Author'
        }, {
          name: 'Lorem Ipsum',
          role: 'Author',
          orcid: '0000-0000-0000-0001',
        }]
      )
      expect(@obj.has_required_metadata?).to be true
    end
  end

  describe 'should have required files' do
    it 'should require file of type data paper' do
      @f = build(:file_set, resource_type: ['data paper'])
      @obj = build(:data_paper)
      @obj.members << @f
      expect(@obj.has_required_files?).to be true
    end

    it 'should not require files of type other than data paper' do
      @f = build(:file_set, resource_type: ['supplementary file'])
      @f2 = build(:file_set, resource_type: ['metadata'])
      @obj = build(:data_paper)
      @obj.members << @f
      @obj.members << @f2
      expect(@obj.has_required_files?).to be false
    end

    it 'should require any one file of type data paper' do
      @f = build(:file_set, resource_type: ['data paper'])
      @f2 = build(:file_set, resource_type: ['supplementary file'])
      @f3 = build(:file_set, resource_type: ['metadata'])
      @obj = build(:data_paper)
      @obj.members << @f
      @obj.members << @f2
      @obj.members << @f3
      expect(@obj.has_required_files?).to be true
    end
  end
  
  describe 'should require journal' do
    it 'should return false if no associated journal' do
      @obj = build(:data_paper)
      expect(@obj.has_required_journal?).to be false
    end

    it 'should return true if it has associated journal' do
      @j = build(:journal)
      @obj = build(:data_paper)
      @obj.journal = @j
      expect(@obj.has_required_journal?).to be true
    end
  end

  describe 'should require license' do
    it 'should return true if webpage' do
      @obj = build(:data_paper, license_nested_attributes: [{
        label: 'A rights label',
        webpage: 'http://example.com/rights'
      }])
      expect(@obj.has_required_license?).to be true
    end

    it 'should return false if no webpage' do
      @obj = build(:data_paper, license_nested_attributes: [{
        label: 'A rights label',
        definition: 'A definition of the rights',
        start_date: '2017-12-21'
      }])
      expect(@obj.has_required_license?).to be false
    end
  end

  describe 'ahould require agreement be accepted' do
    it 'should return true if binary value stored as 1' do
      @obj = build(:data_paper, statement_agreed: '1')
      expect(@obj.has_required_agreement?).to be true
    end

    it 'should return true if binary value stored as true' do
      @obj = build(:data_paper, statement_agreed: true)
      expect(@obj.has_required_agreement?).to be true
    end

    it 'should return false if binary value stored as 0' do
      @obj = build(:data_paper, statement_agreed: '0')
      expect(@obj.has_required_agreement?).to be false
    end

    it 'should return false if binary value stored as false' do
      @obj = build(:data_paper, statement_agreed: false)
      expect(@obj.has_required_agreement?).to be false
    end
  end

end
