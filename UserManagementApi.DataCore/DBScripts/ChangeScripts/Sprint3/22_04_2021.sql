--------------------------------Tables -----------------------------------------------------
-------------------------------------------------------------------------------------------


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

    --------------------------------------------------------------------------------------------
    -------------------------Functions---------------------------------------------------------

    -- FUNCTION: public.save_penalty(numeric, date, character varying, integer)

-- DROP FUNCTION public.save_penalty(numeric, date, character varying, integer);

CREATE OR REPLACE FUNCTION public.save_penalty(
	_amount numeric,
	_pymtdate date,
	_reason character varying,
	_entityid integer,
	_entitytype character varying )
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare filerid int ;
BEGIN


select filer_id into filerid from filer where 
entity_type=_entitytype and entity_id=_entityid;

 insert into public.penalty 
  ( amount,"date",reason,filer_id)
 values
 (_amount,_pymtdate,_reason,filerid);
  return (SELECT LASTVAL());


END
$BODY$;

ALTER FUNCTION public.save_penalty(numeric, date, character varying, integer)
    OWNER TO devadmin;
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------