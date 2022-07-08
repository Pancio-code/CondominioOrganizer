class CondominioMailer < ApplicationMailer
    def new_comunication_mailer
        @nome = params[:name]
        @email = params[:email]
        @condominio = params[:condominio]
        @comune = params[:comune]
        @via = params[:via]
        @message = params[:message]

        mail(to: Figaro.env.email_di_servizio, subject: "Nuova comunicazione da un amministratore di un condominio!")
    end
end
