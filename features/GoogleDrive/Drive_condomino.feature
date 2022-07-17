Feature: Creazione cartella Google Drive del condomino nel codnominio
    Come Condomino,
    in modo da poter condividere documenti con i soli Leader gruppo condominio,
    Voglio poter accedere ad una cartella Google Drive dedicata tramite l’applicazione

    #Ogni condomino ha una propria sottocartella nella cartella drive del condominio. La cartella e i permessi rilevanti vengono creati quando un utente si unisce al condominio; nel caso l’accesso fosse stato effettuato senza account google, l’utente può solo accedere alla cartella tramite link ma non condividere file. Il sito svolge il ruolo di interfaccia verso questa cartella Drive, permettendo di accedere direttamente ai contenuti di questa da esso.)

    Background:
        Given the following user exist:
            | test | test@example.com | Test1234@ |
        And I am logged in
        And I am on the enter page

    Scenario: Un utente registrato può entrare in un condominio, diventando membro del condominio e viene creata una cartella Google Drive dell'utente all'interno del condominio.Inoltre può creare post/commenti e eliminarli,ed uscire dal condominio.
        When I use a code for enter in a condominium
        Then I should be on the condominium page
        And I should see "Benvenuto nel condominio."
        And Google Drive folder exist
        And I am a Condomino
        When I fill in the following:
            | post_title | TitoloPost |
            | post_body  | BodyPost   |
        And I press "Crea Post"
        Then I should see "Post creato correttamente."
        And I should see "BodyPost"
        When I follow "Commenti"
        Then I should be on the post page
        And I should see "BodyPost"
        When I fill in the following:
            | comment_body | CommentoBody |
        And I press "Crea commento"
        Then I should see "Commento creato con successo."
        And I should see "CommentoBody"
        When I follow "Rimuovi commento"
        Then I should see "Commento cancellato correttamente"
        When I follow "Bacheca"
        And I follow "Rimuovi post"
        Then I should see "Post eliminato correttamente."
        When I follow "Esci dal Condominio"
        Then I should see "Uscito correttamente dal condominio."
        And I should be on the enter page
        #test aggiunto per pulire la cartella Drive creata
        Then clean all
