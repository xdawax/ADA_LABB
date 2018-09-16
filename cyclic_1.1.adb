with Ada.Calendar;
with Ada.Text_IO;
use Ada.Calendar;
use Ada.Text_IO;

procedure cyclic is
    Message: constant String := "Cyclic scheduler";
    d: Duration := 1.0;
    F1_Next : Time := Clock;    --Start of F1
    F3_Period : Time := Clock + d; --Instance to start F3
    F3_Next : Time := F3_Period + 0.5 ; --Start of F3 
    Start_Time: Time := Clock;
        -- change/add your declarations here
    
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
                delay until F1_Next;   --Time the execution of F1
                f1;f2;
                F1_Next := Clock + d;   --The next execution time of F1
              if F3_Next < F1_Next then --Check for F3's instance
                delay until F3_Next;      --Time the execution of F3
                f3;
                F3_Next := F1_Next + 1.5;  --The next execution time of F3
              end if;        
        end loop;
end cyclic;
