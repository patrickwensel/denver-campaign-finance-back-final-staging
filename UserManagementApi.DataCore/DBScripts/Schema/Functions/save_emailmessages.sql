-- FUNCTION: public.save_emailmessages(integer, character varying, character varying, character varying, character varying, date, boolean, date)

-- DROP FUNCTION public.save_emailmessages(integer, character varying, character varying, character varying, character varying, date, boolean, date);

CREATE OR REPLACE FUNCTION public.save_emailmessages(
	_emailtypeid integer,
	_txnrefid character varying,
	_receiverid character varying,
	_subject character varying,
	_message character varying,
	_sendon date,
	_isuseractionrequired boolean,
	_expirydatetime date)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
 insert into public."email_messages" ("email_type_id", "txn_ref_id", "receiver_id", "subject", "message", "sent_on", "is_user_action_required", "expiry_datetime", "created_by", "created_at", "updated_by", "updated_on")
 values(_emailtypeid, _txnrefid, _receiverid, _subject, _message, _sendon, _isuseractionrequired, _expirydatetime, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_emailmessages(integer, character varying, character varying, character varying, character varying, date, boolean, date)
    OWNER TO devadmin;
