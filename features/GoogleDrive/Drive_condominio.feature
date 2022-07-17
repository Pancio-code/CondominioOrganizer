Feature: Creazione cartella Google Drive condominio

    Background:

        Given the following user exist:
            | test | test@example.com | Test1234@ |
        And I am logged in
        And I am on the dashboard page

    Scenario: Un utente registrato può creare un condominio, diventando Leader del condominio e viene creata una cartella Google Drive del condominio.Inoltre può modificare le informazioni e cancellare il condominio stesso.

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
        When I follow "Modifica"
        And I fill in the following:
            | condominio_nome      | test_condominio_modifica |
            | condominio_comune    | Avezzano                 |
            | condominio_indirizzo | Piazza Torlonia 12       |
        And I press "Crea Condominio"
        Then I should see "Condominio è stato aggiornato."
        When I follow "Home"
        And I follow "Elimina"
        Then I should see "Condominio è stato eliminato correttamente."

    Scenario: Un utente registrato non può creare un condominio senza inserire un nome di un condominio
        When I follow "Nuovo Condominio"
        Then I should be on the new condominio page
        When I fill in the following:
            | condominio_comune    | Roma              |
            | condominio_indirizzo | Via Tiburtina 214 |
        And I press "Crea Condominio"
        Then I should see "Nome è troppo corto (il minimo è 1 carattere)"

    Scenario: Un utente registrato non può creare un condominio senza inserire il comune di un condominio
        When I follow "Nuovo Condominio"
        Then I should be on the new condominio page
        When I fill in the following:
            | condominio_nome      | test_condominio   |
            | condominio_indirizzo | Via Tiburtina 214 |
        And I press "Crea Condominio"
        Then I should see "Comune è troppo corto (il minimo è 1 carattere)"

    Scenario: Un utente registrato non può creare un condominio senza inserire un indirizzo corretto
        When I follow "Nuovo Condominio"
        Then I should be on the new condominio page
        When I fill in the following:
            | condominio_nome      | test_condominio |
            | condominio_comune    | Roma            |
            | condominio_indirizzo | IndirizzoErrato |
        And I press "Crea Condominio"
        Then I should see "Indirizzo invalido, formato: Via Tiburtina 214"


