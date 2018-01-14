# Preview all emails at http://localhost:3000/rails/mailers/elsevier_mailer
class ElsevierMailerPreview < ActionMailer::Preview
  def submission_mail_preview
    ElsevierMailer.submission_email(User.first, DataPaper.first)
  end
end
