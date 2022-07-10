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

    def new_comunication_for_leader_mailer
        @nome = params[:name]
        @email = params[:email]
        @message = params[:message]

        mail(to: @mail, subject: "Nuova comunicazione dall' Admin di CondominioOrganizer!")
    end

    def new_comunication_for_condomini_mailer
        @nome = params[:name]
        @condominio = params[:condominio]
        @mail = params[:email]
        @message = params[:message]

        mail(to: @mail, subject: "Comunicazione dall'amministratore del condominio:")
    end
end
