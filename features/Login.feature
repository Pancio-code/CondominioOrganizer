Feature: log into your account
    As a registered User
    in order to have access to my account
    I want a page to login

    Background:

        Given I am not logged in
        And I am on the sign up page

    Scenario: Unregistered User can create an account

        When I fill in the following:
            | user_uname                 | AndreaTest             |
            | user_email                 | andreatest@example.com |
            | user_password              | Test123#               |
            | user_password_confirmation | Test123#               |
        And I press "Sign up"
        Then I should be on the enter page for user "AndreaTest"
        And I should see "Hai completato la registrazione,benvenuto in CondominioOrganizer"

    Scenario: Unregistered User cannot create account without providing username

        When I fill in the following:
            | user_email                 | andreatest@example.com |
            | user_password              | Test123#               |
            | user_password_confirmation | Test123#               |
        And I press "Sign up"
        Then account creation should fail with "Uname non può essere lasciato in bianco"

    Scenario: Unregistered User cannot create account without providing email address

        When I fill in the following:
            | user_uname                 | AndreaTest |
            | user_password              | Test123#   |
            | user_password_confirmation | Test123#   |
        And I press "Sign up"
        Then account creation should fail with "Email non può essere lasciato in bianco"

    Scenario: Unregistered User cannot create account with invalid email

        When I fill in the following:
            | user_uname                 | AndreaTest     |
            | user_email                 | email_invalida |
            | user_password              | Test123#       |
            | user_password_confirmation | Test123#       |
        And I press "Sign up"
        Then account creation should fail with "Email non è valido"

    Scenario: Unregistered User cannot create account with duplicate email

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

    Scenario: Unregistered User cannot create account without providing password

        When I fill in the following:
            | user_uname | AndreaTest             |
            | user_email | andreatest@example.com |
        And I press "Sign up"
        Then account creation should fail with "Password non può essere lasciato in bianco"

    Scenario: Unregistered User cannot create account with mismatched password confirmation

        When I fill in the following:
            | user_uname                 | AndreaTest             |
            | user_email                 | andreatest@example.com |
            | user_password              | Test123#               |
            | user_password_confirmation | Test1234#              |
        And I press "Sign up"
        Then account creation should fail with "Password confirmation non coincide con Password"