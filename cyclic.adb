with Ada.Calendar;
with Ada.Text_IO;
use Ada.Calendar;
use Ada.Text_IO;

procedure cyclic is
    Message: constant String := "Cyclic scheduler";
        -- change/add your declarations here
    Period_F1: Duration := 1.0; 			-- Period of procedure f1
    Period_F3: Duration := 2.0; 			-- Period of procedure f3
    Offset_F3: Duration := 0.5; 			-- The Phase of f3 relative f1

	Start_Time: Time := Clock; 				-- Clock at start time
	Next_F1 : Time := Clock; 				-- The time to start procedure f1
	Next_F3 : Time := Clock + Offset_F3; 	-- The time to start procedure f3 (f1 + offset)

	procedure f1 is 
		Message: constant String := "f1 executing, time is now";
	begin
		Put(Message);
		Put_Line(Duration'Image(Clock - Start_Time));
	end f1;

	procedure f2 is 
		Message: constant String := "f2 executing, time is now";
	begin
		Put(Message);
		Put_Line(Duration'Image(Clock - Start_Time));
	end f2;

	procedure f3 is 
		Message: constant String := "f3 executing, time is now";
	begin
		Put(Message);
		Put_Line(Duration'Image(Clock - Start_Time));
	end f3;

	begin
        loop
            -- change/add your code inside this loop  
            delay until Next_F1;					-- Delay until start of next period for f3
                f1;									-- Run procedure f1
                f2;									-- Run procedure f2
                Next_F1 := Next_F1 + Period_F1;		-- Set the time of the next period start for f1
            if Next_F3 < Next_F1 then				-- Check if the next period belongs to f3
	            delay until Next_F3;				-- Delay until start of next period for f3
    	            f3;								-- Run f3
        	        Next_F3 := Next_F3 + Period_F3;	-- Set the time of the next period start for f3
        	end if;
        end loop;									-- Run for N iterations
end cyclic;


--    Explain the difference between relative delay and absolute delay using your own understanding.
--    Suppose we know the exact execution times of F1, F2 and F3. Is it possible to use relative delay for avoiding drift? Why?
