------------------------------------------------------------------------------
--tablename:Penalty
--date:04-22-2021
--DevelopedBy: Lakshmana Kareti
-------------------------------------------------------------------------------


CREATE TABLE public.penalty
(
Penalty_Id serial NOT NULL,
amount Numeric(12,2) NOT NULL,
"date" date NULL,
reason character varying (1000) NOT NULL,
filer_id integer NOT NULL
)

WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.app_setting
    OWNER to devadmin;
