[comment]: <> (https://medium.com/analytics-vidhya/how-to-create-a-readme-md-file-8fb2e8ce24e3)
[comment]: <> (https://www.makeareadme.com/)

# Equo Recapito Forte tramite blockchain Ethereum

## Introduzione
Il _non ripudio_ è una delle principali proprietà di sicurezza che trova applicazione in numerosi contesti.
Formalmente questa proprietà di sicurezza può essere definita come:

> _Def:_ La disponibilità di un'evidenza inequivocabile che impedisca a un soggetto di negare le proprie azioni.

Il non ripudio non è quindi una misura preventiva ma è una contromisura. Esso non impedisce di negare le proprie azioni, ma fornisce una certa evidenza che impedisce di negare la partecipazione ad una azione.

Nei protocolli di sicurezza che garantiscono questa proprietà l'evidenza deve necessariamente essere materiale crittografico, tipicamente ottenuto mediante la firma digitale.
Chiaramente la semplice firma digitale non basta a garantire la proprietà. Il non ripudio deve essere garantito in modo equo a tutti i differenti agenti che partecipano al protocollo, inoltre, in nessun momento nessun agente deve avere un vantaggio sugli altri partecipanti.

Fra le molteplici contestualizzazioni del non ripudio, lo scenario tipico riguarda la posta elettronica. Nel caso del non ripudio per la posta elettronica possiamo distinguere due differenti livelli (incarnazioni) di queste proprietà:

- **Equo recapito debole**
    > _Def:_ Il ricevente legga l'e-mail se e solo se il mittente riceva la ricevuta di ritorno.
- **Equo recapito forte**
    > _Def:_ Il ricevente legga l'e-mail, ottenendo pure evidenza che provenga dal mittente, se e solo se il mittente riceva la ricevuta di ritorno.

## Obiettivi progetto
Questo progetto ~~presenta~~ propone una variante del protocollo [Zhou\-Gollmann](https://conferences.computer.org/sp/pdfs/csf/1997/1997-zhou-efficient.pdf) ~~, proponendo uno~~ che sfrutta uno _Smart Contract_ ([Ethereum](https://ethereum.org/it/smart-contracts/)) per svolgere il ruolo di _Trusted Third Party_ (o TTP). 
Oltre alla definizione del protocollo viene proposta anche un'implementazione in [Solidity](https://docs.soliditylang.org/en/v0.8.17/) dello _Smart Contract_ in questione (presentato) ~~ed un piccolo front end in React per interagire con lo Smart Contract~~. 

~~Mediante lo _Smart Contract_~~ Il protocollo proposto si pone come obiettivo quello di permette ad un qualunque **mittente** ed ad un qualunque **destinatario** di scambiare messaggi sfruttando un qualunque mail provider, (un qualunque servizio per lo scambio di messaggi), ottenendo le seguenti proprietà si sicurezza.

**1. Equo recapito forte**

---
1. equo recapito forte sui messaggi scambiati (impossibilità di negare le proprie azioni)
2. Integrità
3. Anonimato sulla blockchain (nessuno ed in grado di associare l'email del mittente e l'email del destinatario sulla blockchain)
4. Confidenzialità
5. Autenticazion (PKI)


---

~~In Italia la _Posta Elettronica Certificata_ (o PEC) ha valore legale equiparato ad una raccomandata con ricevuta di ritorno. Essa garantisce l'equo recapito debole (o forte). 
Per poterla usare però serve creare una nuova casella di posta.~~

******

# Protocollo

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

proprietà che vogliamo garantire : 
    - equo recapito forte
    - nessuno è in grado di scoprire from, to ed msg
    - messuno scopre chi comunica con chi