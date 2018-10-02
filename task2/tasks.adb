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
      Event_ID: Integer := -1;
      Edge_Reset: Boolean := False;
      
   begin      
      loop

	 --Clear_Screen_Noupdate;
	 put_noupdate("Waiting...");
	 Newline_noupdate;
	 
	 Event.Wait(Event_ID);
	 
   -- Check which event was received and react accordingly.
	 if ((Event_ID = TouchOnEvent) and (!Edge_Reset)) then
	     put_noupdate("TouchOnEvent");
	    Control_Motor (Left_Motor_Id, Speed_Half, Forward);
	    Control_Motor (Right_Motor_Id, Speed_Half, Forward);
	 elsif (Event_ID = TouchOffEvent) then
	     put_noupdate("TouchOffEvent");
	    Control_Motor (Left_Motor_Id, Speed_Stop, Brake);
	    Control_Motor (Right_Motor_Id, Speed_Stop, Brake);
	 elsif (Event_ID = LightBelowEvent) then
	    Edge_Reset := True;
	    Control_Motor (Left_Motor_Id, Speed_Stop, Brake);
	    Control_Motor (Right_Motor_Id, Speed_Stop, Brake);
	 elsif (Event_ID = LightOnEvent) then
	    Edge_Reset := False;
	 end if;
	
	 Next_Time := Next_Time + Period;
	 delay until Next_Time;
      end loop;
   end MotorControlTask;
   
   task EventDispatcherTask is 
      pragma Priority (System.Priority'First + 2);
      pragma Storage_Size (4096); --  task memory allocation --
   end EventDispatcherTask;


   -- Task to read sensor input and dispatch events
   task body EventDispatcherTask is
      Next_Time : Time := Clock;
      Period : Time_Span := milliseconds(100);
      Bumper : Touch_Sensor (Sensor_1);
      LS : Light_Sensor := make(Sensor_3, True);
      
      Last_Bumper_State: Boolean := False;
      Last_Light_Value: Integer := LS.Light_Value;
      Threshold: Integer := 30;
      
      -- Utility function for checking bumper input
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

       -- Utility function for checking light sensor input
      procedure Check_Light_Sensor is
	 Difference: Integer := 0;
   Offset: Integer := 5; --Since signal is fairly noisy, use a threshold to check changed
      begin
	 if LS.Light_Value < Threshold then --Alarm for signaling we are at edge of table
	    NXT.Audio.Play_Tone
	      (Frequency => 900,
	       Interval  => 10,
	       Volume    => 70);
	 end if;
	 
	 Difference := Last_Light_Value - LS.Light_Value;
	 
	 if (Difference < 0) then
	    Difference := Difference * (-1);
	 end if;
	 
	 if (Difference > Offset) then
            if LS.Light_Value < Threshold then
	       put_noupdate("Over the edge!");
	       Newline;
	       Event.Signal(LightBelowEvent);
            else
	       put_noupdate("Light levels OK."); --Back on the table
	       Newline;
	       Event.Signal(LightAboveEvent);
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
