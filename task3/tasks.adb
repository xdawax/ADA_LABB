with Ada.Real_Time; use Ada.Real_Time;
with System;
with NXT.AVR;		        use NXT.AVR;
with Nxt.Display;               use Nxt.Display;
with ADA.Real_time;		use ADA.Real_time;
with NXT.Audio;
with NXT.Light_Sensors;		use NXT.Light_Sensors;
with NXT.Light_Sensors.Ctors;	use NXT.Light_Sensors.Ctors;
with NXT.Ultrasonic_Sensors;    use NXT.Ultrasonic_Sensors;
with NXT.Ultrasonic_Sensors.Ctors; use NXT.Ultrasonic_Sensors.Ctors;
with NXT.Touch_Sensors; use NXT.Touch_Sensors;
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
   
   type Driving_Command is
      record
	 Duration: Time_Span;
	 Speed: Integer;
	 Update_Priority: Integer;
      end record;
   
   protected Driving_Command_Manager is
      procedure Change_Driving_Command(Update_Duration: in Time_Span; 
				       Update_Speed: in Integer; 
				       Update_Priority: in Integer);
      function Get_Driving_Command return Driving_Command;
   private
      Command: Driving_Command := (Milliseconds(0), 0, PRIO_IDLE);
   end Driving_Command_Manager;
   
   protected body Driving_Command_Manager is
      procedure Change_Driving_Command(Update_Duration: in Time_Span; 
				       Update_Speed: in Integer; 
				       Update_Priority: in Integer) is
      begin
	 Command := (Update_Duration, Update_Speed, Update_Priority);
      end Change_Driving_Command;
      
      function Get_Driving_Command return Driving_Command is
      begin
	 return Command;
      end Get_Driving_Command;
   end Driving_Command_Manager;

   -------------
   --  Tasks  --
   -------------   
   task MotorControlTask is
      -- define its priority higher than the main procedure --
      pragma Priority (System.Priority'First + 4);
      pragma Storage_Size (2048); --  task memory allocation --
   end MotorControlTask;
   
   task ButtonControlTask is
      pragma Priority (System.Priority'First + 3);
      pragma Storage_Size (2048); --  task memory allocation --
   end ButtonControlTask;
   
   task DisplayTask is 
      pragma Priority (System.Priority'First + 2);
      pragma Storage_Size (2048); --  task memory allocation --
   end DisplayTask;
   
   task ShutdownTask is 
      pragma Priority (System.Priority'First + 10);
      pragma Storage_Size (1024); --  task memory allocation --
   end ShutdownTask;
   
   task DistanceTask is 
      pragma Priority (System.Priority'First + 5);
      pragma Storage_Size (1024); --  task memory allocation --
   end DistanceTask;
   
   
   procedure Command_Motors(Speed: Integer) is 
      Current_Speed: Integer;
   begin
      Current_Speed := Speed;
      if (Current_Speed > Integer(Power_Percentage'Last)) then
	 Current_Speed := Integer(Power_Percentage'Last);
      end if;
      
      if (Current_Speed > 0) then
	 Control_Motor (Left_Motor_Id, Power_Percentage(Current_Speed), Forward);
	 Control_Motor (Right_Motor_Id, Power_Percentage(Current_Speed), Forward);
	 --Control_Motor (Drive_Motor_Id, Power_Percentage(Current_Speed), Forward);
      elsif (Current_Speed < 0) then
	 --Control_Motor (Left_Motor_Id, Power_Percentage(Current_Speed*(-1)), Backward);
	 Control_Motor (Drive_Motor_Id, Power_Percentage(Current_Speed*(-1)), Backward);
      else 
	 Control_Motor (Left_Motor_Id, Power_Percentage(0), Brake);
	 Control_Motor (Right_Motor_Id, Power_Percentage(0), Brake);
	 --Control_Motor (Drive_Motor_Id, Power_Percentage(Current_Speed), Brake);
      end if;
      
   end Command_Motors;
   
   
   task body DistanceTask is
      Next_Time : Time := Clock;
      Period : Time_Span := milliseconds(100);
      Sonic_Sensor: Ultrasonic_Sensor := Make(Sensor_3);
      Reading: Natural;
      Command: Driving_Command;
   begin
      loop
	 Ping(Sonic_Sensor);
	 Get_Distance(Sonic_Sensor, Reading);
         Put_Noupdate(Reading);
	 NewLine_Noupdate;
	 Command := Driving_Command_Manager.Get_Driving_Command;
	 if (Reading < 20 and (Command.Update_Priority < PRIO_DIST)) then --Check that our priority is higher than the current update priority
	    Driving_Command_Manager.Change_Driving_Command(Milliseconds(1000), -50, PRIO_DIST);
	 else
	    Driving_Command_Manager.Change_Driving_Command(Milliseconds(1000), Integer(Reading/2), PRIO_DIST);
	 end if;
      	 Next_Time := Next_Time + Period;
   	 delay until Next_Time;  
      end loop;
   end DistanceTask;
   
   task body ShutdownTask is 
      Next_Time : Time := Clock;
      Period : Time_Span := milliseconds(500);
   begin
      loop
	 
	 if NXT.AVR.Button = Power_Button then
	    NXT.AVR.Power_Down;
	 end if;
	 Next_Time := Next_Time + Period;
	 delay until Next_Time;
      end loop;
   end ShutdownTask;
   
 

   task body MotorControlTask is
      Next_Time : Time := Clock;
      Period : Time_Span := milliseconds(50);
      Command: Driving_Command;
      Speed: Integer := 0;
      Duration: Time_Span := Milliseconds(0);
      Started: Boolean := False;
   begin      
      loop
	 
	 if (not Started) then
	    Command := Driving_Command_Manager.Get_Driving_Command;
	    if ((Command.Update_Priority > PRIO_IDLE) and (Command.Duration > Milliseconds(0))) then
	       Started := True;
	       Duration := Command.Duration;
	       Put_Noupdate("Starting motors...");
	       NewLine_Noupdate;
	       Command_Motors(Command.Speed);
	    end if;
	 else
	    if (Duration < Milliseconds(0)) then
	       Put_Noupdate("Duration expired");
	       NewLine_Noupdate;
	       Started := False;
	       Command_Motors(0);
	       Driving_Command_Manager.Change_Driving_Command(Milliseconds(0), 0, PRIO_IDLE);
	       Duration := Milliseconds(10);
	    else
	       Duration := Duration - Period;
	    end if;
	    
	 end if;	 
	 
   	 Next_Time := Next_Time + Period;
   	 delay until Next_Time;
      end loop;
   end MotorControlTask;
   
   
   
   task body ButtonControlTask is
      Next_Time: Time := Clock;
      Period: Time_Span := milliseconds(10);
      Bumper: Touch_Sensor (Sensor_2);
      Command: Driving_Command;
   begin
      Put_Line("ButtonControlTask ready");
      loop
	 
   	 if Pressed(Bumper) then
	    NXT.Audio.Play_Tone
      	      (Frequency => 800,
      	       Interval  => 10,
      	       Volume    => 20);
	    
	    Put_Noupdate("Pressed!");
	    NewLine_Noupdate;
	    
	    Command := Driving_Command_Manager.Get_Driving_Command;
   	    if (Command.Update_Priority < PRIO_BUTTON) then
   	       Put_Noupdate("Sent command");
	       NewLine_Noupdate;
   	       Driving_Command_Manager.Change_Driving_Command(Milliseconds(1000), 50, PRIO_BUTTON);
	    end if;
	 end if;
	 
   	 Next_Time := Next_Time + Period;
   	 delay until Next_Time;
      end loop;
   end ButtonControlTask;
   
   
   
   task body DisplayTask is 
      Next_Time : Time := Clock;
      Period : Time_Span := milliseconds(100);
      
   begin
      NXT.AVR.Await_Data_Available;
      Put_Line("DisplayTask ready");

      loop
	 Screen_Update;
	 Next_Time := Next_Time + Period;
	 delay until Next_Time;
      end loop;
      
   end DisplayTask;
   
end Tasks;
