require 'scholix_importer'

class Admin::FetchPublicationController < ApplicationController
  with_themed_layout '1_column'

  def show
    if params.fetch('pid', nil)
      s = ScholixImporter.new()
      @publications = s.linksFromPid(params['pid'])
    end
  end
end

