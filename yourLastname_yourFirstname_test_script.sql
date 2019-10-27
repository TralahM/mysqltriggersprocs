/************ Student Name ***********/
/*********** Student Number **********/

-- Create the tables
-- Populate the tables
-- Create the stored objects (procedures/functions/triggers)
-- Then...

-- Turn off autocommit so you can have better control on what you are doing by rolling back transactions.
set autocommit = 0;

-- Inspect the invoice and the alerts table
select * from invoice;
select * from alerts;

--Update the invoice table
update invoice set STATUS = 'OVERDUE' where INVOICENO = 2;

-- Verify that the trigger you implemented works
select * from invoice;
select * from alerts;

-- Bring DB back to original state; re-check
rollback;
select * from invoice;
select * from alerts;

-- Synchronise the invoice table and verify the procedure behaves as desired
call sync_invoice;
select * from invoice;
select * from alerts;

-- Bring DB back to original state; delete campaign# 2; check all relevant tables
rollback;
delete from invoice where campaign_no = 2;
select * from invoice;
select * from alerts;
select * from campaign;
select * from salarygrade;
select * from staff;
select * from staffongrade;
select * from workson;

-- Finish the campaign titled RED. Verify that it behaves as desired.
call sp_finish_campaign('RED');
select * from campaign;
select * from invoice;
call sp_finish_campaign('GREEN'); -- should SIGNAL error condition


-- Synchronise the invoice table and verify the procedure behaves as desired
call sync_invoice;
select * from alerts;
rollback;

-- The test above is minimal with very little data.
-- Think of tests that you need to carry out to gain confidence cthat the programs you wrote does the right thing.
-- Insert more data to the tables strategically to show quickly if there are semantic errors in your programs.
insert into campaign (CAMPAIGN_NO,TITLE,CUSTOMER_ID,THEME,CAMPAIGNSTARTDATE,CAMPAIGNFINISHDATE,ESTIMATEDCOST,ACTUALCOST)
values
(6,"Marketing",9,"Dummy","2017-04-02","2017-08-09",25500,NULL),
(7,"promotion",5,"ANother","2018-06-24","2018-11-29",25900,NULL),
(9,"campaign",4,"broadcast","2019-10-23","2019-12-29",45700,NULL),
(8,"roadshow",8,"mysql","2018-04-23","2018-12-23",9500,NULL),
(10,"reseller",7,"technology","2019-04-13","2019-06-19",19000,NULL);
-- run the tests and display the results.
commit;
select * from campaign;
select * from invoice;
call sp_finish_campaign('promotion');
call sp_finish_campaign('Marketing');
call sync_invoice;
select * from alerts;


-- Finish with commiting work or rolling back.
