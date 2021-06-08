CREATE TABLE public.role
(
    id integer NOT NULL DEFAULT nextval('role_id_seq'::regclass),
    role character varying(150) COLLATE pg_catalog."default",
    CONSTRAINT role_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.role
    OWNER to devadmin;


INSERT INTO 
    public.role (id, role)
VALUES
(1,'Treasurer'),
(2,'Officer'),
(3,'Candidate'),
(4,'Primary Registering Lobbyist'),
(5,'Other Lobbyist'),
(6,'Primary User'),
(7,'Other User'),
(8,'Contributor'),
(9,'Payee'),
(10,'Lobbyist Employee'),
(11,'Lobbyist Subcontractor'),
(12,'Lobbyist Client'),
(13,'Lobbyist Relationship'),
(14,'Invited')