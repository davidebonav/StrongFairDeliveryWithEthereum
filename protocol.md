<!-- [comment]: <> (https://medium.com/analytics-vidhya/how-to-create-a-readme-md-file-8fb2e8ce24e3) -->
<!-- [comment]: <> (https://www.makeareadme.com/) -->

# Equo Recapito Forte tramite blockchain Ethereum

## Introduzione
### Cosa è il non ripudio
Il _non-ripudio_ è un'importante proprietà di sicurezza sempre più richiesta dai protocolli di sicurezza. Formalmente può essere definito come:

> _Def:_ La disponibilità di un'evidenza inequivocabile che impedisca a un soggetto di negare le proprie azioni.

> _Def:_ Assurance that the sender of information is provided with proof of delivery and the recipient is provided with proof of the sender’s identity, so neither can later deny having processed the information. [(NIST SP 800-18 Rev. 1)](https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-18r1.pdf)

Il non-ripudio non è una misura preventiva, esso è una contromisura. Questa proprietà non impedisce l'atto di negare la partecipazione ad un'azione, ma fornisce l'evidenza che permette di dimostrare che in realtà l'azione è stata compiuta.

Nei protocolli di sicurezza che garantiscono questa proprietà l'evidenza deve necessariamente essere materiale crittografico, tipicamente ottenuto mediante la firma digitale.
Chiaramente la semplice firma digitale non basta a garantirla. Deve essere il protocollo all'interno del quale viene usata a garantire che la proprietà di non-ripudio valga.

Fra le molteplici contestualizzazioni del non-ripudio, lo scenario preso in considerazione riguarda lo scambio di messaggi o equo recapito. Nel caso del non ripudio per lo scambio di messaggi possiamo distinguere due differenti livelli (incarnazioni) di questa proprietà:

- **Equo recapito debole**
    > _Def:_ Il ricevente legga il messaggio se e solo se il mittente riceva la ricevuta di ritorno.
- **Equo recapito forte**
    > _Def:_ Il ricevente legga il messaggio, ottenendo pure evidenza che provenga dal mittente, se e solo se il mittente riceva la ricevuta di ritorno.

### Obiettivi progetto
Questo progetto propone una variante del protocollo [Zhou\-Gollmann](https://conferences.computer.org/sp/pdfs/csf/1997/1997-zhou-efficient.pdf). Il protocollo proposto sfrutta uno _Smart Contract_ ([Ethereum](https://ethereum.org/it/smart-contracts/)) per svolgere il ruolo di _Trusted Third Party_ (o TTP) e per garantire al mittente ed al destinatario di un messaggio l'equo recapito forte.
Oltre alla definizione del protocollo viene proposta anche un'implementazione in [Solidity](https://docs.soliditylang.org/en/v0.8.17/) dello _Smart Contract_ in questione. 

Il protocollo si pone come obiettivo quello di garantire una serie di proprietà di sicurezza sui messaggi scambiati fra un qualunque **mittente** ed un qualunque **destinatario** che sfruttando un qualunque servizio asincrono per lo scambio di messaggi.

Le proprietà di sicurezza garantite sono le seguenti:

    1. Equo recapito forte.
    Il destinatario è in grado di leggere il messaggio, ottenendo pure evidenza che viene dal mittente, contestualmente al fatto che il mittente riceve la ricevuta di ritorno.

    2. Integrità.
    Il destinatario è in grado di verificare l'integrità del messaggio ricevuto.

    3. Autenticazione.
    Il mittente ed il destinatario sono in grado di autenticare l'interlocutore (di autenticarsi reciprocamente).

    4. Confidenzialità sulla Blockchain.
    Nessuno è in grado di determinare il contenuto del messaggio, così come l'identità del mittente e del destinatario essendo unicamente in possesso delle transazioni pubblicate sulla Blockchain.

## Descrizione Protocollo

### Notazione
Durante la trattazione del protocollo indiciamo con $A$ il mittente del messagio, con $B$ il destinatario del messaggio e con $SC$ lo SmartContract che volge il ruolo di TTP.
<!-- Al protocollo partecipano i seguenti agenti: -->
<!-- - Il mittente, rappresentato con la lettera $A$. -->
<!-- - Il destinatario, rappresentato con la lettera $B$. -->
<!-- - Lo Smart Contract che svolge il ruolo di TPP, rappresentato con $SC$ -->


Il protocollo utilizza i seguenti strumenti crittografici 
<!-- esterni a quelli forniti dalla blockchain. -->
- un cifrario simmetrico $C$ 
- uno schema asimmetrico di firma digitale $S$

La notazione utilizzata durante la descrizione del protocollo è la seguente:
- $Enc_C(k,m)$ : cifratura del messaggio $m$ con la chiave $k$ utilizzando $C$.
- $Dec_C(k,c)$ : decifratura del crittotesto $c$ con la chiave $k$ utilizzando $C$.
- $Sign_X(m)$ : firma dell'agente $X$ sul messaggio $m$ utilizzando $S$.
    - con $Sign_X(m)$ intendiamo unicamente il crittotesto della firma digitale, ovvero solo $Enc_S(privK_X, m)$ e quindi non anche il messaggio $m$. 
- $Ver_X(s, m)$ : verifica della firma $s$ effettuata dall'agente $X$ sul messaggio $m$ utilizzando $S$.
- $N_X$ nonce generata randomicamente dall'agente $X$
- $m_1, m_2$ : concatenazione del messaggio $m_1$ con il messaggio $m_2$
- $addr_X$ : un qualunque indirizzo ethereum dell'agente $X$ scelto in modo arbitrario.
- $SM \longrightarrow Blockchain :\ m$ &nbsp; : pubblicazione del log contenente il messaggio $m$ da parte dello SmartContract sulla Blockchain.
- $X \longleftarrow Blockchain :\ m$ &nbsp; : recupero dalla Blockchain del log contenente il messaggio $m$ da parte dell'agente $X$.
    - $X$ aspetta la pubblicazione di $m$ sui log della Blockchain da parte dello Smart Contract.

## Descrizione protocollo
Consideriamo il caso in cui $A$ vuole inviare un messaggo $m$ ad $B$ con _equo recapito forte_ (e con le proprietà descritte sopra). Per far questo genera una chiave $k$ e cifra il messaggio, ottenendo il crittotesto $c$

Per semplificare la lettura del protocollo sono usate le seguenti abbreviazioni:
- $c = Enc_C(k,m)$
- $NRO = sign_A(A,\ B,\ c,\ l,\ addr_A)$
    - non repudiation of origin
- $NRR = sign_B(NRO) = sign_B(sign_A(A,\ B,\ c,\ l,\ addr_A))$
    - non repudiation of receipt
- $ConK = sign_A(A,\ B,\ k,\ l,\ addr_A)$
    - confirmation of key

<!-- Il protocollo presuppone che tutte le comunicazioni avvengano mediante un canale sicuro? Le transazioni verso e da la Blockchain sono firmate? -->
---
**0. Recupero della label da utilizzare**
>0.1 &nbsp; $A \longrightarrow SC :$ &nbsp;
    $addr_A$

>0.2 &nbsp; $SC \longrightarrow A :$ &nbsp;
    $l$

**1. Invio del crittotesto al destinatario**
>1\. &nbsp; $A \longrightarrow B :$ &nbsp; 
    $A,\ B,\ c,\ l,\ addr_A,\ N_A$

**2. Pubblicazione del flag _nro_**
>2.1 &nbsp; $A \longrightarrow SC :$ &nbsp;
    $l,\ addr_A,\ NRO,\ keccak256(N_A)$

>2.2 &nbsp; $SC \longrightarrow Blockchain :$ &nbsp;
    $l,\ addr_A,\ NRO$

**3. Conferma di ricezione del crittotesto da parte del destinatario**
>3.1 &nbsp; $B \longleftarrow Blockchain :$ &nbsp;
    $l,\ addr_A,\ NRO$

>3.2 &nbsp; $B \longrightarrow SC :$ &nbsp;
    $l,\ addr_A,\ NRR,\ N_A$
    
>3.3 &nbsp; $SC \longrightarrow Blockchain :$ &nbsp;
    $l,\ addr_A,\ NRR$

### 4. Pubblicazione della chiave
>4.1 &nbsp; $A \longleftarrow Blockchain :$ &nbsp;
    $l,\ addr_A,\ NRR$

>4.2 &nbsp; $A \longrightarrow SC :$ &nbsp;
    $k,\ l,\ addr_A,\ ConK$
    
>4.3 &nbsp; $SC \longrightarrow Blockchain :$ &nbsp;
    $l,\ addr_A,\ k,\ ConK$

### 5. Confirmation della chiave
>5\. &nbsp; $B \longleftarrow Blockchain :$ &nbsp;
    $l,\ addr_A,\ k,\ ConK$
---

La nonce $N_A$ può essere calcolata dal mittente anche come $N_A = H(A,\ B,\ c,\ l,\ addr_A)$ dove
- $H$ è una funzione hash crittograficamente sicura
- $H(m)$ : è l'applicazione della funzione hash $H$ al messaggio $m$.

La coppia $(addr_A,\ l)$, dove $addr_A$ è l'address usato dal mittente mentre $l$ è un'etichetta (univoca per address) generata dallo Smart Contract, ha un duplice scopo:
- Collegare fra di loro tutte le evidenze di una particolare esecuzione del protocollo.
- Identificare in modo univoco all'interno della blockchain tutte le singole esecuzioni del protocollo e le evidenze associate.

L'etichetta è univoca per _address_, ovvero lo Smart Contract può assegnare etichette identiche ad address differenti, mentre ad ogni _address_ ogni etichetta è generata in una ed una sola esecuzione. 
Ovvero, esecuzioni differenti da parte di _address_ differenti possono avere la stessa etichetta, mentre esecuzioni differenti da parte dello stesso _address_ hanno sempre etichette differenti.

Durante lo **step 0**, prima di poter iniziare il protocollo vero e proprio il mittente deve quindi interrogare lo Smart Contract per conoscere l'etichetta che sarà generata per l'_address_ scelto. <!-- Per ottenere la corretta label da associare all'esecuzione del protocollo. In modo da poterla comunicare anche al destinatario.  --> L'_address_ scelto in questa fase rimarrà lo stesso per tutta la restante esecuzione del protocollo.

Dopo aver ottenuto l'etichetta $l$ dallo SmartContract il mittente è pronto ad inviare il crittotesto del messaggio al destinatario. 
Il servizio usato per lo scambio del messaggio durante lo **step 1** fra mittente e destinatario occorre garantisca confidenzialità. L'invio deve avvenire mediante un canale sicuro. (Non necessario)

La nonce generata dal mittente ha lo scopo di permettere allo Smart Contract di autenticare $B$ come il corretto destinatario del messaggio inviato da $A$. Solo $B$ essendo il corretto destinatario del messaggio conosce l'input in grado di generare l'hash. Questo evita che chiunque possa pubblicare il flag $NRR$ al posto di $B$.
Affinché questo sia vero occorre però che il messaggio $1$ sia confidenziale. 

A questo punto $B$ dopo aver recuperato i log contenente l'evidenza $NRO$ nel passo **3.1** (ed averne verificato la correttezza) decide se procedere con il protocollo e quindi pubblicare la successiva o meno.

## Analisi protocollo

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

Disponibilità di una PKI, ogni agente possiede una coppia di chiavi di firma. Questo permette agli agenti di avere la certezza di chi l'interlocutore sia.

**4. Confidenzialità sulla Blockchain**.

La proprietà è garantita solo se il mittente e il ricevente non pubblichano ulteriori informazioni rispetto a quelle previste dal protocollo (in un qualsiasi posto).