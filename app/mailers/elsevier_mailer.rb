class ElsevierMailer < ApplicationMailer
  default from: "app@data2paper.org"

  def submission_email(user, data_paper)
    #TODO: Throw error if no user email or data paper or data paper journal or data paper journal account service email
    @user = user
    @data_paper_url = "https://dev.data2paper.org/concern/data_papers/#{data_paper.id}"
    @note = ''
    if data_paper.note.present?
      @note = data_paper.note.join('\n')
    end
    @account = data_paper.journal.account.find{|account| account.account_type = ['email submission']}
    mail(to: @account.service_email.first, subject: 'Data paper submission')
  end

 
end
