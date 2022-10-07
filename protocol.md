[comment]: <> (https://medium.com/analytics-vidhya/how-to-create-a-readme-md-file-8fb2e8ce24e3)
[comment]: <> (https://www.makeareadme.com/)

# Equo Recapito Forte tramite blockchain Ethereum

## Introduzione
Il _non ripudio_ è una delle principali proprietà di sicurezza, la quale trova applicazione in numerosi contesti. Formalmente può essere definito come:

> _Def:_ La disponibilità di un'evidenza inequivocabile che impedisca a un soggetto di negare le proprie azioni.

Il non ripudio non è una misura preventiva, è una contromisura. Esso non impedisce l'atto di negare la partecipazione ad un'azione, ma fornisce l'evidenza che permette di dimostrare che in realtà l'azione è stata compiuta.

Nei protocolli di sicurezza che garantiscono questa proprietà l'evidenza deve necessariamente essere materiale crittografico, tipicamente ottenuto mediante la firma digitale.
Chiaramente la semplice firma digitale non basta a garantire la proprietà. Deve essere il protocollo all'interno del quale viene usata a garantire che la proprietà di non ripudio valga.

Il non ripudio deve essere garantito in modo equo a tutti i differenti agenti che partecipano al protocollo. Inoltre, in nessun momento nessun agente deve avere un vantaggio sugli altri partecipanti.

Fra le molteplici contestualizzazioni del non ripudio, lo scenario tipico riguarda la posta elettronica, con più precisione lo scambio di messaggi. Nel caso del non ripudio per lo scambio di messaggi possiamo distinguere due differenti livelli (incarnazioni) di questa proprietà:

- **Equo recapito debole**
    > _Def:_ Il ricevente legga il messaggio se e solo se il mittente riceva la ricevuta di ritorno.
- **Equo recapito forte**
    > _Def:_ Il ricevente legga il messaggio, ottenendo pure evidenza che provenga dal mittente, se e solo se il mittente riceva la ricevuta di ritorno.

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

~~Affinché questa proprietà sia soddisfatta il protocollo presuppone l'esistenza di una _Public Key Infrastructure_ (PKI).~~ Questo vale anche per la proprietà 1 può quindi essere specificato dopo

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

## Strumenti crittografici (Notazione)

(chiarmente la qualità del protocollo ottenuto dipende anche dagli strumenti crittografici usati durante l'implemententazione, ma forse non serve specificarlo)

Il protocollo utilizza i seguenti strumenti crittografici:
- una funzione hash crittografica $H$ (crittograficamente sicura)
    - $H(x)$ : applicazione della funzione hash $H$ con input $x$.
- un cifrario simmetrico $C$
    - $Enc_C(k,x)$ : cifratura del testo in chiaro $x$ con chiave $k$ 
    - $Dec_C(k,y)$ : decifratura del crittotesto $y$ con chiave $k$
- uno schema di firma $S$
    - $Sign_A(x)$ : firma dell'agente $A$ sulla stringa $x$
    - $Ver_A(s, x)$ : verifica della firma $s$ effettuata dall'agente $A$ sulla stringa $x$ 
- $X, Y$ concatenazione del messaggio $X$ con il messaggio $Y$
- $adddress_A$ : indirizzo ethereum di $A$ (un qualsiasi indirizzo di cui A conosce la chiave privata, una qualunque identità su ethereum di A, qualsiasi address per cui A può creare firme valide (conosce chiav eprivata))

I flag descritti all'interno del protocollo Zhou\-Gollmann sono qua sostituiti da eventi emessi sulla blockchain.

## Descrizione protocollo

Il protocollo si svolge fra due agenti, una agente A (mittente) ed un agente B (ricevente o destinatario) nello scenario in cui A e B vogliono scambiare un messaggio $msg$ con _equo recapito forte_.

Il protocollo può essere riassunto nei seguenti passi.

**1. Invio del messaggio $m$**

>$A$ --> $B$ :
    $A$, $B$, $encMsg$, $label$, $address_A$, $sign_A(A, B, encMsg, label)$

dove:
- $encMsg$ = $Enc_{AES.CBC}(k, msg)$
- $label$ = contatore restituito dallo Smart Contract
- $address_A$ = indirizzio ethereum di A

indexed struct( label, A(msg.sender) ) sono univoci

È il mittente ad iniziare il protoccollo con il destinatario. Il mittente (, sfruttando un qualsiasi canale di cominicazione, quale una mail, whatsapp, telegram, un foglio di carta, un messaggio normale, un qualsiasi canale di comunicazione). L'invio deve avvenire mediante un canale sicuro, altrimenti la confidenzialità del messaggio non può essere garantita.

(A utilizza address_A)
> A --> SmartContract :
    $sign_A(A, B, encMsg, label)$
    keccak256(H( A, B, encMsg, label, address_A ))

    A invia al contratto 
        keccak256(H( from, to, encMsg, label ))
    questo permette poi al contratto di determinare se chi cerca di emettere un certo evento è autorizzato a farlo o meno. Solo B che è in grado di 
    calcolare H( from, to, encMsg, label ) è quello che può emettere questo evento.

> SmartContract -> emit : 
        indexed struct( label, A(msg.sender) )
        $sign_A(A, B, encMsg, label)$
        currentTimestamp

> B -> SmartContract :
        H( A, B, encMsg, label, address_A )
        label
        address_A
        sign_B ( Fnro )

dove Fnro = $sign_A(A, B, encMsg, label)$

SmartContract controlla H( A, B, encMsg, label, address_A ) è determina l'autorizzazione a poter accettare il messaggio, dopo di che

> Smart -> contract-> emit
        indexed struct( label, A(msg.sender) )
        sign_B ( Fnro )
        currentTimestamp

Lo SmartContract quindi emette sulla blockchain l'evento rappresentante il flag non ripudio di origine.



---

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

------------ PROTOCOLLO ------------

    Disponibilità di una PKI, ogni agente possiede una coppia di chiavi di firma. Questo permette agli agenti di avere la certezza di chi l'interlocutore sia.
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