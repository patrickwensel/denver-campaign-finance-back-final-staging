-- FUNCTION: public.save_filingperiodfilertypedetails(integer, character varying)

-- DROP FUNCTION public.save_filingperiodfilertypedetails(integer, character varying);

CREATE OR REPLACE FUNCTION public.save_filingperiodfilertypedetails(
	_filingperiodid integer,
	_filertypeid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE filingperiodfilertypemappingid int = 0;

begin
SELECT filing_period_filer_type_mapping_id INTO filingperiodfilertypemappingid   FROM public.filing_period_filer_type_mapping where filing_period_id=_filingperiodid and filer_type_id=_filertypeid;

	IF EXISTS (SELECT filing_period_filer_type_mapping_id FROM public.filing_period_filer_type_mapping where filing_period_id=_filingperiodid and filer_type_id=_filertypeid) THEN
  		
		update public.filing_period_filer_type_mapping set filing_period_id=_filingperiodid,
		filer_type_id=_filertypeid,status_code='ACTIVE', updated_by='Denver',  updated_on=NOW() where filing_period_filer_type_mapping_id = filingperiodfilertypemappingid ;
				return filingperiodfilertypemappingid;
		else
		INSERT INTO public.filing_period_filer_type_mapping(filing_period_id,filer_type_id,status_code,
    created_by,
    created_at,
    updated_by,
    updated_on)
	VALUES (_filingperiodid, _filertypeid, 'ACTIVE',
			'Denver',
			NOW(),'Denver',NOW());
			

		return (SELECT LASTVAL());
 	 	END IF;
	
	 -- inserted fail
	

end
$BODY$;

ALTER FUNCTION public.save_filingperiodfilertypedetails(integer, character varying)
    OWNER TO devadmin;
