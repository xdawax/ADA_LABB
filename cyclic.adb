with Ada.Calendar;
with Ada.Text_IO;
use Ada.Calendar;
use Ada.Text_IO;

procedure cyclic is
    Message: constant String := "Cyclic scheduler";
        -- change/add your declarations here
    Period_F1: Duration := 1.0;
    Period_F3: Duration := 2.0;
    Offset_F3: Duration := 0.5;

	Start_Time: Time := Clock;
	Next_F1 : Time := Clock;
	Next_F3 : Time := Clock + Offset_F3;
	s: Integer := 0;
        

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
            delay until Next_F1;
                f1;
                f2;
                Next_F1 := Next_F1 + Period_F1;
            if Next_F3 < Next_F1 then
	            delay until Next_F3;
    	            f3;
        	        Next_F3 := Next_F3 + Period_F3;
        	end if;
        end loop;
end cyclic;

