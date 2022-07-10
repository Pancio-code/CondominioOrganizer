# Preview all emails at http://localhost:3000/rails/mailers/condominio_mailer
class CondominioMailerPreview < ActionMailer::Preview
    def new_comunication_mailer
        CondominioMailer.with(name: "Andrea Panceri", email: "andrea.pancio00@gmail.com", condominio: "Condominio Roma",comune: "Roma", via: "via tiburtina 214", message: "Ho un problema con un altro amministratore").new_comunication_mailer
    end
    def new_comunication_for_condomini_mailer
        CondominioMailer.with(name: "Andrea Panceri", condominio: "Condominio Roma", message: "Ascensore in manutenzione fino a luglio").new_comunication_for_condomini_mailer
    end
end
