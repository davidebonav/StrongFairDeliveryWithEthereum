[comment]: <> (https://medium.com/analytics-vidhya/how-to-create-a-readme-md-file-8fb2e8ce24e3)
[comment]: <> (https://www.makeareadme.com/)

# Equo Recapito Forte tramite blockchain Ethereum

## Introduzione
### Cosa è il non ripudio
Il _non ripudio_ è una delle principali proprietà di sicurezza, la quale trova applicazione in numerosi contesti. Formalmente può essere definito come:

> _Def:_ La disponibilità di un'evidenza inequivocabile che impedisca a un soggetto di negare le proprie azioni.

Il non ripudio non è una misura preventiva, è una contromisura. Esso non impedisce l'atto di negare la partecipazione ad un'azione, ma fornisce l'evidenza che permette di dimostrare che in realtà l'azione è stata compiuta.

Nei protocolli di sicurezza che garantiscono questa proprietà l'evidenza deve necessariamente essere materiale crittografico, tipicamente ottenuto mediante la firma digitale.
Chiaramente la semplice firma digitale non basta a garantire la proprietà. Deve essere il protocollo all'interno del quale viene usata a garantire che la proprietà di non ripudio valga.

Il non ripudio deve essere garantito in modo equo a tutti i differenti agenti che partecipano al protocollo. Inoltre, in nessun momento nessun agente deve avere un vantaggio sugli altri partecipanti.

Fra le molteplici contestualizzazioni del non ripudio, lo scenario tipico riguarda la posta elettronica, con più precisione: lo scambio di messaggi. Nel caso del non ripudio per lo scambio di messaggi possiamo distinguere due differenti livelli (incarnazioni) di questa proprietà:

- **Equo recapito debole**
    > _Def:_ Il ricevente legga il messaggio se e solo se il mittente riceva la ricevuta di ritorno.
- **Equo recapito forte**
    > _Def:_ Il ricevente legga il messaggio, ottenendo pure evidenza che provenga dal mittente, se e solo se il mittente riceva la ricevuta di ritorno.

### Obiettivi progetto
Questo progetto propone una variante del protocollo [Zhou\-Gollmann](https://conferences.computer.org/sp/pdfs/csf/1997/1997-zhou-efficient.pdf), la quale sfrutta uno _Smart Contract_ ([Ethereum](https://ethereum.org/it/smart-contracts/)) per svolgere il ruolo di _Trusted Third Party_ (o TTP). 
Oltre alla definizione del protocollo viene proposta anche un'implementazione in [Solidity](https://docs.soliditylang.org/en/v0.8.17/) dello _Smart Contract_ in questione. 

Il protocollo proposto si pone come obiettivo quello di garantire una serie di proprietà di sicurezza sui messaggi scambiati fra un qualunque **mittente** ed un qualunque **destinatario** sfruttando un qualunque servizio asincrono per lo scambio di messaggi.

Le proprietà di sicurezza garantite sono le seguenti:

    1. Equo recapito forte.
    Il destinatario è in grado di leggere il messaggio, ottenendo pure evidenza che viene dal mittente, se e solo se (contestualmente al fatto che) il mittente riceve la ricevuta di ritorno.

    2. Integrità.
    Il destinatario è in grado di verificare l'integrità del messaggio ricevuto.

    3. Autenticazione.
    Il mittente ed il destinatario sono in grado di autenticare l'interlocutore.

    4. Confidenzialità sulla Blockchain.
    Nessuno è in grado di determinare il contenuto del messaggio, così come l'identità del mittente e del destinatario essendo unicamente in possesso delle transazioni pubblicate sulla Blockchain.

## Descrizione Protocollo

### Notazione

Per rappresentare i messaggi è il protocollo è usata la seguente notazoine:
- $H$ = funzione hash crittograficamente sicura
    - $H(x)$ : applicazione della funzione hash $H$ all'input $x$.
- $C$ = cifrario simmetrico 
    - $Enc_C(k,x)$ : cifratura del messaggio $x$ con chiave $k$ 
    - $Dec_C(k,y)$ : decifratura del crittotesto $y$ con chiave $k$
- $S$ = schema asimmetrico di firma 
    - $Sign_A(x)$ : firma dell'agente $A$ sul messaggio $x$
    - $Ver_A(s, x)$ : verifica della firma $s$ effettuata dall'agente $A$ sum messaggio $x$ 
- $\{x, y\}$ : concatenazione del messaggio $x$ con il messaggio $y$
- $addr_A$ : un qualunque indirizzo ethereum dell'agente $A$

Al protocollo partecipano i seguenti agenti:
- $A$ : mittente
- $B$ : desinatario
- $SC$ : smart contract

Eventi
- pubblica sulla blockchain
- wait messaggio

## Descrizione protocollo
Consideriamo il caso in cui $A$ vuole inviare un messaggo $m$ ad $B$ con _equo recapito forte_.

Per semplificare la lettura del protocollo sono usate le seguenti abbreviazioni:
- $c = Enc_C(k,m)$
- $NRO = sign_A(A,\ B,\ c,\ l,\ addr_A)$
    - non repudation of origin
- $NRR = sign_B(NRO) = sign_B(sign_A(A,\ B,\ c,\ l,\ addr_A))$
    - non repudation of receive
- $SUB\_K = sign_A(A,\ B,\ k,\ l,\ addr_A)$
    - submission of key

### 0. Recupero della label da utilizzare
Il protocollo per collegare fra di loro differenti evidenze di uno stesso messaggio utilizza la coppia univoca $(l, addr_A)$ dove, $l$ è un contatore tenuto dallo SmartContract per ogni address. Il contatore in questione conta numero di messaggi inviati dal mittente utilizzando l'address $addr_A$ in cui è stato usato il protocollo.

Prima di poter iniziare il protocollo con il destinatario il mittente quindi prima ottenere quale è la prossima label. Per far questo deve contattare lo SmarContract.

È in questo momento del protocollo in cui il mittente decide quale sarà l'address che utilizzera per tutto il resto del protocollo.

### 1. Invio del crittotesto a B
È il mittente ad iniziare il protoccollo con il destinatario. L'invio deve avvenire mediante un canale sicuro, altrimenti la confidenzialità del messaggio non può essere garantita.

### 2. Pubblicazione del flag _nro_
A invia al contratto 
    keccak256(H( from, to, encMsg, label ))
questo permette poi al contratto di determinare se chi cerca di emettere un certo evento è autorizzato a farlo o meno. Solo B che è in grado di 
calcolare H( from, to, encMsg, label ) è quello che può emettere questo evento.

### 3. Conferma di ricezione del crittotesto da parte di B
SmartContract controlla H( A, B, encMsg, label, address_A ) è determina l'autorizzazione a poter accettare il messaggio, dopo di che

Lo SmartContract quindi emette sulla blockchain l'evento rappresentante il flag non ripudio di origine.

### 4. Pubblicazione della chiave

---

## Il protocollo può essere riassunto dal seguente schema
>0.1 &nbsp; $A \longrightarrow SC :$ &nbsp;
    $addr_A$

>0.2 &nbsp; $SC \longrightarrow A :$ &nbsp;
    $l$

>1\. &nbsp; $A \longrightarrow B :$ &nbsp; 
    $A,\ B,\ c,\ l,\ addr_A,\ NRO$

>2.1 &nbsp; $A \longrightarrow SC :$ &nbsp;
    $NRO,\ keccak256(H(A,\ B,\ c,\ l,\ addr_A))$

>2.2 &nbsp; $SC \longrightarrow Blockchain :$ &nbsp;
    $l,\ addr_A,\ NRO$

>3.1 &nbsp; $B \longrightarrow SC :$ &nbsp;
    $H(A,\ B,\ c,\ l,\ addr_A),\ l,\ addr_A,\ NRR$
    
>3.2 &nbsp; $SC \longrightarrow Blockchain :$ &nbsp;
    $l,\ addr_A,\ NRR$

>4.1 &nbsp; $B \longrightarrow SC :$ &nbsp;
    $k,\ l,\ addr_A,\ SUB\_K$
    
>4.2 &nbsp; $SC \longrightarrow Blockchain :$ &nbsp;
    $l,\ addr_A,\ k,\ SUB\_K$


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

**1. Equo recapito forte**.
Affinché questa proprietà sia soddisfatta devono dimostrare le seguenti condizioni:
- Le evidenze sono ricevute contestualmente, in nessun momento ne mittente ne destinatario ha un vantaggio sull'altro agente.
- Se il mittente invia il messaggio, il destinatario ottiene l'evidenza che il messaggio è stato inviato dal mittente.
- Se il ricevente legge il messaggio, il mittente ottiene l'evidenza che permette di dimostrare che il messaggio sia stato letto dal ricevente.

**2. Integrità**. 
Il protocollo fornisce al riceve la certezza che il messaggio ricevuto sia quello che il mittente voleva spedire.

**3. Autenticazione (del ricevente con il mittente)**.
Dimostrare che sia mittente che ricevente hanno la certezza di chi sia l'interlocutore

Il ricevente ottiene garazie riguarda l'idnetità del mittente grazie alla proprità $1$. Il protocollo fornisce le stesse garanzie al mittente riguardo l'identità del ricevente.

~~Affinché questa proprietà sia soddisfatta il protocollo presuppone l'esistenza di una _Public Key Infrastructure_ (PKI).~~ Questo vale anche per la proprietà 1 può quindi essere specificato dopo

**4. Confidenzialità sulla Blockchain**.

La proprietà è garantita solo se il mittente e il ricevente non pubblichano ulteriori informazioni rispetto a quelle previste dal protocollo (in un qualsiasi posto).