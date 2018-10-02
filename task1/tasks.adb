with Ada.Real_Time; use Ada.Real_Time;
with System;
with NXT.AVR;		        use NXT.AVR;
with Nxt.Display;               use Nxt.Display;
with ADA.Real_time;		use ADA.Real_time;
with NXT.Light_Sensors;		use NXT.Light_Sensors;
with NXT.Light_Sensors.Ctors;	use NXT.Light_Sensors.Ctors;
package body Tasks is

   ----------------------------
   --  Background procedure  --
   ----------------------------
   procedure Background is
   begin
      loop
         null;
      end loop;
   end Background;

   -------------
   --  Tasks  --
   -------------   
   task HelloworldTask is
      -- define its priority higher than the main procedure --
      pragma Storage_Size (4096); --  task memory allocation --
   end HelloworldTask;

   task body HelloworldTask is
      Next_Time : Time := Clock;
      Period : Time_Span := milliseconds(100);
      LS : Light_Sensor := make(Sensor_3, True);
      
   begin      
      -- task body starts here ---
      --init part
      loop
      put_noupdate("Hello World!"); 
	  put_noupdate("Light level is: ");
	  put_noupdate(LS.Light_Value);
	  Newline;
	 
	 -- read light sensors and print ----

	 if NXT.AVR.Button = Power_Button then
	    Power_Down;
	 end if;
	 Next_Time := Next_Time + Period;
	 delay until Next_Time;
      end loop;
   end HelloworldTask;
   
end Tasks;
