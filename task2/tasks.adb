with Ada.Real_Time; use Ada.Real_Time;
with System;
with NXT.AVR;		        use NXT.AVR;
with Nxt.Display;               use Nxt.Display;
with ADA.Real_time;		use ADA.Real_time;
with NXT.Audio;
with NXT.Light_Sensors;		use NXT.Light_Sensors;
with NXT.Light_Sensors.Ctors;	use NXT.Light_Sensors.Ctors;
with NXT.Touch_Sensors; use NXT.Touch_Sensors;
with Events; use Events;
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
   task MotorControlTask is
      -- define its priority higher than the main procedure --
      pragma Priority (System.Priority'First + 3);
      pragma Storage_Size (4096); --  task memory allocation --
   end MotorControlTask;

   task body MotorControlTask is
      Next_Time : Time := Clock;
      Period : Time_Span := milliseconds(100);
      
   begin      
      -- task body starts here ---
      --init part
      --NXT.AVR.Await_Data_Available;
      --Put_Line ("Ready");
      loop

	 --Clear_Screen_Noupdate;
	 put_noupdate("Waiting...");
	 Newline;
	 Event.Wait(TouchOnEvent);
	 --Clear_Screen_Noupdate;
	 Control_Motor (Left_Motor_Id, Speed_Half, Forward);
	 Control_Motor (Right_Motor_Id, Speed_Half, Forward);

	 Event.Wait(LightBelowEvent);

	 Control_Motor (Left_Motor_Id, Speed_Stop, Brake);
	 Control_Motor (Right_Motor_Id, Speed_Stop, Brake);
	 Event.Wait(LightAboveEvent);

	 Event.Wait(TouchOffEvent);
	 --Control_Motor (Left_Motor_Id, Speed_Stop, Brake);
	 --Control_Motor (Right_Motor_Id, Speed_Stop, Brake);
	 
	 --put_noupdate("No Touch!");
	 NewLine;

	 Newline;
	 Next_Time := Next_Time + Period;
	 delay until Next_Time;
      end loop;
   end MotorControlTask;
   
   task EventDispatcherTask is 
      pragma Priority (System.Priority'First + 2);
      pragma Storage_Size (4096); --  task memory allocation --
   end EventDispatcherTask;


   task body EventDispatcherTask is
      Next_Time : Time := Clock;
      Period : Time_Span := milliseconds(100);
      Bumper : Touch_Sensor (Sensor_1);
      LS : Light_Sensor := make(Sensor_3, True);
      
      Last_Bumper_State: Boolean := False;
      Last_Light_Value: Integer := 0;
      Threshold: Integer := 30;
      
      procedure Check_Bumper is
      begin
      	 if Pressed (Bumper) then
      	    NXT.Audio.Play_Tone
      	      (Frequency => 800,
      	       Interval  => 10,
      	       Volume    => 50);
      	 end if;
	 
      	 if (Pressed(Bumper) /= Last_Bumper_State) then
            if Pressed(Bumper) then
      	       put_noupdate("Button pressed.");
      	       Newline;
      	       Event.Signal(TouchOnEvent);
            else
      	       put_noupdate("Button not pressed.");
      	       Newline;
      	       Event.Signal(TouchOffEvent);
            end if;
            Last_Bumper_State := Pressed(Bumper);
      	 end if;
      end Check_Bumper;
      
      procedure Check_Light_Sensor is
      begin
	 if LS.Light_Value < Threshold then
	    NXT.Audio.Play_Tone
	      (Frequency => 900,
	       Interval  => 10,
	       Volume    => 70);
	 end if;
	 
	 if (LS.Light_Value /= Last_Light_Value) then
            if LS.Light_Value < Threshold then
	       put_noupdate("Over the edge!");
	       Newline;
	       Event.Signal(LightBelowEvent);
            --else
	    --   put_noupdate("Light levels OK.");
	    --   Newline;
	    --   Event.Signal(LightAboveEvent);
            end if;
            Last_Light_Value := LS.Light_Value;
	 end if;

      end Check_Light_Sensor;
      
   begin
      NXT.AVR.Await_Data_Available;
      Put_Line ("EventDispatcherTask ready");
      
      loop
	 
	 Check_Light_Sensor;
	 

  
	 Check_Bumper;
	
	 
	 Next_Time := Next_Time + Period;
	 delay until Next_Time;
      end loop;

   end EventDispatcherTask;
   
end Tasks;
