with Ada.Calendar;
with Ada.Text_IO;
use Ada.Calendar;
use Ada.Text_IO;

procedure cyclic is
    Message: constant String := "Cyclic scheduler";
    -- change/add your declarations here
    d: Duration := 1.0;
	Start_Time: Time := Clock;
	f3_delay : Duration := 0.5;
	flip: Boolean := false;

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
			f1;
			f2;
			if (flip) then
				delay until Clock + f3_delay;
					f3;
			end if;
			flip := not flip;
			Put_Line("----");	
            delay d;
        end loop;
end cyclic;

