with Ada.Real_Time; use Ada.Real_Time;
with System;
with NXT.AVR;		        use NXT.AVR;
with Nxt.Display;               use Nxt.Display;
with ADA.Real_time;		use ADA.Real_time;
with NXT.Audio;
with NXT.Light_Sensors;		use NXT.Light_Sensors;
with NXT.Light_Sensors.Ctors;	use NXT.Light_Sensors.Ctors;
with NXT.Touch_Sensors; use NXT.Touch_Sensors;
-- with Events; use Events;
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

  -----------
  -- Tasks --
  -----------

  -- task MotorcontrolTask is
  --   pragma Priority (System.Priority'First + 4);
  --   pragma Storage_Size (2048); --  task memory allocation --
  --   entry SetSpeed(Speed: in Integer);
  -- end MotorcontrolTask;

  task ButtonpressTask is
    pragma Priority (System.Priority'First + 3);
    pragma Storage_Size (2048); --  task memory allocation --
  end ButtonpressTask;

  task DisplayTask is
    pragma Priority (System.Priority'First + 2);  
    pragma Storage_Size (2048); --  task memory allocation --
    -- entry DisplayOnScreen(message: in String);
  end DisplayTask;



  task body ButtonpressTask is
    Next_Time : Time := Clock;
    Period : Time_Span := milliseconds(100);
    Bumper: Touch_Sensor (Sensor_1);

    begin
    put_noupdate("Running..");
    NewLine;
  end ButtonpressTask; 

  task body DisplayTask is
    
  begin 
    -- accept DisplayOnScreen(message: in String) do
    --   put_noupdate("Running..");
    --   NewLine;
    -- end DisplayOnScreen;
    null;
  end DisplayTask;


end Tasks;
