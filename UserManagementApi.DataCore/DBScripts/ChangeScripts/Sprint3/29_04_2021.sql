--------------------------------Tables -----------------------------------------------------
-------------------------------------------------------------------------------------------
ALTER TABLE user_account
ADD COLUMN  last_seen date

--------------------------------------------------------------------------------------------
-------------------------Functions---------------------------------------------------------
-- FUNCTION: public.get_currentactiveusers(integer, integer, text, text, date, date, date, date)

-- DROP FUNCTION public.get_currentactiveusers(integer, integer, text, text, date, date, date, date);

CREATE OR REPLACE FUNCTION public.get_currentactiveusers(
	_filerid integer,
	_userid integer,
	_filertype text,
	_status text,
	_lastactivestartdate date,
	_lastactiveenddate date,
	_createdstartdate date,
	_createdenddate date)
    RETURNS TABLE(contactid integer, userid integer, username text, createdstartdate date, lastactivestartdate date, status character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE filerIdVal int = 0;
DECLARE filertypeids text;
DECLARE userIdVal int = 0;
begin

return query
select * from(select c.contact_id,
ua.user_id,
c.first_name || ' ' || c.middle_name || ' ' || c.last_name as username,
c.created_at,
ua.last_seen,
tlup.name
from contact_role_mapping crm
inner join contact c on crm.contact_id=c.contact_id
inner join user_account ua on ua.user_id = crm.user_id
inner join type_lookups tlup on tlup.type_id = ua.status) as t
where user_id = case when _userid = 0 then user_id else _userid end
and last_seen between _lastactivestartdate and _lastactiveenddate
and created_at between _createdstartdate and _createdenddate

;
end
$BODY$;

ALTER FUNCTION public.get_currentactiveusers(integer, integer, text, text, date, date, date, date)
    OWNER TO devadmin;

-------------------------Functions---------------------------------------------------------
-- FUNCTION: public.get_useraffiliations(integer, integer, text, text, date, date, date, date)

-- DROP FUNCTION public.get_useraffiliations(integer, integer, text, text, date, date, date, date);

CREATE OR REPLACE FUNCTION public.get_useraffiliations(
	_filerid integer,
	_userid integer,
	_filertype text,
	_status text,
	_lastactivestartdate date,
	_lastactiveenddate date,
	_createdstartdate date,
	_createdenddate date)
    RETURNS TABLE(contactid integer, filerid integer, userid integer, username text, filername character varying, userrole character varying, createdstartdate date, lastactivestartdate date, status character varying, entitytype character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE filerIdVal int = 0;
DECLARE filertypeids text;
DECLARE userIdVal int = 0;
begin

return query
SELECT * FROM ( 
	 
	 
select
c.contact_id,
--crm.role_type_id,
fil.filer_id,
ua.user_id,
c.first_name || ' ' || c.middle_name || ' ' || c.last_name as username,
com.name as filername,
rl.role ,
c.created_at,
ua.last_seen,
fil.filer_status,
fil.entity_type
from contact_role_mapping crm
inner join contact c on crm.contact_id=c.contact_id
inner join role rl on rl.id = crm.role_type_id
inner join user_account ua on ua.user_id = crm.user_id
inner join filer fil on fil.filer_id = crm.filer_id
inner join committee com on com.Committee_id = fil.entity_id and fil.entity_type='C'

UNION

select
c.contact_id,
--crm.role_type_id,
fil.filer_id,
ua.user_id,
c.first_name || ' ' || c.middle_name || ' ' || c.last_name as username,
 			CASE WHEN L.type='LOB-O'  THEN Con.Org_name
		    WHEN CONCAT(con.middle_name, 'ZZZ') = 'ZZZ' THEN con.first_name || ' ' || con.last_name
			ELSE  con.first_name || ' ' || con.middle_name || ' ' || con.last_name
			END as filername,
rl.role ,
c.created_at,
ua.last_seen,
fil.filer_status,
fil.entity_type
from contact_role_mapping crm
inner join contact c on crm.contact_id=c.contact_id
inner join role rl on rl.id = crm.role_type_id
inner join user_account ua on ua.user_id = crm.user_id
inner join filer fil on fil.filer_id = crm.filer_id
inner join lobbyist L on L.lobbysit_id = fil.entity_id and fil.entity_type='L'
Left join contact con on con.contact_id = L.filer_contact_id

UNION

select
c.contact_id,
--crm.role_type_id,
fil.filer_id,
ua.user_id,
c.first_name || ' ' || c.middle_name || ' ' || c.last_name as username,
CCO.first_name || ' ' || CCO.middle_name || ' ' || CCO.last_name   as filername,
rl.role ,
c.created_at,
ua.last_seen,
fil.filer_status,
fil.entity_type
from contact_role_mapping crm
inner join contact c on crm.contact_id=c.contact_id
inner join role rl on rl.id = crm.role_type_id
inner join user_account ua on ua.user_id = crm.user_id
inner join filer fil on fil.filer_id = crm.filer_id 
inner join Contact CCO on C.Contact_id = fil.entity_id and fil.entity_type='CO'

UNION
	 
	 
select
c.contact_id,
--crm.role_type_id,
fil.filer_id,
ua.user_id,
c.first_name || ' ' || c.middle_name || ' ' || c.last_name as username,
ie.first_name || ' ' || ie.middle_name || ' ' || ie.last_name   as filername,
rl.role ,
c.created_at,
ua.last_seen ,
fil.filer_status,
fil.entity_type
from contact_role_mapping crm
inner join contact c on crm.contact_id=c.contact_id
inner join role rl on rl.id = crm.role_type_id
inner join user_account ua on ua.user_id = crm.user_id
inner join filer fil on fil.filer_id = crm.filer_id
inner join Contact ie on ie.Contact_id = fil.entity_id and fil.entity_type='IE') as t
Where 

user_id = case when _userid = 0 then user_id else _userid end
and filer_id = case when _filerid = 0 then filer_id else _filerid end
and last_seen between _lastactivestartdate and _lastactiveenddate
and created_at between _createdstartdate and _createdenddate 
and entity_type= any (string_to_array(_filertype, ','))
and filer_status= any (string_to_array(_status, ','))
ORDER BY CASE WHEN role = 'Primary User' THEN 1
else
2
END
;
end
$BODY$;

ALTER FUNCTION public.get_useraffiliations(integer, integer, text, text, date, date, date, date)
    OWNER TO devadmin;



-------------------------Functions---------------------------------------------------------
-------------------------Functions---------------------------------------------------------
-------------------------Functions---------------------------------------------------------
-------------------------------------------------------------------
-------------------------------------------------------------------------------------------