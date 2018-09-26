--Cyclic scheduler with a watchdog: 

with Ada.Calendar;
with Ada.Text_IO;

use Ada.Calendar;
use Ada.Text_IO;

with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;

-- add packages to use randam number generator

procedure cyclic_wd is
   Message: constant String := "Cyclic scheduler with watchdog";
   Period_f1: Duration := 1.0;
   Period_f3: Duration := 2.0;
   Offset_f3: Duration := 0.5;
   G: Generator;
   random_delay: Duration;
   Resync: Boolean := false;
   Sync_Offset : Duration;
   Start_Time: Time := Clock;
   Next_f1: Time := Clock;
   Next_f3: Time := Clock + Offset_f3;

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
      entry Get;
      entry Release;
   end Watchdog;

   task body Watchdog is
   begin
      loop
	 accept Get do
	    Put_Line("WD: Got Watchdog!");
	 end Get;
	 select 
	    accept Release do -- This will execute if f3 does not overshoot its deadline
	       Put_Line("WD: Released Watchdog!");
	    end Release;
	 or
	    delay 0.5; -- Otherwise this will run
	    Put_Line("WD: f3 has broken its deadline!");
	    Resync := true; -- Prepare to resynchronize
	    accept Release do 
	       Put_Line("WD: Released Watchdog!");
	    end Release;
	 end select;
      end loop;
   end Watchdog;

   procedure f3 is 
      Message: constant String := "f3 executed, time is now";
      Delay_Message: constant String := ". Execution time was";
   begin
      random_delay := Duration(Random(G));
      delay random_delay;
      Put(Message);
      Put(Duration'Image(Clock - Start_Time));
      Put(Delay_Message);
      Put_Line((Duration'Image(random_delay)));
   end f3;

begin
   Reset(G);	
   loop
      delay until Next_f1;
      f1;
      f2;
      Next_f1 := Next_f1 + Period_f1; -- Set next time f1 will fire
      if Next_f3 < Next_f1 then 
	 delay until Next_f3;
	 Watchdog.Get;
	 f3;
	 Watchdog.Release;
	 if (Resync) then -- Will run if f3 overshot deadline
	    Sync_Offset := Duration(Integer(Clock - Start_Time) + 1); -- Get the next whole second
	    next_f1 := Start_Time + Sync_Offset; -- Set the next time f1 will fire to the next whole second
	    Next_f3 := Next_f1 + Period_f3 + Offset_f3; -- Set f3 to fire one period after the next instance of f1
	    Resync := false;
	 else 
	    Next_f3 := Next_f3 + Period_f3;
	 end if;
      end if;
      Put_Line("---");
   end loop;
end cyclic_wd;

