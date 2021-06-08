-- FUNCTION: public.save_officesdetails(character varying, character varying)

-- DROP FUNCTION public.save_officesdetails(character varying, character varying);

CREATE OR REPLACE FUNCTION public.save_officesdetails(
	_typename character varying,
	_typeid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
IF EXISTS (SELECT type_id FROM public.type_lookups where type_id=_typeid) THEN

update public.type_lookups set "name" = _typename
where type_id=_typeid; 

ELSE

INSERT INTO public.type_lookups(lookup_type_code, type_id, "name", "desc", "Order", status_code)
values('OFF', _typeid, _typename, '', 1, 'ACTIVE');

END IF;
 
  --return (SELECT LASTVAL());
 return 1;
end
$BODY$;

ALTER FUNCTION public.save_officesdetails(character varying, character varying)
    OWNER TO devadmin;
