[comment]: <> (https://medium.com/analytics-vidhya/how-to-create-a-readme-md-file-8fb2e8ce24e3)
[comment]: <> (https://www.makeareadme.com/)

# Equo Recapito Forte tramite blockchain Ethereum

## Introduzione
Il _non ripudio_ è una delle principali proprietà di sicurezza, essa trova applicazione in numerosi contesti.
Formalmente questa proprietà ~~di sicurezza~~ può essere definita come:

> _Def:_ La disponibilità di un'evidenza inequivocabile che impedisca a un soggetto di negare le proprie azioni.

Il non ripudio non è quindi una misura preventiva ma è una contromisura. Esso non impedisce di negare le proprie azioni, ma fornisce una certa evidenza che impedisce di negare la partecipazione ad una azione.

Nei protocolli di sicurezza che garantiscono questa proprietà l'evidenza deve necessariamente essere materiale crittografico, tipicamente ottenuto mediante la firma digitale.
Chiaramente la semplice firma digitale non basta a garantire la proprietà. Il non ripudio deve essere garantito in modo equo a tutti i differenti agenti che partecipano al protocollo. Inoltre, in nessun momento nessun agente deve avere un vantaggio sugli altri partecipanti.

Fra le molteplici contestualizzazioni del non ripudio, lo scenario tipico riguarda la posta elettronica. Nel caso del non ripudio per la posta elettronica possiamo distinguere due differenti livelli (incarnazioni) di queste proprietà:

- **Equo recapito debole**
    > _Def:_ Il ricevente legga l'e-mail se e solo se il mittente riceva la ricevuta di ritorno.
- **Equo recapito forte**
    > _Def:_ Il ricevente legga l'e-mail, ottenendo pure evidenza che provenga dal mittente, se e solo se il mittente riceva la ricevuta di ritorno.

## Obiettivi progetto
Questo progetto ~~presenta~~ propone una variante del protocollo [Zhou\-Gollmann](https://conferences.computer.org/sp/pdfs/csf/1997/1997-zhou-efficient.pdf) ~~, proponendo uno~~ che sfrutta uno _Smart Contract_ ([Ethereum](https://ethereum.org/it/smart-contracts/)) per svolgere il ruolo di _Trusted Third Party_ (o TTP). 
Oltre alla definizione del protocollo viene proposta anche un'implementazione in [Solidity](https://docs.soliditylang.org/en/v0.8.17/) dello _Smart Contract_ in questione (presentato) ~~ed un piccolo front end in React per interagire con lo Smart Contract~~. 

~~Mediante lo _Smart Contract_~~ Il protocollo proposto si pone come obiettivo quello di permette ad un qualunque **mittente** ed ad un qualunque **destinatario** di scambiare messaggi sfruttando un qualunque mail provider, (un qualunque servizio per lo scambio di messaggi), ottenendo le seguenti proprietà si sicurezza.

    ~~proprietà che vogliamo garantire : (1) equo recapito forte (2) nessuno è in grado di scoprire from, to ed msg (3) messuno scopre chi comunica con chi~~

**1. Equo recapito forte**.
> Il ricevente è in grado di leggere la mail, ottenendo pure evidenza che viene dal mittente, se e solo se (contestualmente al fatto che) il mittente riceve la ricevuta di ritorno.

Il protocollo fornisce a mittente e ricevente le seguenti evidenze:
- Se il mittente invia il messaggio, il ricevente ottiene l'evidenza che il messaggio è stato inviato dal mittente.
- Se il ricevente legge il messaggio, il mittente ottiene l'evidenza che permette di dimostrare che il messaggio sia stato letto dal ricevente.

Inoltre, le evidenze sono ricevute contesualmente.

**2. Integrità**. 
> Il ricevente è in grado di verificare l'integrità del messaggio ricevuto.

Il protocollo fornisce al riceve la certezza che il messaggio ricevuto sia quello che il mittente voleva spedire.

**3. Autenticazione (del ricevente con il mittente)**.
> Il mittente riceve garanzia che il messaggio sia stato ricevuto dal corretto ricevente.

Il ricevente ottiene garazie riguarda l'idnetità del mittente grazie alla proprità $1$. Il protocollo fornisce le stesse garanzie al mittente riguardo l'identità del ricevente.

Affinché questa proprietà sia soddisfatta il protocollo presuppone l'esistenza di una _Public Key Infrastructure_ (PKI).

**4. Confidenzialità sulla Blockchain**.
> Nessuno è in grado di determinare il contenuto del messaggio, l'email del mittente e l'email del ricevente essendo in possesso unicamente delle transazioni pubblicate sulla Blockchain.

La proprietà è garantita solo se il mittente e il ricevente non pubblichano ulteriori informazioni rispetto a quelle previste dal protocollo (in un qualsiasi posto).

--- 
**TODO**
5\. ~~Pseudo~~Anonimato sulla Blockchain. 
Il protocollo fornisce una forma debole di anonimato. 
Se mittente e ricevente utilizzan o una identitaà sulla blockchain differente per ogni messaggio inviato o ricevuto, allora il protocollo garantisce anonimato.
Nessuno sia in grado di associare nessun indirizzo ethereum del ricevente alla sua email, così come per il destinatario. (ad eccezione di mittente e destinatario)
(nessuno ed in grado di associare l'email del mittente e l'email del destinatario sulla blockchain)

---

# Protocollo

Questo protocollo fa uso di una funzione hash crittografica, che indichiamo $H$, e di un cifrario simmetrico (sicuro? funzione pseudo causale), che indichiamo con $C$. 

È il mittente ad iniziare il protocollo. Sia 
- $emailFrom$ = indirizzo email del mittente
- $emailTo$ = indirizzo email del destinatario
- $msg$ = il messaggio che il mittente vuole spedire al desinatario
- $k$ = una chiave simmetrica generata randomicamente del mittente
- $encMsg$ = $Enc_{AES.CBC}(k, msg)$
- $sign_A (m)$ = $m,\{H(m)\}_{privK_A}$ 
    - dove $H$ è una funzione hash


A -> B: emailFrom, emailTo, encMsg, label, $sign_A(emailFrom, emailTo, encMsg, label)$


1. A -> B : 
        from 
        to
        encMsg
        timestamp 
        label 
        A(msg.sender)
        pub_sign_b
        sign_scheme_name
        hash_func_name

        sign_A ( from || to || encMsg || timestamp || label || A(msg.sender) || pub_sign_b || sign_scheme_name || hash_func_name ) = sign_A ( Fnro )

    2. A -> emit : 
        indexed struct( label, A(msg.sender) )
        sign_A ( Fnro )
        currentTimestamp
    
    A invia al contratto 
        keccak256(H( from, to, encMsg, label ))
    questo permette poi al contratto di determinare se chi cerca di emettere un certo evento è autorizzato a farlo o meno. Solo B che è in grado di 
    calcolare H( from, to, encMsg, label ) è quello che può emettere questo evento.

    3. B -> emit :
        indexed struct( label, A(msg.sender) )
        sign_B ( sign_A ( Fnro ) || pubK ) = sign_B ( Fnrr )
        currentTimestamp

    A resta in ascolto su ( label, A(msg.sender) )

    4. A -> emit :
        indexed struct( label, A(msg.sender) )
        key
        sign_A ( sub_k ) = sign_A ( from || to || key || label )
        currentTimestamp

---

Il protocollo si svolge fra due agenti, una agente A (mittente) ed un agente B (destinatario) nello scenario in cui A e B vogliono scambiare un messaggio con _equo recapito forte_.

H = qualsiasi funzione hash (scelta da A)
H_name = stringa contenente il nome della funzione hash usata

emailFrom = mittente email da recapitare con non ripudio
emailTo = destinatario email da recapitare con non ripudio

msg = messaggio da inviare
cipher_name = stringa contenente il nome del cifrario simmetrico utilizzato
C = cifrario cipher_name
encMsg = C(key, msg) ==> {msg}_key 

A(msg.sender) = address del mittente 
B(msg.sender) = address del destinatario 


label = contatore numero corrente di email certificata da A(msg.sender) 
nonce = numero random
timestamp

pub_sign_b = chiave pubblica di firma di B

------------ PROTOCOLLO ------------

    Disponibilità di una PKI, ogni agente possiede una coppia di chiavi asimmetriche. Questo permette agli agenti di avere la certezza di chi l'interlocutore sia.
        sign_A (m) = m,{h(m)}privK_a

    Questa mail viene inviata sfruttando un
    1. A -> B : 
        from 
        to
        encMsg
        timestamp 
        label 
        A(msg.sender)
        pub_sign_b
        sign_scheme_name
        hash_func_name

        sign_A ( from || to || encMsg || timestamp || label || A(msg.sender) || pub_sign_b || sign_scheme_name || hash_func_name ) = sign_A ( Fnro )

    2. A -> emit : 
        indexed struct( label, A(msg.sender) )
        sign_A ( Fnro )
        currentTimestamp
    
    A invia al contratto 
        keccak256(H( from, to, encMsg, label ))
    questo permette poi al contratto di determinare se chi cerca di emettere un certo evento è autorizzato a farlo o meno. Solo B che è in grado di 
    calcolare H( from, to, encMsg, label ) è quello che può emettere questo evento.

    3. B -> emit :
        indexed struct( label, A(msg.sender) )
        sign_B ( sign_A ( Fnro ) || pubK ) = sign_B ( Fnrr )
        currentTimestamp

    A resta in ascolto su ( label, A(msg.sender) )

    4. A -> emit :
        indexed struct( label, A(msg.sender) )
        key
        sign_A ( sub_k ) = sign_A ( from || to || key || label )
        currentTimestamp

# Analisi protocollo