
DROP TABLE bought_passes CASCADE CONSTRAINTS;
DROP TABLE clients CASCADE CONSTRAINTS;
DROP TABLE instructors CASCADE CONSTRAINTS;
DROP TABLE lessons CASCADE CONSTRAINTS;
DROP TABLE lifts CASCADE CONSTRAINTS;
DROP TABLE passes CASCADE CONSTRAINTS;
DROP TABLE zones_passes CASCADE CONSTRAINTS;
DROP TABLE slopes_lifts CASCADE CONSTRAINTS;
DROP TABLE rental_equipment CASCADE CONSTRAINTS;
DROP TABLE rental_equipment_type CASCADE CONSTRAINTS;
DROP TABLE rentals CASCADE CONSTRAINTS;
DROP TABLE slopes CASCADE CONSTRAINTS;
DROP TABLE zones CASCADE CONSTRAINTS;

CREATE TABLE bought_passes (
    start_datetime DATE NOT NULL,
    end_datetime   DATE NOT NULL,
    client_id      NUMBER(6) NOT NULL,
    pass_id        NUMBER NOT NULL
)
LOGGING;

ALTER TABLE bought_passes
    ADD CONSTRAINT bought_passes_pk PRIMARY KEY ( client_id,
                                                  pass_id,
                                                  start_datetime );

CREATE TABLE clients (
    client_id NUMBER(6) NOT NULL,
    name      VARCHAR2(30) NOT NULL,
    surname   VARCHAR2(40) NOT NULL
)
LOGGING;

ALTER TABLE clients ADD CONSTRAINT clients_pk PRIMARY KEY ( client_id );

CREATE TABLE instructors (
    instructor_id NUMBER(6) NOT NULL,
    name          VARCHAR2(30) NOT NULL,
    surname       VARCHAR2(30) NOT NULL
)
LOGGING;

ALTER TABLE instructors ADD CONSTRAINT instructors_pk PRIMARY KEY ( instructor_id );

CREATE TABLE lessons (
    lesson_date   DATE NOT NULL,
    price         NUMBER(4, 2) NOT NULL,
    instructor_id NUMBER(6) NOT NULL,
    client_id     NUMBER(6) NOT NULL
)
LOGGING;

ALTER TABLE lessons
    ADD CONSTRAINT lessons_pk PRIMARY KEY ( lesson_date,
                                            instructor_id,
                                            client_id );

CREATE TABLE lifts (
    lift_name VARCHAR2(40) NOT NULL,
    lenght    NUMBER(7) NOT NULL,
    type      VARCHAR2(30) NOT NULL,
    zone_id   NUMBER(5) NOT NULL
)
LOGGING;

ALTER TABLE lifts ADD CONSTRAINT lifts_pk PRIMARY KEY ( lift_name );

CREATE TABLE passes (
    pass_id          NUMBER NOT NULL,
    duration         NUMBER(5) NOT NULL,
    time_unit        VARCHAR2(30) NOT NULL,
    price            NUMBER(5, 2) NOT NULL,
    type_of_discount VARCHAR2(20) NOT NULL
)
LOGGING;

ALTER TABLE passes ADD CONSTRAINT passes_pk PRIMARY KEY ( pass_id );

CREATE TABLE rental_equipment (
    eq_id                      NUMBER(5) NOT NULL,
    name                       VARCHAR2(50) NOT NULL,
    rental_equipment_type_name VARCHAR2(50) NOT NULL
)
LOGGING;

ALTER TABLE rental_equipment ADD CONSTRAINT rental_equipment_pk PRIMARY KEY ( eq_id );

CREATE TABLE rental_equipment_type (
    name  VARCHAR2(50) NOT NULL,
    price NUMBER(5, 2) NOT NULL
)
LOGGING;

ALTER TABLE rental_equipment_type ADD CONSTRAINT rental_equipment_type_pk PRIMARY KEY ( name );

CREATE TABLE rentals (
    start_date DATE NOT NULL,
    end_date   DATE NOT NULL,
    duration   NUMBER(4) NOT NULL,
    client_id  NUMBER(6) NOT NULL,
    eq_id      NUMBER(5) NOT NULL
)
LOGGING;

ALTER TABLE rentals
    ADD CONSTRAINT rentals_pk PRIMARY KEY ( eq_id,
                                            client_id,
                                            start_date );

CREATE TABLE slopes (
    slop_name        VARCHAR2(40) NOT NULL,
    lenght           NUMBER(6) NOT NULL,
    difficulty_level VARCHAR2(40) NOT NULL
)
LOGGING;

ALTER TABLE slopes ADD CONSTRAINT slopes_pk PRIMARY KEY ( slop_name );

CREATE TABLE slopes_lifts (
    slop_name VARCHAR2(40) NOT NULL,
    lift_name VARCHAR2(40) NOT NULL
)
LOGGING;

ALTER TABLE slopes_lifts ADD CONSTRAINT slopes_lifts_pk PRIMARY KEY ( slop_name,
                                                                      lift_name );

CREATE TABLE zones (
    zone_id     NUMBER(5) NOT NULL,
    description VARCHAR2(100) NOT NULL
)
LOGGING;

ALTER TABLE zones ADD CONSTRAINT zones_pk PRIMARY KEY ( zone_id );

CREATE TABLE zones_passes (
    zone_id NUMBER(5) NOT NULL,
    pass_id NUMBER NOT NULL
)
LOGGING;

ALTER TABLE zones_passes ADD CONSTRAINT zones_passes_pk PRIMARY KEY ( zone_id,
                                                                      pass_id );

ALTER TABLE bought_passes
    ADD CONSTRAINT bought_passes_clients_fk FOREIGN KEY ( client_id )
        REFERENCES clients ( client_id )
    NOT DEFERRABLE;

ALTER TABLE bought_passes
    ADD CONSTRAINT bought_passes_passes_fk FOREIGN KEY ( pass_id )
        REFERENCES passes ( pass_id )
    NOT DEFERRABLE;

ALTER TABLE lessons
    ADD CONSTRAINT lessons_clients_fk FOREIGN KEY ( client_id )
        REFERENCES clients ( client_id )
    NOT DEFERRABLE;

ALTER TABLE lessons
    ADD CONSTRAINT lessons_instructors_fk FOREIGN KEY ( instructor_id )
        REFERENCES instructors ( instructor_id )
    NOT DEFERRABLE;

ALTER TABLE lifts
    ADD CONSTRAINT lifts_zones_fk FOREIGN KEY ( zone_id )
        REFERENCES zones ( zone_id )
    NOT DEFERRABLE;

ALTER TABLE rental_equipment
    ADD CONSTRAINT rental_eq_rental_eq_t_fk FOREIGN KEY ( rental_equipment_type_name )
        REFERENCES rental_equipment_type ( name )
    NOT DEFERRABLE;

ALTER TABLE rentals
    ADD CONSTRAINT rentals_clients_fk FOREIGN KEY ( client_id )
        REFERENCES clients ( client_id )
    NOT DEFERRABLE;

ALTER TABLE rentals
    ADD CONSTRAINT rentals_rental_equipment_fk FOREIGN KEY ( eq_id )
        REFERENCES rental_equipment ( eq_id )
    NOT DEFERRABLE;

ALTER TABLE slopes_lifts
    ADD CONSTRAINT slopes_lifts_lifts_fk FOREIGN KEY ( lift_name )
        REFERENCES lifts ( lift_name )
    NOT DEFERRABLE;

ALTER TABLE slopes_lifts
    ADD CONSTRAINT slopes_lifts_slopes_fk FOREIGN KEY ( slop_name )
        REFERENCES slopes ( slop_name )
    NOT DEFERRABLE;

ALTER TABLE zones_passes
    ADD CONSTRAINT zones_passes_passes_fk FOREIGN KEY ( pass_id )
        REFERENCES passes ( pass_id )
    NOT DEFERRABLE;

ALTER TABLE zones_passes
    ADD CONSTRAINT zones_passes_zones_fk FOREIGN KEY ( zone_id )
        REFERENCES zones ( zone_id )
    NOT DEFERRABLE;

CREATE SEQUENCE clients_client_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER clients_client_id_trg BEFORE
    INSERT ON clients
    FOR EACH ROW
    WHEN ( new.client_id IS NULL )
BEGIN
    SELECT
        clients_client_id_seq.NEXTVAL
    INTO :new.client_id
    FROM
        dual;

END;
/

CREATE SEQUENCE instructors_instructor_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER instructors_instructor_id_trg BEFORE
    INSERT ON instructors
    FOR EACH ROW
    WHEN ( new.instructor_id IS NULL )
BEGIN
    SELECT
        instructors_instructor_id_seq.NEXTVAL
    INTO :new.instructor_id
    FROM
        dual;

END;
/

CREATE SEQUENCE passes_pass_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER passes_pass_id_trg BEFORE
    INSERT ON passes
    FOR EACH ROW
    WHEN ( new.pass_id IS NULL )
BEGIN
    SELECT
        passes_pass_id_seq.NEXTVAL
    INTO :new.pass_id
    FROM
        dual;

END;
/

CREATE SEQUENCE rental_equipment_eq_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER rental_equipment_eq_id_trg BEFORE
    INSERT ON rental_equipment
    FOR EACH ROW
    WHEN ( new.eq_id IS NULL )
BEGIN
    SELECT
        rental_equipment_eq_id_seq.NEXTVAL
    INTO :new.eq_id
    FROM
        dual;

END;
/

CREATE SEQUENCE zones_zone_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER zones_zone_id_trg BEFORE
    INSERT ON zones
    FOR EACH ROW
    WHEN ( new.zone_id IS NULL )
BEGIN
    SELECT
        zones_zone_id_seq.NEXTVAL
    INTO :new.zone_id
    FROM
        dual;

END;
/

CREATE OR REPLACE PROCEDURE price_raise 
    (pPassId IN NUMBER, pPercent IN NUMBER DEFAULT 10) IS
BEGIN
    UPDATE Passes
    SET price = price *(1+pPercent/100)
    WHERE pass_id = pPassId;
 END;
/   

CREATE OR REPLACE FUNCTION day_summary
    (pData IN DATE )
    RETURN NATURAL IS
    vsummary NATURAL;
BEGIN 
    SELECT SUM(p.price) into vsummary
    FROM passes p JOIN bought_passes b
    WHERE pData LIKE b.start_datetime
    GROUP BY p.start_datetime;
    
    RETURN vsummary;
END;
/



INSERT INTO passes(duration, time_unit, price, type_of_discount) VALUES(2, 'dzien', 100, 'ulgowy - 50%');
/

