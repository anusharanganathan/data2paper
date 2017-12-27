module RDF
  module Vocab
    class DatapaperTerms < RDF::Vocabulary("http://data2paper.org/vocabularies/datapaperterms#")
      # property :dataPaper

      property :SwordAccount #sub class of FOAF:OnlineAccount
      property :JournalSwordAccount #sub class of FOAF:OnlineAccount
      property :accountServiceKey
      property :articleGuidelines
      property :reviewProcess
      property :averagePublishLeadTime
      property :needsArticleProcessingCharge
      property :articleProcessingChargeStatement
      property :openAccessStatement
      property :openAccessLevel
      property :supportedLicense
      property :declarationStatement
      property :agreementAccepted
    end
  end
end
