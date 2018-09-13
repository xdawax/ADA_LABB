with Ada.Calendar;
with Ada.Text_IO;
with Ada.Numerics.Float_Random;

use Ada.Calendar;
use Ada.Text_IO;
use Ada.Numerics.Float_Random;

procedure cyclic_wd is
    	Message: constant String := "Cyclic scheduler";
        -- change/add your declarations here
	Period_F1: Duration := 1.0; 			-- Period of procedure f1
	Period_F3: Duration := 2.0; 			-- Period of procedure f3
	Offset_F3: Duration := 0.5; 			-- The Phase of f3 relative f1
	Delay_Time: Duration := 0.5;			-- How long to delay f3   

	Start_Time: Time := Clock; 				-- Clock at start time
	Next_F1 : Time := Clock; 				-- The time to start procedure f1
	Next_F3 : Time := Clock + Offset_F3; 	-- The time to start procedure f3 (f1 + offset)

	Seed : Generator;						-- Create a seed for randomizer
	Prob : Float := 0.3;					-- Set probobility of delay in f3 range (0,1)

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



	task Watchdog is
	       Entry Put(Start_T : in Time); -- add your task entries for communication 	
	end Watchdog;	

	task body Watchdog is
		begin
		loop
            Accept Put(Start_T : in Time) do
            	Put_Line("Accepted in WD");
            end Put;    
		end loop;
	end Watchdog;

	procedure f3 is 
		Message: constant String := "f3 executing, time is now";
	begin
		Put(Message);
		Put_Line(Duration'Image(Clock - Start_Time));

		Reset(Seed);

		if Random(Seed) < Prob then					-- Delay of Delay_Time with probability Prob			
			delay Delay_Time;				
			Put_Line("Delayed in f3");				--
		end if;

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
	            	Watchdog.Put(Next_F3);
    	            	f3;								-- Run f3
        	        Next_F3 := Next_F3 + Period_F3;	-- Set the time of the next period start for f3
        	end if;
        end loop;									-- Run for N iterations
end cyclic_wd;


--    How did you synchronize the watchdog task with the start and the end of a F3 execution?
--    Does it make sense to use absolute delay in watchdog timeouts? Why/why not?
--    Explain the way you re-synchronize the cyclic executive when F3 misses its deadline.
