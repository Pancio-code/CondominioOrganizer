Feature: Creazione cartella Google Drive condominio

    Background:

        Given the following user exist:
            | test | test@example.com | Test1234@ |
        And I am logged in
        And I am on the dashboard page

    Scenario: Un utente registrato può creare un condominio, diventando Leader del condominio e viene creata una cartella Google Drive del condominio

        When I follow "Nuovo Condominio"
        Then I should be on the new condominio page
        When I fill in the following:
            | condominio_nome      | test_condominio   |
            | condominio_comune    | Roma              |
            | condominio_indirizzo | Via Tiburtina 214 |
        And I press "Crea Condominio"
        Then I should see "Condominio creato correttamente."
        And Google Drive folder exist
        And I am a Leader Condominio
