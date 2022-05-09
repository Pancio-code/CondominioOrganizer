class Contact < MailForm::Base
    attribute :name,      validate: true
    attribute :email,     validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
    attribute :message,   validate: true
    attribute :nickname,  captcha: true

    # Declare the e-mail headers. It accepts anything the mail method
    # in ActionMailer accepts.
    def headers
        {
        :subject => "Contact Us CondominioOrganizer",
        :to => "panceri.1884749@studenti.uniroma1.it",
        :from => %("#{name}" <#{email}>)
        }
    end
end