/**********************************************************
 ****** Stored Programs for Assn.2, 2019 *******************
 ********** Student Name and Number ************************
 ******************* Date **********************************
 ** I DECLARE that the code provided below is my own work **
 ******* Any help received is duely acknowledged here ******
 **********************************************************/

/********* Trigger TR_OVERDUE ************/

delimiter //
DROP TRIGGER IF EXISTS tr_overdue
//

CREATE TRIGGER tr_overdue AFTER UPDATE ON invoice
FOR EACH ROW
    BEGIN
        IF old.STATUS <> "OVERDUE" AND new.STATUS = "OVERDUE" THEN
            INSERT INTO alerts(message_date,origin,message) values(CURRENT_DATE,CURRENT_USER,CONCAT( "Invoice with number: ",new.INVOICENO," is now overdue!"));
        END IF;
    END
//

/************* Helper FUNCTIONs/PROCEDUREs used, two FUNCTIONs for example ****************/

DROP FUNCTION IF EXISTS rate_on_date
//
CREATE FUNCTION rate_on_date(staff_id int, given_date DATE) returns float DETERMINISTIC
    BEGIN
        DECLARE total_days_pay float;
        DECLARE hour_rate float;
        DECLARE cur1 CURSOR for select HOURLYRATE,SUM(HOURLYRATE*HOUR) from staffongrade,salarygrade,workson WHERE staffongrade.STAFFNO=staff_id AND salarygrade.GRADE=staffongrade.GRADE AND workson.WDATE=given_date AND workson.STAFFNO=staff_id;
        open cur1;
        read_loop: LOOP
        FETCH cur1 INTO hour_rate,total_days_pay;
    END LOOP;
    return hour_rate;

END
//
--
DROP FUNCTION IF EXISTS cost_of_campaign

//

CREATE FUNCTION cost_of_campaign (camp_id int)
returns float
-- retuens the total cost incurred due to any given campaigh (camp_id)
-- READS SQL DATA
-- DETERMINISTIC
BEGIN
    -- code
    DECLARE total_cost FLOAT;
    DECLARE cur1 CURSOR FOR select SUM(HOURLYRATE*HOUR) from staffongrade,salarygrade,workson,campaign WHERE staffongrade.STAFFNO=workson.STAFFNO AND salarygrade.GRADE=staffongrade.GRADE AND workson.CAMPAIGN_NO=camp_id AND staffongrade.STARTDATE >=campaign.CAMPAIGNSTARTDATE AND staffongrade.FINISHDATE <= campaign.CAMPAIGNFINISHDATE;
    open cur1;
    read_loop: LOOP
    FETCH cur1 INTO total_cost;
END LOOP;

-- employ FUNCTION  rate_on_date IF necessary
return total_cost;

END
//

/************ PROCEDURE SP_FINISH_CAMPAIGN******************/


DROP PROCEDURE IF EXISTS sp_finish_campaign
//

CREATE PROCEDURE sp_finish_campaign (IN c_title VARCHAR(30))

-- code
-- DECLARE CONTINUE HANDLER FOR NOT FOUND; */
-- error_string =  'ERROR! Campaign title does not exist'; */
BEGIN
    -- do the error handling
DECLARE cost int;
DECLARE error_string varchar(255);
    SET cost = cost_of_campaign(CAMPAIGN_NO);
    UPDATE campaign SET CAMPAIGNFINISHDATE=CURRENT_DATE, ACTUALCOST = cost WHERE TITLE=c_title;
END
//

/************ PROCEDURE SYNC_INVOICE******************/

DROP PROCEDURE IF EXISTS sync_invoice;
//
CREATE PROCEDURE sync_invoice()
BEGIN
    -- code
    UPDATE invoice
    SET STATUS="OVERDUE"
    WHERE STATUS="UNPAID" AND DATEDIFF(CURRENT_DATE,DATEISSUED) > 30;
END
//

delimiter ;


