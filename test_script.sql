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
-- run the tests and display the results.

-- Finish with commiting work or rolling back.
