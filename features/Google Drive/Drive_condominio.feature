Feature: Creazione cartella Google Drive condominio
    Come Condomino,
    in modo da poter condividere documenti con i soli Leader gruppo condominio,
    Voglio poter accedere ad una cartella Google Drive dedicata tramite l’applicazione

    #Ogni condomino ha una propria sottocartella nella cartella drive del condominio. La cartella e i permessi rilevanti vengono creati quando un utente si unisce al condominio; nel caso l’accesso fosse stato effettuato senza account google, l’utente può solo accedere alla cartella tramite link ma non condividere file. Il sito svolge il ruolo di interfaccia verso questa cartella Drive, permettendo di accedere direttamente ai contenuti di questa da esso.)


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
