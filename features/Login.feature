Feature: Accedere al proprio account
    Come Utente registrato,
    in modo da avere accesso al mio account,
    voglio una pagina per effettuare il login.

    Background:

        Given the following user exist:
            | test | test@example.com | Test1234@ |
        And I am on the home page

    Scenario: Un utente registrato può accedere al proprio account

        When I follow "Login"
        Then I should be on the login page
        When I fill in the following:
            | user_email    | test@example.com |
            | user_password | Test1234@        |
        And I press "Log in"
        And I should see "Bentornato, continua la navigazione nel sito"

    Scenario: Un utente registrato può effettuare il logout

        Given I am logged in
        And I am on the account page
        When I press "logout"
        Then I should be on the home page
        And I should see "Hai effettutato correttamente il logout"

    Scenario: Un utente registrato può cancellare il proprio account

        Given I am logged in
        And I am on the account page
        When I press "Cancella il mio account"
        Then I should be on the home page
        And I should see "Hai cancellato correttamente il tuo account"

    Scenario: Un utente registrato può cambiare il proprio indirizzo email

        Given I am logged in
        And I am on the account page
        When I fill in the following:
            | user_email            | andreatestcambio@example.com |
            | user_current_password | Test1234@                    |
        When I press "Modifica"
        Then I should be on the enter page
        And I should see "Hai aggiornato le tue informazioni"

    Scenario: Un utente registrato può cambiare la propria password

        Given I am logged in
        And I am on the account page
        When I fill in the following:
            | user_change_password       | TestCambio123# |
            | user_password_confirmation | TestCambio123# |
            | user_current_password      | Test1234@      |
        When I press "Modifica"
        Then I should be on the enter page
        And I should see "Hai aggiornato le tue informazioni"

    Scenario: Un utente registrato non può modificare le sue informazioni senza inserire la sua password corrente

        Given I am logged in
        And I am on the account page
        When I fill in the following:
            | user_email                 | andreatestcambio@example.com |
            | user_change_password       | TestCambio123#               |
            | user_password_confirmation | TestCambio123#               |
        When I press "Modifica"
        Then I should be on the same account page
        And I should see "Current password non può essere lasciato in bianco"

