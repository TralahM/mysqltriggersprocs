/********************************************************** 
****** Stored Programs for Assn.2, 2019 *******************
********** Student Nama and Number ************************
******************* Date **********************************
** I declare that the code provided below is my own work **
******* Any help received is duely acknowledged here ******
**********************************************************/

/********* Trigger TR_OVERDUE ************/

delimiter //
drop trigger if exists tr_overdue
//

create trigger tr_overdue 
-- type of trigger, etc    

    begin

-- implementation goes here 
    
    end
//

/************* Helper Functions/Procedures used, two functions for example ****************/

-- drop function if exists rate_on_date //

-- create function rate_on_date(staff_id int, given_date DATE) returns float
-- retuens the hourly salary rate of a given staff (staff_id) on any particular date (given_date)

-- READS SQL DATA
-- DETERMINISTIC
-- begin

-- code
-- return hour_rate;

-- end
-- //
--
--
--
-- drop function if exists cost_of_campaign ;

-- //

-- create function cost_of_campaign (camp_id int) returns float
-- retuens the total cost incurred due to any given campaigh (camp_id) 
-- READS SQL DATA
-- DETERMINISTIC
-- begin

-- code
-- employ function  rate_on_date if necessary
-- return total_cost;

-- end//

/************ Procedure SP_FINISH_CAMPAIGN******************/


drop procedure if exists sp_finish_campaign //

create procedure sp_finish_campaign (in c_title varchar(30))

begin

-- code
-- do the error handling
-- employ helper functions and procedures if necessary (advisable to make the code modular and understandable
-- For instance, somewhere in the code ...
-- 
-- set 
-- t_cost = cost_of_campaign(camp_id); 
--
--
end//

/************ Procedure SYNC_INVOICE******************/

drop procedure if exists sync_invoice;
//
CREATE procedure sync_invoice()
begin

-- code

end
//


delimiter ;


