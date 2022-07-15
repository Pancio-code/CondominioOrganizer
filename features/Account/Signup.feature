Feature: Creare un account
    Come Utente non registrato,
    in modo da diventare un utente registrato,
    voglio potermi iscrivere con la mia e-mail, nome e cognome.

    Background:

        Given I am not logged in
        And I am on the sign up page

    Scenario: Un utente non registrato può creare un account

        When I fill in the following:
            | user_uname                 | AndreaTest             |
            | user_email                 | andreatest@example.com |
            | user_password              | Test123#               |
            | user_password_confirmation | Test123#               |
        And I press "Sign up"
        Then I should be on the enter page for user "AndreaTest"
        And I should see "Hai completato la registrazione,benvenuto in CondominioOrganizer"

    Scenario: Un utente non registrato non può creare un account senza inserire un username

        When I fill in the following:
            | user_email                 | andreatest@example.com |
            | user_password              | Test123#               |
            | user_password_confirmation | Test123#               |
        And I press "Sign up"
        Then account creation should fail with "Uname non può essere lasciato in bianco"

    Scenario: Un utente non registrato non può creare un account senza inserire un indirizzo email

        When I fill in the following:
            | user_uname                 | AndreaTest |
            | user_password              | Test123#   |
            | user_password_confirmation | Test123#   |
        And I press "Sign up"
        Then account creation should fail with "Email non può essere lasciato in bianco"

    Scenario: Un utente non registrato non può creare un account inserendo un indirizzo email non valido

        When I fill in the following:
            | user_uname                 | AndreaTest     |
            | user_email                 | email_invalida |
            | user_password              | Test123#       |
            | user_password_confirmation | Test123#       |
        And I press "Sign up"
        Then account creation should fail with "Email non è valido"

    Scenario: Un utente non registrato non può creare un account inserendo un indirizzo email già inserito da un altro utente

        Given the following user exist:
            | test | test@example.com | Test1234@ |
        When I fill in the following:
            | user_uname                 | AndreaTest       |
            | user_email                 | test@example.com |
            | user_password              | Test123#         |
            | user_password_confirmation | Test123#         |
        And I press "Sign up"
        Then account creation should fail with "Email è già presente"
        When I follow "Log in"
        Then I should be on the login page
        When I fill in the following:
            | user_email    | test@example.com |
            | user_password | Test1234@        |
        And I press "Log in"
        And I should see "Bentornato, continua la navigazione nel sito"

    Scenario: Un utente non registrato non può creare un account non inserendo una password

        When I fill in the following:
            | user_uname | AndreaTest             |
            | user_email | andreatest@example.com |
        And I press "Sign up"
        Then account creation should fail with "Password non può essere lasciato in bianco"

    Scenario: Un utente non registrato non può creare un account inserendo la password di conferma diversa da quella inserita

        When I fill in the following:
            | user_uname                 | AndreaTest             |
            | user_email                 | andreatest@example.com |
            | user_password              | Test123#               |
            | user_password_confirmation | Test1234#              |
        And I press "Sign up"
        Then account creation should fail with "Password confirmation non coincide con Password"
