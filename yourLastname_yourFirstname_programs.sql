/**********************************************************
 ****** Stored Programs FOR Assn.2, 2019 *******************
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
            INSERT INTO alerts (message_date,origin,message) values(CURRENT_DATE,CURRENT_USER,CONCAT( "Invoice with number: ",new.INVOICENO," is now overdue!"));
        END IF;
    END
//

/************* Helper FUNCTIONs/PROCEDUREs used, two FUNCTIONs FOR example ****************/

DROP FUNCTION IF EXISTS rate_on_date
//
CREATE FUNCTION rate_on_date(staff_id INTEGER, given_date DATE) returns FLOAT DETERMINISTIC
BEGIN
    DECLARE total_days_pay FLOAT;
    DECLARE hour_rate FLOAT;
    DECLARE finished INTEGER;
    DECLARE cur1 CURSOR FOR SELECT HOURLYRATE FROM staffongrade,salarygrade,workson WHERE staffongrade.STAFFNO=staff_id AND salarygrade.GRADE=staffongrade.GRADE AND workson.WDATE=given_date AND workson.STAFFNO=staff_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished=1;
    OPEN cur1;
    read_loop: LOOP
        IF finished=1 THEN
            LEAVE read_loop;
        END IF;
        FETCH cur1 INTO hour_rate;
    END LOOP ;
    CLOSE cur1;
    return hour_rate;

END
//
--
DROP FUNCTION IF EXISTS cost_of_campaign

//

CREATE FUNCTION cost_of_campaign (camp_id INTEGER)
returns FLOAT
-- retuens the total cost incurred due to any given campaigh (camp_id)
-- READS SQL DATA
-- DETERMINISTIC
BEGIN
    -- code
    DECLARE total_cost FLOAT;
    DECLARE finished INTEGER;
    DECLARE cur1 CURSOR FOR SELECT SUM(HOURLYRATE*HOUR) FROM staffongrade,salarygrade,workson,campaign WHERE staffongrade.STAFFNO=workson.STAFFNO AND salarygrade.GRADE=staffongrade.GRADE AND workson.CAMPAIGN_NO=camp_id AND staffongrade.STARTDATE >=campaign.CAMPAIGNSTARTDATE AND staffongrade.FINISHDATE <= campaign.CAMPAIGNFINISHDATE;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished=1;
    OPEN cur1;
    read_loop: LOOP
        IF finished=1 THEN
            LEAVE read_loop;
        END IF;
        FETCH cur1 INTO total_cost;
    END LOOP ;
    CLOSE cur1;
    return total_cost;

END
//

/************ PROCEDURE SP_FINISH_CAMPAIGN******************/


DROP PROCEDURE IF EXISTS sp_finish_campaign
//

CREATE PROCEDURE sp_finish_campaign (IN c_title VARCHAR(30))

-- code
-- DECLARE CONTINUE HANDLER FOR NOT FOUND; */
BEGIN
    -- do the error handling
    DECLARE cost INTEGER;
    DECLARE finished INTEGER;
    DECLARE camp_id INTEGER;
    DECLARE result_count INTEGER;
    DECLARE error_string varchar(255) DEFAULT "N";
    DECLARE cs CURSOR FOR SELECT COUNT(CAMPAIGN_NO) FROM campaign WHERE TITLE=c_title;
    DECLARE mycursor CURSOR FOR SELECT CAMPAIGN_NO FROM campaign WHERE TITLE=c_title;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished=1;
    OPEN cs;
    FETCH cs INTO result_count;
    CLOSE cs;
    OPEN mycursor;
    read_loop: LOOP
        IF result_count=0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT="ERROR! Campaign title does not exist";
            LEAVE read_loop;
        END IF;
        IF finished=1 THEN
            LEAVE read_loop;
        END IF;
        FETCH mycursor INTO camp_id;
    END LOOP ;
    SET cost=cost_of_campaign(camp_id);
    UPDATE campaign SET CAMPAIGNFINISHDATE=CURRENT_DATE , ACTUALCOST=cost WHERE TITLE=c_title;
    CLOSE mycursor;
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


