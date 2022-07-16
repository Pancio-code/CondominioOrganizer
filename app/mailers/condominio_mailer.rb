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

    def new_codice_mailer
        @nome = params[:name]
        @email = params[:email]
        @condominio = params[:condominio]
        @comune = params[:comune]
        @via = params[:via]
        @message = params[:message]

        mail(to: @email, subject: "Nuova invito per un condominio")
    end

    def send_event_invitation(start_datetime,user_id,condominio_id)
        require 'icalendar'
        @message = params[:message]
        @categoria = params[:categoria]
        @user = User.find(user_id)
        @condominio = Condominio.find(condominio_id)
        @cal = Icalendar::Calendar.new
        @cal.event do |e|
            e.alarm do |a|
                a.summary = "Reminder avviso " + params[:categoria]
                if params[:categoria] == "pagamento"
                    a.trigger = "-P7DT0H0M0S" # 1 day before
                else
                    a.trigger = "-P1DT0H0M0S"
                end
            end
            e.dtstart = start_datetime
            e.dtend = start_datetime
            e.location = @condominio.nome + ', ' + @condominio.comune + ', ' + @condominio.indirizzo
            e.summary = "Avviso " + params[:categoria]
            e.organizer = "mailto:#{@user.email}"
            e.organizer = Icalendar::Values::CalAddress.new("mailto:#{@user.email}", cn: @user.uname)
            e.description = params[:message]
        end
        mail.attachments['calendar_event.ics'] = { mime_type: 'text/calendar', content: @cal.to_ical }
        mail(to: params[:email],
        subject: "[SUB] Avviso #{params[:categoria]} in data: #{l(start_datetime, format: :default)}")
    end

    def new_comunication_for_leader_mailer
        @nome = params[:name]
        @email = params[:email]
        @message = params[:message]

        mail(to: @email, subject: "Nuova comunicazione dall' Admin di CondominioOrganizer!")
    end

    def new_comunication_for_condomini_mailer
        @nome = params[:name]
        @condominio = params[:condominio]
        @mail = params[:email]
        @message = params[:message]

        mail(to: @mail, subject: "Comunicazione dall'amministratore del condominio:")
    end
end
