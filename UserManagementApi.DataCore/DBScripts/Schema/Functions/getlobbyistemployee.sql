-- FUNCTION: public.getlobbyistemployee(integer)

-- DROP FUNCTION public.getlobbyistemployee(integer);

CREATE OR REPLACE FUNCTION public.getlobbyistemployee(
	_lobbyistid integer)
    RETURNS TABLE(contactid integer, employeename text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE roleTypeId int = 0;
DECLARE primaryUserId int = 0;
DECLARE lobbyistType character varying;
DECLARE fillerId int = 0;
begin
	SELECT id INTO roleTypeId
	  FROM public.role 
	WHERE role = 'Lobbyist Employee';
	
	SELECT primary_contact_id, type, filer_contact_id INTO primaryUserId, lobbyistType, fillerId
  		FROM public.lobbyist 
  	WHERE lobbysit_id = _lobbyistid;

	if lobbyistType = 'LOB-O' then
	begin
		return query
			SELECT c.contact_id,
				CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
					ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
				END as fullName
			FROM public.contact_role_mapping crm
			INNER JOIN public.contact c  ON crm.contact_id = c.contact_id
			INNER JOIN public.lobbyist l ON c.contact_id = l.filer_contact_id
				WHERE crm.role_type_id = roleTypeId
					AND crm.filer_id = fillerId
					AND lower(coalesce(c.status_code, 'active')) = 'active'
					 and crm.status_code='ACTIVE'
			UNION
			 SELECT c.contact_id,
				CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
					ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
				END as fullName
			 FROM public.contact c 
			INNER JOIN public.lobbyist l ON c.contact_id = l.filer_contact_id
			 WHERE c.contact_id = fillerId
			 	AND lower(coalesce(c.status_code, 'active')) = 'active';
		end;
		else
		begin
			return query
			SELECT c.contact_id,
				CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
					ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
				END as fullName
			 FROM public.contact c 
			 INNER JOIN public.lobbyist l ON c.contact_id = l.filer_contact_id
			 	WHERE c.contact_id = fillerId
			 		AND lower(coalesce(c.status_code, 'active')) = 'active';
		end;
		end if;
end
$BODY$;

ALTER FUNCTION public.getlobbyistemployee(integer)
    OWNER TO devadmin;
