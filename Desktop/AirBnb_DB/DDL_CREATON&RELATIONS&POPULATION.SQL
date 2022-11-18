
BEGIN TRANSACTION;

drop table if exists utente cascade;
drop table if exists alloggio cascade;
drop table if exists camera cascade;
drop table if exists servizio cascade;
drop table if exists lista cascade;
drop table if exists prenotazione cascade;
drop table if exists recensione cascade;
drop table if exists commento cascade;
drop table if exists metodo_di_pagamento cascade;
drop table if exists foto cascade;
CREATE TABLE utente (
	email varchar NOT NULL UNIQUE,
	pass varchar NOT NULL,
	nome varchar NOT NULL,
	cognome varchar NOT NULL,
	numero_telefono varchar NOT NULL,
	verificato boolean NOT NULL DEFAULT false,
	carta_didentita varchar,
	rating float(1) ,
	badge boolean ,
	
	
	
	CONSTRAINT utente_pk PRIMARY KEY (email)
);

CREATE TABLE metodo_di_pagamento(
	nome varchar NOT NULL,
	Email varchar NOT NULL,
	Titolare varchar not null,
	numero varchar not null,
	scadenza varchar not null,
	cvv varchar not null,
	
	
	
	CONSTRAINT mp_pk PRIMARY KEY (nome,Email)
	
	
);



CREATE TABLE alloggio (
	CIR varchar(14) NOT NULL UNIQUE ,
	Nome varchar NOT NULL,
	descrizione varchar NOT NULL,
	host varchar NOT NULL REFERENCES utente(email) ON UPDATE CASCADE ON DELETE CASCADE,
	via varchar NOT NULL,
	nr int NOT NULL,
	citta varchar NOT NULL,
	regione varchar NOT NULL,
	paese varchar NOT NULL,
	prezzo_notte int NOT NULL,
	Costi_pulizia int NOT NULL,
	numero_letti int NOT NULL,
	check_in time NOT NULL,
	check_out time NOT NULL,
	
	nr_servizi int not null,
	nr_recensioni int NOT NULL DEFAULT 0,
	Rating_media float(1) NOT NULL DEFAULT 0,
	
	
	
	
	CONSTRAINT alloggi_pk PRIMARY KEY (cir),
	
	CONSTRAINT alloggio_ref UNIQUE (cir,host)
	
	
);



CREATE TABLE camera(
	nome varchar NOT NULL,
	CIR varchar NOT NULL,
	Posti_Letto int NOT NULL,
	disposizione_letti varchar NOT NULL,
	
	CONSTRAINT camera_pk PRIMARY KEY (nome,CIR),
	CONSTRAINT camera_fk FOREIGN KEY (CIR)
	REFERENCES alloggio(CIR) ON UPDATE CASCADE ON DELETE CASCADE


);

CREATE TABLE servizio(
	nome varchar NOT NULL,
	CIR varchar NOT NULL,
	
	
	CONSTRAINT servizio_pk PRIMARY KEY (nome,CIR),
	CONSTRAINT servizio_fk FOREIGN KEY (CIR)
	REFERENCES alloggio(CIR) ON UPDATE CASCADE ON DELETE CASCADE


);


CREATE TABLE foto(
	Indice varchar not null,
	CIR varchar not null,
	didascalia varchar not null,
	path varchar not null,
	
	
	CONSTRAINT foto_pl PRIMARY KEY (Indice,CIR)
);







CREATE TABLE lista (
	Nome_Lista varchar NOT NULL ,
	proprietario varchar NOT NULL,
	alloggio varchar NOT NULL,
	
	
	CONSTRAINT liste_pk PRIMARY KEY (Nome_Lista,proprietario,alloggio),
	CONSTRAINT liste_fk1 FOREIGN KEY (proprietario) 
	REFERENCES utente(email) ON UPDATE CASCADE ON DELETE CASCADE,
	
	CONSTRAINT liste_fk2 FOREIGN KEY (alloggio) 
	REFERENCES alloggio(cir) ON UPDATE CASCADE ON DELETE CASCADE

);


CREATE TABLE prenotazione (
	inizio_soggiorno date NOT NULL ,
	fine_soggiorno date  NOT NULL,
	CIR varchar NOT NULL ,
	Email_ospite varchar NOT NULL REFERENCES utente(email) ON UPDATE CASCADE ON DELETE CASCADE,
	host varchar NOT NULL ,
	nr_persone int NOT NULL,
	nr_giorni int NOT NULL,
	
	status varchar NOT NULL ,
	
	data_p date not null,
	totale  varchar  not null,
	nomi_ospiti varchar ,
	
	CONSTRAINT pren_pk PRIMARY KEY(inizio_soggiorno,CIR,Email_ospite),
	
	CONSTRAINT pren_fk FOREIGN KEY(CIR,host)
	REFERENCES alloggio(cir,host) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT pren_fk1 FOREIGN KEY(Email_ospite)
	REFERENCES utente(email) ON UPDATE CASCADE ON DELETE CASCADE,
	
	
	CONSTRAINT ref_recensione UNIQUE(inizio_soggiorno,CIR,Email_ospite,host,status)
);



CREATE TABLE recensione (
	data_recensione date NOT NULL,
	inizio_soggiorno date NOT NULL  ,
	CIR varchar NOT NULL,
	Email_ospite varchar NOT NULL ,
	host varchar NOT NULL,
	status varchar NOT NULL,
	email_autore_recensione varchar NOT NULL,
	testo_riguardante_ospite varchar ,
	testo_riguardante_host varchar ,
	testo_riguardante_alloggio varchar ,
	voto_pulizia int,
	voto_qualita_prezzo int,
	voto_posizione int,
	
	
	
	CONSTRAINT rec_pk PRIMARY KEY (data_recensione,inizio_soggiorno,CIR,Email_ospite,email_autore_recensione),
	CONSTRAINT rec_fk FOREIGN KEY (inizio_soggiorno,CIR,Email_ospite,host,status)
	REFERENCES prenotazione(inizio_soggiorno,CIR,Email_ospite,host,status) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT rec_fk1 FOREIGN KEY(email_autore_recensione)
	REFERENCES utente(email) ON UPDATE CASCADE ON DELETE CASCADE,
	
	CONSTRAINT rec_ref UNIQUE (data_recensione,inizio_soggiorno,CIR,Email_ospite,email_autore_recensione)
	

);

CREATE TABLE commento (
	timestamp_ timestamp NOT NULL,
	data_recensione date NOT NULL,
	inizio_soggiorno date NOT NULL,
	CIR varchar NOT NULL,
	Email_Ospite varchar NOT NULL,
	email_autore_recensione varchar NOT NULL,
	
	
	email_autore_commento varchar NOT NULL,
	Testo varchar NOT NULL,
	
	
	timestamp_f timestamp ,
	data_recensione_f date ,
	inizio_soggiorno_f date ,
	CIR_f varchar ,
	Email_Ospite_f varchar ,
	email_autore_recensione_F varchar,
	
	
	
	
	CONSTRAINT comm_pk PRIMARY KEY (timestamp_,data_recensione,inizio_soggiorno,CIR,Email_ospite,email_autore_recensione),
	
	CONSTRAINT comm_fk FOREIGN KEY (data_recensione,inizio_soggiorno,CIR,Email_ospite,email_autore_recensione)
	REFERENCES recensione(data_recensione,inizio_soggiorno,CIR,Email_ospite,email_autore_recensione)
	 ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT comm_father_reference FOREIGN KEY (timestamp_f,inizio_soggiorno_f,CIR_f,Email_ospite_f,email_autore_recensione_f,data_recensione_f)
	REFERENCES commento(timestamp_,inizio_soggiorno,CIR,Email_ospite,email_autore_recensione,data_recensione)
	 ON UPDATE CASCADE ON DELETE CASCADE,
	
		
	
	CONSTRAINT comm1_fk FOREIGN KEY (email_autore_commento)
	REFERENCES utente(email) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT comm_father_ref UNIQUE (timestamp_,inizio_soggiorno,CIR,Email_ospite,email_autore_recensione,data_recensione_f) 
	
);

END TRANSACTION;






BEGIN TRANSACTION;

insert into utente values('olly@mail.com','Alfa1234','oliviu','gratii','3477021536','true','c:/img/user/olly_mail_com.jpeg',0,false);
insert into utente values('kevin@mail.com','Beta1234','kevin','doga','333333333','false','c:/img/user/kevin_mail_com.jpeg',0,false);
insert into utente values('ale@mail.com','Alex1234','alex','rider','3334445555','true','c:/img/user/ale_mail_com.jpeg');
insert into utente values('jack@mail.com','Jack1234','jack','daniels','3334456555','false');
insert into utente values('jhony@mail.com','Jhony1234','jhony','deep','3337745555','true','c:/img/user/jhony_mail_com.jpeg');
insert into utente values('alan@mail.com','Alan1234','alan','turing','333333545','false');


insert into metodo_di_pagamento values('visa1','olly@mail.com','Oliviu G.','4444333322221111','22/10',123);

insert into alloggio values ('aaaaaaa000000','Villa delle rose','xxxxxxxxxxxxxxxxxxxxxxxxxxxx','olly@mail.com','delle rose',1,'porto cervo','sardegna','Italia',30,50,7,'14:00','11:00',5);
insert into alloggio values ('aaaaaaa000001','Villa delle palme','xxxxxxxxxxxxxxxxxxxxxxxxxxxx','olly@mail.com','delle palme',2,'porto cervo','sardegna','Italia',40,100,10,'14:00','11:00',5);
insert into alloggio values ('aaaaaaa000002','blue bay appartment','xxxxxxxxxxxxxxxxxxxxxxxxxxxx','olly@mail.com','Smeraldina',3,'porto cervo','sardegna','Italia',30,20,3,'14:00','11:00',5);
insert into alloggio values ('aaaaaaa000003','Diamond Hostel ','xxxxxxxxxxxxxxxxxxxxxxxxxxxx','kevin@mail.com','Diamante ',4,'porto cervo','sardegna','Italia',15,5,6,'14:00','11:00',5);
insert into alloggio values ('aaaaaaa000004','Sweet Loft','xxxxxxxxxxxxxxxxxxxxxxxxxxxx','kevin@mail.com','Moscova',5,'porto cervo','sardegna','Italia',100,50,2,'14:00','11:00',5);


insert into camera values('camera 1','aaaaaaa000000',2,'un letto matrimoniale');
insert into camera values('camera 2','aaaaaaa000000',2,'un letto matrimoniale');
insert into camera values('camera 3','aaaaaaa000000',3,'un letto matrimoniale+ divano letto');

insert into camera values('camera 1','aaaaaaa000001',3,'un letto matrimoniale+ divano letto');
insert into camera values('camera 2','aaaaaaa000001',3,'un letto matrimoniale+ divano letto');
insert into camera values('camera 3','aaaaaaa000001',4,'due letti matrimoniali');

insert into camera values('camera 1','aaaaaaa000002',3,'un letto matrimoniale+ divano letto');

insert into camera values('camera 1','aaaaaaa000003',3,'un letto matrimoniale+ divano letto');
insert into camera values('camera 2','aaaaaaa000003',3,'un letto matrimoniale+ divano letto');

insert into camera values('camera 1','aaaaaaa000004',3,'un letto matrimoniale+ divano letto');

/*5 servizi per alloggio*/

insert into servizio values ('Wifi','aaaaaaa000000');
insert into servizio values ('AC','aaaaaaa000000');
insert into servizio values ('Cucina','aaaaaaa000000');
insert into servizio values ('Parcheggio','aaaaaaa000000');
insert into servizio values ('Animali domestici ammessi','aaaaaaa000000');

insert into servizio values ('Wifi','aaaaaaa000001');
insert into servizio values ('AC','aaaaaaa000001');
insert into servizio values ('Cucina','aaaaaaa000001');
insert into servizio values ('Parcheggio','aaaaaaa000001');
insert into servizio values ('Animali domestici ammessi','aaaaaaa000001');

insert into servizio values ('Wifi','aaaaaaa000002');
insert into servizio values ('AC','aaaaaaa000002');
insert into servizio values ('Cucina','aaaaaaa000002');
insert into servizio values ('Parcheggio','aaaaaaa000002');
insert into servizio values ('Animali domestici ammessi','aaaaaaa000002');

insert into servizio values ('Wifi','aaaaaaa000003');
insert into servizio values ('AC','aaaaaaa000003');
insert into servizio values ('Cucina','aaaaaaa000003');
insert into servizio values ('Parcheggio','aaaaaaa000003');
insert into servizio values ('Animali domestici ammessi','aaaaaaa000003');

insert into servizio values ('Wifi','aaaaaaa000004');
insert into servizio values ('AC','aaaaaaa000004');
insert into servizio values ('Cucina','aaaaaaa000004');
insert into servizio values ('Parcheggio','aaaaaaa000004');
insert into servizio values ('Animali domestici ammessi','aaaaaaa000004');




insert into lista values ('vacanze','olly@mail.com','aaaaaaa000004');
insert into lista values ('familia','olly@mail.com','aaaaaaa000001');
insert into lista values ('lavoro','olly@mail.com','aaaaaaa000002');
insert into lista values ('piacere','olly@mail.com','aaaaaaa000000');

insert into lista values ('piacere','kevin@mail.com','aaaaaaa000003');
insert into lista values ('familia','kevin@mail.com','aaaaaaa000002');
insert into lista values ('piacere','kevin@mail.com','aaaaaaa000000');
insert into lista values ('familia','kevin@mail.com','aaaaaaa000001');

insert into lista values ('piacere','ale@mail.com','aaaaaaa000004');
insert into lista values ('vacanze','ale@mail.com','aaaaaaa000001');
insert into lista values ('vacanze','ale@mail.com','aaaaaaa000003');
insert into lista values ('familia','ale@mail.com','aaaaaaa000000');

insert into lista values ('lavoro','jack@mail.com','aaaaaaa000000');
insert into lista values ('lavoro','jack@mail.com','aaaaaaa000002');
insert into lista values ('lavoro','jack@mail.com','aaaaaaa000004');
insert into lista values ('piacere','jack@mail.com','aaaaaaa000003');

insert into lista values ('piacere','jhony@mail.com','aaaaaaa000004');
insert into lista values ('familia','jhony@mail.com','aaaaaaa000002');
insert into lista values ('piacere','jhony@mail.com','aaaaaaa000001');
insert into lista values ('familia','jhony@mail.com','aaaaaaa000003');

insert into lista values ('piacere','alan@mail.com','aaaaaaa000004');
insert into lista values ('vacanze','alan@mail.com','aaaaaaa000003');
insert into lista values ('piacere','alan@mail.com','aaaaaaa000001');
insert into lista values ('vacanze','alan@mail.com','aaaaaaa000000');


insert into prenotazione values('2021-10-01','2021-10-06','aaaaaaa000000','alan@mail.com','olly@mail.com',7,5,'conclusa','2021-09-09','280');
insert into prenotazione values('2021-10-09','2021-10-24','aaaaaaa000000','jhony@mail.com','olly@mail.com',6,15,'conclusa','2021-09-09','280');
insert into prenotazione values('2021-10-26','2021-10-30','aaaaaaa000000','jack@mail.com','olly@mail.com',7,4,'confermata','2021-09-09','280');

insert into prenotazione values('2021-11-01','2021-11-06','aaaaaaa000001','alan@mail.com','olly@mail.com',10,5,'conclusa','2021-09-09','280');
insert into prenotazione values('2021-11-09','2021-11-24','aaaaaaa000001','ale@mail.com','olly@mail.com',8,15,'confermata','2021-09-09','280');
insert into prenotazione values('2021-11-26','2021-10-30','aaaaaaa000001','jack@mail.com','olly@mail.com',9,4,'conclusa','2021-09-09','280');

insert into prenotazione values('2021-12-01','2021-12-06','aaaaaaa000002','alan@mail.com','olly@mail.com',3,5,'conclusa','2021-09-09','280');
insert into prenotazione values('2021-12-09','2021-12-24','aaaaaaa000002','kevin@mail.com','olly@mail.com',1,15,'cancellata','2021-09-09','280');
insert into prenotazione values('2021-12-26','2021-12-30','aaaaaaa000002','ale@mail.com','olly@mail.com',2,4,'conclusa','2021-09-09','280');

insert into prenotazione values('2022-01-01','2022-01-06','aaaaaaa000003','jack@mail.com','kevin@mail.com',6,5,'conclusa','2021-09-09','280');
insert into prenotazione values('2022-01-09','2022-01-24','aaaaaaa000003','jhony@mail.com','kevin@mail.com',3,15,'rfiutata','2021-09-09','280');
insert into prenotazione values('2022-01-26','2022-01-30','aaaaaaa000003','ale@mail.com','kevin@mail.com',5,4,'conclusa','2021-09-09','280');



insert into prenotazione values('2022-02-01','2022-02-06','aaaaaaa000004','olly@mail.com','kevin@mail.com',2,5,'rifiutata','2021-09-09','280');
insert into prenotazione values('2022-02-09','2022-02-24','aaaaaaa000004','alan@mail.com','kevin@mail.com',2,15,'conclusa','2021-09-09','280');
insert into prenotazione values('2022-02-26','2022-03-02','aaaaaaa000004','ale@mail.com','kevin@mail.com',2,4,'conclusa','2021-09-09','280');









insert into recensione(data_recensione,inizio_soggiorno,cir,email_ospite,host,status,email_autore_recensione,testo_riguardante_ospite)
values('2021-10-07','2021-10-01','aaaaaaa000000','alan@mail.com','olly@mail.com','conclusa','olly@mail.com','ospite gentile');

insert into recensione(data_recensione,inizio_soggiorno,cir,email_ospite,host,status,email_autore_recensione,testo_riguardante_ospite)
values('2021-10-25','2021-10-09','aaaaaaa000000','jhony@mail.com','olly@mail.com','conclusa','olly@mail.com','ospite gentile');

insert into recensione(data_recensione,inizio_soggiorno,cir,email_ospite,host,status,email_autore_recensione,testo_riguardante_ospite)
values('2021-12-07','2021-12-01','aaaaaaa000002','alan@mail.com','olly@mail.com','conclusa','olly@mail.com','ospite gentile');

insert into recensione(data_recensione,inizio_soggiorno,cir,email_ospite,host,status,email_autore_recensione,testo_riguardante_ospite)
values('2022-01-07','2022-01-01','aaaaaaa000003','jack@mail.com','kevin@mail.com','conclusa','kevin@mail.com','ospite gentile');

insert into recensione(data_recensione,inizio_soggiorno,cir,email_ospite,host,status,email_autore_recensione,testo_riguardante_ospite)
values('2022-02-01','2022-01-26','aaaaaaa000003','ale@mail.com','kevin@mail.com','conclusa','kevin@mail.com','ospite gentile');

insert into recensione(data_recensione,inizio_soggiorno,cir,email_ospite,host,status,email_autore_recensione,testo_riguardante_ospite)
values('2022-02-25','2022-02-09','aaaaaaa000004','alan@mail.com','kevin@mail.com','conclusa','kevin@mail.com','ospite gentile');

insert into recensione(data_recensione,inizio_soggiorno,cir,email_ospite,host,status,email_autore_recensione,testo_riguardante_ospite)
values('2022-03-23','2022-02-26','aaaaaaa000004','ale@mail.com','kevin@mail.com','conclusa','kevin@mail.com','ospite gentile');




insert into recensione(data_recensione,inizio_soggiorno,cir,email_ospite,host,status,email_autore_recensione,testo_riguardante_host,testo_riguardante_alloggio,voto_pulizia,voto_qualita_prezzo,voto_posizione)
values('2021-10-07','2021-10-01','aaaaaaa000000','alan@mail.com','olly@mail.com','conclusa','alan@mail.com','host gentile','alloggio accogliente',4,5,4);

insert into recensione(data_recensione,inizio_soggiorno,cir,email_ospite,host,status,email_autore_recensione,testo_riguardante_host,testo_riguardante_alloggio,voto_pulizia,voto_qualita_prezzo,voto_posizione)
values('2021-10-25','2021-10-09','aaaaaaa000000','jhony@mail.com','olly@mail.com','conclusa','jhony@mail.com','host gentile','alloggio accogliente',4,5,4);

insert into recensione(data_recensione,inizio_soggiorno,cir,email_ospite,host,status,email_autore_recensione,testo_riguardante_host,testo_riguardante_alloggio,voto_pulizia,voto_qualita_prezzo,voto_posizione)
values('2021-12-07','2021-12-01','aaaaaaa000002','alan@mail.com','olly@mail.com','conclusa','alan@mail.com','host gentile','alloggio accogliente',4,5,4);

insert into recensione(data_recensione,inizio_soggiorno,cir,email_ospite,host,status,email_autore_recensione,testo_riguardante_host,testo_riguardante_alloggio,voto_pulizia,voto_qualita_prezzo,voto_posizione)
values('2022-01-07','2022-01-01','aaaaaaa000003','jack@mail.com','kevin@mail.com','conclusa','jack@mail.com','host gentile','alloggio accogliente',4,5,4);

insert into recensione(data_recensione,inizio_soggiorno,cir,email_ospite,host,status,email_autore_recensione,testo_riguardante_host,testo_riguardante_alloggio,voto_pulizia,voto_qualita_prezzo,voto_posizione)
values('2022-02-01','2022-01-26','aaaaaaa000003','ale@mail.com','kevin@mail.com','conclusa','ale@mail.com','host gentile','alloggio accogliente',4,5,4);

insert into recensione(data_recensione,inizio_soggiorno,cir,email_ospite,host,status,email_autore_recensione,testo_riguardante_host,testo_riguardante_alloggio,voto_pulizia,voto_qualita_prezzo,voto_posizione)
values('2022-02-25','2022-02-09','aaaaaaa000004','alan@mail.com','kevin@mail.com','conclusa','alan@mail.com','host gentile','alloggio accogliente',4,5,4);

insert into recensione(data_recensione,inizio_soggiorno,cir,email_ospite,host,status,email_autore_recensione,testo_riguardante_host,testo_riguardante_alloggio,voto_pulizia,voto_qualita_prezzo,voto_posizione)
values('2022-03-23','2022-02-26','aaaaaaa000004','ale@mail.com','kevin@mail.com','conclusa','ale@mail.com','host gentile','alloggio accogliente',4,5,4);






insert into commento 
values('2021-10-07 10:14:07','2021-10-07','2021-10-01','aaaaaaa000000','alan@mail.com','olly@mail.com','olly@mail.com','graziemille');
insert into commento 
values('2021-10-07 11:14:07','2021-10-07','2021-10-01','aaaaaaa000000','alan@mail.com','olly@mail.com','alan@mail.com','prego',        '2021-10-07 10:14:07','2021-10-07','2021-10-01','aaaaaaa000000','alan@mail.com','olly@mail.com');
insert into commento 
values('2021-10-07 12:14:07','2021-10-07','2021-10-01','aaaaaaa000000','alan@mail.com','olly@mail.com','olly@mail.com','La riaspettiamo nella nostra struttura',       '2021-10-07 11:14:07','2021-10-07','2021-10-01','aaaaaaa000000','alan@mail.com','olly@mail.com');

END TRANSACTION;




