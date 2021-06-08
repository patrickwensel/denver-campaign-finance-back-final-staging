CREATE OR REPLACE FUNCTION public.update_committeeorlobbyiststatus(
	_id integer,
	_status boolean,
	_notes character varying,
	_entitytype character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
if (_entitytype) = 'C' then

update public.committee set status_code = CASE
           WHEN _status THEN 'ACTIVE' ELSE 'DENIED' END, admin_notes = _notes where committee_id = _id;
return _id;
elseif (_entitytype) = 'L' then
update public.lobbyist set status_code = CASE
           WHEN _status THEN 'ACTIVE' ELSE 'DENIED' END, admin_notes = _notes where lobbysit_id = _id;
return _id;
end if;
end
$BODY$;

ALTER FUNCTION public.update_committeeorlobbyiststatus(integer, boolean, character varying, character varying)
    OWNER TO devadmin;
