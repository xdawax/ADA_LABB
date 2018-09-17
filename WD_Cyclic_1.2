with Ada.Calendar;
with Ada.Text_IO;
use Ada.Calendar;
use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

procedure wdcyclic is
    Message: constant String := "Cyclic scheduler";
    d: Duration := 1.0;
    F1_Next : Time := Clock;
    F3_Period : Time := Clock + d;
    F3_Next : Time := F3_Period + 0.5 ;
    Start_Time: Time := Clock;
   package Random_Execution_Time is new Ada.Numerics.Discrete_Random(Boolean);
   use Random_Execution_Time;
   G : Generator;
   Reset_F1: Duration := 0.0 ;
  
         -- change/add your declarations here
    
	procedure f1 is 
		Message: constant String := "F1 executing, time is now";
	begin
		Put(Message);
		Put_Line(Duration'Image(Clock - Start_Time));
	end f1;
        
	
	
        procedure f2 is 
		Message: constant String := "F2 executing, time is now";
	begin
		Put(Message);
		Put_Line(Duration'Image(Clock - Start_Time));
	end f2;
        
	
	
	
	procedure f3 is 
		Message: constant String := "F3 executing,time is now";
	begin
		PuT(Message);		
                Put_Line(Duration'Image(Clock - Start_Time));
        end f3;    
               
   	Task Watchdog is        
	  entry Start;
	  entry Stop;
         end Watchdog;
		
		
	task body Watchdog is     
             WD_Status : Boolean := False;   --Status of WatchDog
         begin
                loop
                    select
                          accept Start do 
                   		 Put_Line("Rawr! WatchDog is screening!");  --WD is running
                   		 WD_Status := True;
                  	  end Start;
		    or
		   	 accept Stop do
                    		Put_Line("..zzZZZzz..");     --WD is stopped
                    		WD_Status := False;
   	                  end Stop;
 	            or
                          delay 0.5;
		    		if WD_Status = True then   --If WD/F3 is running for more than 0.5 seconds from its start
                                     Put_Line("WatchDog says F3 has wandered away! ");
                                end if;
                    end select;
                end loop;
          end Watchdog;
                   
  
	
begin
        loop
            -- change/add your code inside this loop
             delay until F1_Next;   
             f1;f2;
             F1_Next := Clock + d;     --Calculate the starting time for next instance of F1
             if F3_Next < F1_Next then  --Check if F1 has finished twice before the start of F3
                delay until F3_Next;     --Delay until the start of F3 
                Watchdog.Start;          --Call WD to start
                 Reset(G);
		if Random(G) then      -- Loop to randomize the execution time of F3 by 0.6 seconds
		     delay until Clock + 0.6;  
                     Reset_F1 := Duration(Float'Ceiling(Float(Clock - Start_Time))); --Reset F1 to the next whole second after F3 runs
                     F1_Next := Start_Time + Reset_F1; 
		end if;
                f3;
                Watchdog.Stop;
                F3_Next := F1_Next + 1.5;  --Calculate the starting time for next instance of F1
              end if;        
        end loop;
end wdcyclic;
