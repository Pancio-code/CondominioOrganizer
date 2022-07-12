Feature: registered User, in order to have access to his account, can log in

    Scenario: Successful Log in
        Given I am on the CondominioOrganizer log in page
        When I fill in "user_email" with "andrea.pancio00@gmail.com"
        And I fill in "user_password" with "12345678"
        And I press "Log in"
        Then I should be on CondominioOrganizer home page
        And I should see "Bentornato, continua la navigazione nel sito"

    Scenario: Error in Log in
        Given I am on the CondominioOrganizer log in page
        When I fill in "user_email" with "andrea.pancio00@gmail.com"
        And I fill in "user_password" with "12345679"
        And I press "Log in"
        Then I should be on CondominioOrganizer log in page
        And I should see "Email o password inserita è errata"
