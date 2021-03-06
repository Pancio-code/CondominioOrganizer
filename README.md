# README

CondominioOrganizer progetto per l'esame del Laboratorio di Applicazioni Software e Sicurezza Informatica.

Descrizione ed API impiegate 

CondominioOrganizer: è un'applicazione web che punta ad  aggregare tutte le informazioni di  interesse di un condominio, con un sistema di “gruppi condominio” gestiti da un Leader Condominio forniti di bacheca dove inserire comunicazioni condominiali. Permette di organizzare l’invio di eventi “pagamento” tramite e-mail, tenere traccia di eventi come assemblee tramite un utilizzo simbiotico della bacheca locale fornita al gruppo, l’invio di email ai membri del gruppo e Google Calendar; fornisce inoltre un Drive privato ad ogni nuovo condominio, con la creazione di una nuova cartella per ogni condomino, così da semplificare la condivisione di documenti tra l’amministratore ed i condomini. 

Ruoli previsti 
5 tipologie di utenti: 
-Utente non registrato può visualizzare l’ Homepage, contattare gli amministratori del sito, ed iscriversi al sito per usufruire delle funzioni riservate ai condomini.

-Utente registrato può vedere i condomini vicini a lui tramite API di Google Maps, ricercare manualmente tra una lista di condominii nel suo comune o iscriversi direttamente con un codice d’invito. Nel caso in cui non esistesse il suo condominio, l’utente registrato potra’ creare il suo gruppo, il che comporterà automaticamente il passaggio a Leader Condominio per quest’ultimo. Inoltre un utente registrato può visualizzare le informazioni del proprio account e modificarle. Inoltre può visualizzare la lista dei condominii a cui partecipa, amministra o per cui ha fatto richiesta.

-Condomino può iscriversi ad altri condominii, scrivere post e commenti. Può visualizzare i file tramite Google Drive, su cui disporrà di una propria cartella privata alla quale il sito agirà da interfaccia (accessibile solamente a lui e al Leader condominio, ed essere sempre in contatto ,per eventuali problemi, con il capo del condominio tramite e-mail fornita o la bacheca del condominio. Tutti gli eventi di cui deve essere notificato avviano automaticamente una comunicazione via e-mail, e se possibile, la creazione di un evento (con eventuali reminder, se posto ad una certa distanza temporale) sul google calendar del condomino. Due classi speciali di eventi racchiudono i “pagamenti” e le “assemblee”.

-Leader Condominio mantiene tutte le funzioni possibili al condomino, ma riceve anche dei privilegi extra relativi alla gestione del condominio di cui è Leader: può creare condomini, cancellare post e commenti dal gruppo che gestisce, espellere e invitare e accettare le richieste di partecipazione Utenti, elevare a Leader Condominio (Ma non ridurre i privilegi di altri Leader), modificare banner del gruppo, impostare un “evento”, generico o appartenente a una delle due categorie speciali “Pagamento” o “Assemblea”, che attiva automaticamente l’invio di comunicazioni, relative allo stesso, a tutti i membri di un determinato condominio, tramite l’invio di e-mail contenenti file evento ICS autogenerati, e se autorizzati dall’utente, impostazione di eventi sul Google Calendar dello stesso; può accedere ad ogni cartella del Google Drive del gruppo e inserirne file all’intero, ed inoltre contattare lo staff di amministrazione del sito tramite e-mail (Admin) per segnalare comportamenti scorretti. Un Condomino può essere automaticamente promosso a Leader Condominio nel caso questo crea un gruppo condominio. 

-Admin e’ il ruolo riservato allo staff di amministrazione del sito. Ha accesso a tutte le informazioni non sensibili degli iscritti al sito ed inoltre può cancellare commenti e post da qualsiasi gruppo, espellere membri da un qualsiasi condominio, revocare e donare privilegi di amministrazione gruppo, cancellare gruppi non conformi, visualizzare informazioni e statistiche sul funzionamento del sito. Esiste un solo account Admin “root” inizialmente, da questo sarà poi possibile elevare altri account a Admin.

Modalità di accesso:

-Accesso locale: l'utente inserisce le sue informazioni  direttamente sul sito. 

-Accesso tramite account google: l’utente dà il suo consenso al  trattamento dei dati del proprio account google, utilizzo di OAuth. 

Entrambi le modalità di accesso si svolgono tramite l’utilizzo della gemma “devise”.

Servizi esterni utilizzati(API) 

Come servizio REST esterno sono utilizzate le API Google Drive per l’upload di file nel condominio, Gmail per l’invio di email nel sito e Google Calendar per permettere  all’amministratore di fissare eventi.

L’API di Google Drive verrà utilizzato inizialmente per fornire la cartella privata del condominio durante la creazione del gruppo. Dopodiché, potrà essere utilizzato per condividere documenti tra condomini. Ogni Condomino disporrà di una sottocartella privata inserita nel drive a cui solo lui e i Leader condominio possono accedere.
L’API di Gmail verra’ utilizzata per permettere lo scambio agevole di mail tra amministratore e condomini, anche con annessa integrazione alle API menzionate: L’aggiunta di un evento generico, o un evento “Assemblea” o “Pagamento” sul Calendar del gruppo creerà automaticamente una notifica tramite e-mail a tutti i componenti del gruppo, che include un file ICS automaticamente generato che riguarda l’evento.
L’API di Calendar fornisce un calendario disponibile sulla bacheca con la lista aggiornata di riunioni e scadenze. Inoltre, l’utente riceverà aggiornamenti sui pagamenti su un suo eventuale calendario, oltre che tramite email, se autorizzato.
