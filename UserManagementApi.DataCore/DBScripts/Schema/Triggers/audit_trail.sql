---------------------------------------------------------------
--Name of the Trigger: audit_trail_log
--Purpose: Maintain the All the tables DML
--developedBy : Denver API teams
--Date: 07-04-2021
---------------------------------------------------------------
CREATE or replace FUNCTION public.audit_trail_log()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
sessionemailid character varying(100);
BEGIN
   if (TG_OP = 'INSERT') then
       INSERT INTO audit_log_trail (
           
           old_row_data,
           new_row_data,
           transact_type,
           dml_timestamp,
           identitys,
		   table_name,
		   userid
		   
       )
       VALUES(
          
           null,
           to_jsonb(NEW),
           'INSERT',
           NOW(),
		  NEW.id,
		  TG_TABLE_NAME::TEXT,
		 sessionemailid
       );  
       RETURN NEW;
   elsif (TG_OP = 'UPDATE') then
       INSERT INTO audit_log_trail (
          
           old_row_data,
           new_row_data,
           transact_type,
           dml_timestamp,
           identitys,
		   table_name,
		    userid
       )
       VALUES(
          
           to_jsonb(OLD),
           to_jsonb(NEW),
           'UPDATE',
           NOW(),
           NEW.id,
		    TG_TABLE_NAME::TEXT,
		  sessionemailid
       );
             
       RETURN NEW;
   elsif (TG_OP = 'DELETE') then
       INSERT INTO audit_log_trail (
          
           old_row_data,
           new_row_data,
           transact_type,
           dml_timestamp,
           identitys,
		   table_name,
		    userid
       )
       VALUES(
          
           to_jsonb(OLD),
           null,
           'DELETE',
           NOW(),
           NEW.id,
		    TG_TABLE_NAME::TEXT,
		   sessionemailid
       );
        
       RETURN OLD;
   end if;
     
END;
$BODY$;
----------------------------------------END-------------------------------------------

