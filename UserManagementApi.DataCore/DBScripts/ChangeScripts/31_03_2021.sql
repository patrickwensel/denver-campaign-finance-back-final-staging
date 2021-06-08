----------------------------------------Functions------------------------------------------
CREATE OR REPLACE FUNCTION public.update_bankinfo(
	_committeeid integer,
	_bankname character varying,
	_address1 character varying,
	_address2 character varying,
	_city character varying,
	_statecode character varying,
	_zip character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
update public."committee" set bank_name=_bankname, bank_address1=_address1, 
bank_address2=_address2, bank_city=_city,  
bank_state_code=_statecode, bank_zip=_zip,created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "committee_id" = _committeeid;
 
  return _committeeid;
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.update_bankinfo(integer, character varying, character varying, character varying, character varying, character varying, character varying)
    OWNER TO devadmin;
---------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.validateemail(
	useremailid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 IF EXISTS (SELECT email FROM public.contact where email=useremailid) THEN
  		 return 1;
		 ELSE
		  return 0;
 	 	END IF;

end
$BODY$;

ALTER FUNCTION public.validateemail(character varying)
    OWNER TO devadmin;

-------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.get_officerlist(
	committeeid integer)
    RETURNS TABLE(contactid integer, firstname character varying, lastname character varying, description character varying, officertype character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  select off.contact_id, 
  off.first_name,
  off.last_name,
  off.description,
  rle.role
  
  from public.contact off 
  inner join public.contact_role_mapping crm
   on off.contact_id = crm.contact_id
  inner join public.filer fil 
  on crm.filer_id =fil.entity_id
  inner join public.role rle 
  on rle.id = crm.role_type_id
  where fil.entity_id = committeeid and fil.entity_type= 'COMMITTEE'
   order by off.contact_id;
 end
$BODY$;
----------------------------------------Functions------------------------------------------