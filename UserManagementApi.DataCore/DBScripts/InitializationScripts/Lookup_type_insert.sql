----------------------------------------Insert Scripts------------------------------------------

-- Insert Look Up Data


--  User Type INSERT

insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('AC','AC-CAN', 'Candidate','Running for office in the city of Denver and reports on campaign finance.',1);
insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('AC','AC-TST', 'Committee Treasurer or Other Committee Member','Report on campaign finance for any form of committee.',2);
insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('AC','AC-IEF', 'Independent Expenditure Filer','Reports spending to influence an election independent of a candidates committee.',3);
insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('AC','AC-LOB', 'Lobbyist','Reports disclosures "of" lobbying activities.',4);
insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('AC','AC-CFE', 'Covered Official or Former City Employee','Reports financial, gift "and" city item disclosures.',5);


--- Lobbyist Type INSERT

insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('LOB_TYPE','LOB-I', 'Individual','Individual',1);
insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('LOB_TYPE','LOB-O', 'Organization','Organization',2);
	   
--- Commitee Type Insert
	   
insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('COM','COM-IC', 'Issue Committee','Issue Committee',1);
insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('COM','COM-PAC', 'PAC Committee','PAC Committee',2);
insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('COM','COM-SDC', 'Small Donor Committee','Small Donor Committee',3);
insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('COM','COM-CAN', 'Candidate Committee','Candidate Committee',4);
	   

--- Office Type Insert

insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('OFF','OFF-CLL', 'City Council','City Council',1);
insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('OFF','OFF-M', 'Mayor','Mayor',2);
insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('OFF','OFF-CR', 'Clerk and Recorder','Clerk and Recorder',3);
insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('OFF','OFF-TR', 'Treasurer ','Treasurer ',4);
insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('OFF','OFF-AUD', 'Auditor ','Auditor ',5);
insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('OFF','OFF-OTH', 'Other ','Other ',6);

--- Filer Type Insert
insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('FILER-TYPE','FT-IND', 'Individual','Individual',1);
insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('FILER-TYPE','FT-ORG', 'Organization','Organization',2);
-- Invoice Type Insert
	INSERT INTO public.type_lookups(
	lookup_type_code, type_id, "name", "desc", "Order", status_code)
	VALUES ('INVOICE_TYPE', 'FIN', 'Fine', 'FINE', 2,'ACTIVE' );
	
	INSERT INTO public.type_lookups(
	lookup_type_code, type_id, "name", "desc", "Order", status_code)
	VALUES ('INVOICE_TYPE', 'FE', 'Fee', 'FEE', 1,'ACTIVE' );
	
	INSERT INTO public.type_lookups(
	lookup_type_code, type_id, "name", "desc", "Order", status_code)
	VALUES ('INVOICE_TYPE', 'PEN', 'Penalty', 'PENALTY', 3,'ACTIVE' );
	
	--Invoice Status type Insert
	INSERT INTO public.type_lookups(
	lookup_type_code, type_id, "name", "desc", "Order", status_code)
	VALUES ('INVOICE_STATUS', 'UND', 'Under Review ', 'Under Review', 1,'ACTIVE' );
	
	INSERT INTO public.type_lookups(
	lookup_type_code, type_id, "name", "desc", "Order", status_code)
	VALUES ('INVOICE_STATUS', 'P', 'Paid', 'Paid', 2,'ACTIVE' );
	
	
	--Payment Method type Insert
	INSERT INTO public.type_lookups(
	lookup_type_code, type_id, "name", "desc", "Order", status_code)
	VALUES ('PYMT_MD', 'ONL', 'Online', 'Online', 1,'ACTIVE' );
	
	
	INSERT INTO public.type_lookups(
	lookup_type_code, type_id, "name", "desc", "Order", status_code)
	VALUES ('PYMT_MD', 'C', 'Cash', 'Cash', 2,'ACTIVE' );
	
	
	INSERT INTO public.type_lookups(
	lookup_type_code, type_id, "name", "desc", "Order", status_code)
	VALUES ('PYMT_MD', 'CHK', 'Check', 'Check', 3,'ACTIVE' );
	
	
	INSERT INTO public.type_lookups(
	lookup_type_code, type_id, "name", "desc", "Order", status_code)
	VALUES ('PYMT_MD', 'WAI', 'Waiver', 'Waiver', 4,'ACTIVE' );
	
	
	INSERT INTO public.type_lookups(
	lookup_type_code, type_id, "name", "desc", "Order", status_code)
	VALUES ('PYMT_MD', 'RED', 'Reduction', 'Reduction', 5,'ACTIVE' );
	
--Attachment Type Insert
INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('ATTACHMENT-TYPE', 'PYMT_RPT', 'Payment Receipt', 'Payment Receipt',1, 'ACTIVE');
	
	INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('ATTACHMENT-TYPE', 'PEN_RPT', 'Penalty Receipt', 'Penalty Receipt',2, 'ACTIVE');
	
	INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('ATTACHMENT-TYPE', 'REF_RPT', 'Refund Receipt', 'Refund Receipt',3, 'ACTIVE');
	
	INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('ATTACHMENT-TYPE', 'INV', 'Invoice', 'Invoice',4, 'ACTIVE');
	
	INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('ATTACHMENT-TYPE', 'AUD', 'Audit', 'Audit',5, 'ACTIVE');
	
	INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('ATTACHMENT-TYPE', 'DOC', 'Document', 'Document',6, 'ACTIVE');



<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<AUTO GENERATED BY CONFLICT EXTENSION<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Dev
	---27-04-2021 SubTransacion and Loan Lookup insert scripts

		INSERT INTO 
    public.type_lookups (lookup_type_code, type_id, "name", "desc", "Order", status_code)
VALUES
('SUBTRANSACTIONS','SUBT-INTP', 'Interest Payment', 'Interest Payment', 1, 'ACTIVE'),
('SUBTRANSACTIONS','SUBT-PAY', 'Payment', 'Payment', 2, 'ACTIVE'),
('SUBTRANSACTIONS','SUBT-FOR', 'Forgiveness', 'Forgiveness', 3, 'ACTIVE')

INSERT INTO 
    public.type_lookups (lookup_type_code, type_id, "name", "desc", "Order", status_code)
VALUES
('LOAN','LOAN-COM', 'Commercial Loan', 'Commercial Loan', 1, 'ACTIVE'),
('LOAN','LOAN-PER', 'Personal Loan', 'Personal Loan', 2, 'ACTIVE')



--------------Email Type


insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('EMAIL-STATUS','MAKE-T', 'Make Treasurer','Make Treasurer',1);

insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('EMAIL-STATUS','MAKE-F', 'Make Filer','Make Filer',2);


--------------------------------------------------


---27-04-2021 SubTransacion and Loan Lookup insert scripts

		INSERT INTO 
    public.type_lookups (lookup_type_code, type_id, "name", "desc", "Order", status_code)
VALUES
('SUBTRANSACTIONS','SUBT-INTP', 'Interest Payment', 'Interest Payment', 1, 'ACTIVE'),
('SUBTRANSACTIONS','SUBT-PAY', 'Payment', 'Payment', 2, 'ACTIVE'),
('SUBTRANSACTIONS','SUBT-FOR', 'Forgiveness', 'Forgiveness', 3, 'ACTIVE')

INSERT INTO 
    public.type_lookups (lookup_type_code, type_id, "name", "desc", "Order", status_code)
VALUES
('LOAN','LOAN-COM', 'Commercial Loan', 'Commercial Loan', 1, 'ACTIVE'),
('LOAN','LOAN-PER', 'Personal Loan', 'Personal Loan', 2, 'ACTIVE')



--------------Email Type


insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('EMAIL-STATUS','MAKE-T', 'Make Treasurer','Make Treasurer',1);

insert into public.type_lookups(lookup_type_code,type_id, "name", "desc", "Order")
values('EMAIL-STATUS','MAKE-F', 'Make Filer','Make Filer',2);


-----27-04-2021 for TRANSACTION lookup details

INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('TRN-TYPE', 'TRN-CONT', 'Contribution', 'Contribution', 1, 'ACTIVE');

INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('TRN-TYPE', 'TRN-EXPT', 'Expenditure', 'Expenditure', 2, 'ACTIVE');

INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('TRN-TYPE', 'TRN-UPOB', 'Unpaid Obligation', 'Unpaid Obligation', 3, 'ACTIVE');

INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('TRN-TYPE', 'TRN-LOAN', 'Loan', 'Loan', 4, 'ACTIVE');
	
INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('TRN-TYPE', 'TRN-IEXP', 'Independent Expenditure', 'Independent Expenditure', 5, 'ACTIVE');

INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('CON-TYPE', 'CON-O', 'Organization', 'Organization', 1, 'ACTIVE');

INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('CON-TYPE', 'CON-I', 'Individual', 'Individual', 2, 'ACTIVE');
	
INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('CTN-TYPE', 'MON', 'Monetary', 'Monetary', 1, 'ACTIVE');

INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('CTN-TYPE', 'INK', 'In Kind', 'In Kind', 2, 'ACTIVE');
	
	
INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('MON-TYPE', 'CCN', 'Cash/Coin', 'Cash/Coin', 1, 'ACTIVE');

INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('MON-TYPE', 'CRY', 'Cryptocurrency', 'Cryptocurrency', 2, 'ACTIVE');
	
	
INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('EXP-CAT', 'PEE', 'Post-Election Exemption', 'Post-Election Exemption', 1, 'ACTIVE');
	
INSERT INTO public.role(
	id, role)
	VALUES (nextval('role_id_seq'), 'Contributor');
	
INSERT INTO public.role(
	id, role)
	VALUES (nextval('role_id_seq'), 'Payee');
	
INSERT INTO public.role(
	id, role)
	VALUES (nextval('role_id_seq'), 'Lender');
	

---- 29-04-2021
	
INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('IE_TYPE', 'C', 'Candidate', 'Candidate', 1, 'ACTIVE');
	
INSERT INTO public.type_lookups(
	lookup_type_code, type_id, name, "desc", "Order", status_code)
	VALUES ('IE_TYPE', 'I', 'Ballot Issue', 'Ballot Issue', 2, 'ACTIVE');


----------------------------------------Insert Scripts------------------------------------------