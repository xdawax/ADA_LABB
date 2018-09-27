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
with NXT.Motor_Encoders; use NXT.Motor_Encoders;
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
	 Drive_Speed: Integer;
	 Turn_Speed: Integer;
	 Update_Priority: Integer;
      end record;
   
   type Controller is
      record
	 Reference: Integer;
	 Kp: Integer;
	 Ki: Integer;
	 Kd: Integer;
	 Last_Error: Integer;
	 Integral: Integer;
      end record;
   
   protected Driving_Command_Manager is
      procedure Change_Driving_Command(Update_Duration: in Time_Span; 
				       Update_Drive_Speed: in Integer; 
				       Update_Turn_Speed: in Integer; 
				       Update_Priority: in Integer);
      function Get_Driving_Command return Driving_Command;
   private
      Command: Driving_Command := (Milliseconds(0), 0, 0, PRIO_IDLE);

   end Driving_Command_Manager;
   
   protected body Driving_Command_Manager is
      procedure Change_Driving_Command(Update_Duration: in Time_Span; 
				       Update_Drive_Speed: in Integer; 
				       Update_Turn_Speed: in Integer; 
				       Update_Priority: in Integer) is
      begin
	 Command := (Update_Duration, Update_Drive_Speed, Update_Turn_Speed, Update_Priority);
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
   
   task LightTask is
      pragma Priority (System.Priority'First + 7);
      pragma Storage_Size (1024); --  task memory allocation --
   end LightTask;
   
   task StartupTask is
      pragma Priority (System.Priority'First + 20);
      pragma Storage_Size (1024); --  task memory allocation --
   end StartupTask;
   
   --  function abs(Value: Integer) is
   --  begin
   --     if (Value > 0) then
   --  	 return Value;
   --     elsif (Value < 0) then
   --  	 return Value  * (-1);
   --     else 
   --  	 return 0;
   --     end if;
   --  end abs;
   
   procedure Command_Motors(Speed: Integer; Motor: Motor_Id) is 
  Current_Speed: Integer;
  Limit: Integer := 70;
  begin
     Current_Speed := Speed;
     
     if (abs(Current_Speed) > Limit) then
	if (Current_Speed > Limit) then 
	   Current_Speed := Limit;
	elsif (Current_Speed < -Limit) then
	   Current_Speed := -Limit;
	end if;
     end if;
	
     if (Current_Speed > 0) then
	Control_Motor (Motor, Power_Percentage(Current_Speed), Forward);
     elsif (Current_Speed < 0) then
	Control_Motor (Motor, Power_Percentage(Current_Speed*(-1)), Backward);
     else 
	Control_Motor (Motor, Power_Percentage(Current_Speed), Brake);
     end if;
     
  end Command_Motors;
  
  procedure Calc_Control(Input: in Integer; 
			 Output: out Integer;
			 Fy: in out Controller) is
      Error: Integer;
      Derivative: Integer;
   begin
      Error := Input - Fy.Reference;
      Fy.Last_Error := Error;
      Fy.Integral := Fy.Integral + Error;
      Derivative := Error - Fy.Last_Error;
      Output := Fy.Kp * Error + Fy.Ki * Fy.Integral + Fy.Kd * Derivative;
   end Calc_Control;
   
   task body StartupTask is
      Cal_Black: Integer;
      Cal_White: Integer;
      Ls: Light_Sensor := Make(Sensor_1);
   begin
      
      Put_Noupdate("Place on white and press middle button");
      Put_Noupdate(Ls.Light_Value);
      NewLine_Noupdate;
      loop
         exit when NXT.AVR.Button = Middle_Button;
         delay until Clock + Milliseconds (10);
      end loop;
      Cal_White := Ls.Light_Value;
      
      Put_Noupdate("Place on black and press middle button");
      Put_Noupdate(Ls.Light_Value);
      NewLine_Noupdate;
      loop
         exit when NXT.AVR.Button = Middle_Button;
         delay until Clock + Milliseconds (10);
      end loop;
      
      Cal_Black := Ls.Light_Value;
     
   end StartupTask;
   
   task body LightTask is
      Next_Time : Time := Clock;
      Period : Time_Span := milliseconds(100);
      Ls: Light_Sensor := Make(Sensor_1);
      White_Edge: Integer := 50;
      Black_Edge: Integer := 30;
      Reference: Integer := (White_Edge + Black_Edge)/2;
      Light_Controller: Controller := (Reference, 2, 0, 1, 0, 0);
      Control_Signal: Integer;
      Reading: Integer;
      Command: Driving_Command;
   begin
      loop
	 Reading := Ls.Light_Value;
	 --  Put_Noupdate("Light Value is: ");
	 --  Put_Noupdate(Reading);
	 --  NewLine_Noupdate;
	 --  Put_Noupdate("Reference is: ");
	 --  Put_Noupdate(Light_Controller.Reference);
	 --  NewLine_Noupdate;
	 
	 if NXT.AVR.Button = Right_Button then 
	    White_Edge := Ls.Light_Value; 
	    Light_Controller.Reference := (White_Edge + Black_Edge)/2; 
	 elsif NXT.AVR.Button = Left_Button then
	    Black_Edge := Ls.Light_Value;
	    Light_Controller.Reference := (White_Edge + Black_Edge)/2; 
	 end if;
	 
	 Calc_Control(Reading, Control_Signal, Light_Controller);
	 
	 Put_Noupdate("LightControl: ");
	 Put_Noupdate(Control_Signal);
	 NewLine_Noupdate;
	 
	 Command := Driving_Command_Manager.Get_Driving_Command;
	 if (Command.Update_Priority <= PRIO_DIST) then
	    Driving_Command_Manager.Change_Driving_Command(Milliseconds(1000), 20, (Control_Signal), PRIO_DIST);
	    null;
	 end if;	 
	 
	 Next_Time := Next_Time + Period;
	 delay until Next_Time;  
      end loop;
   end LightTask;
   
   
   task body DistanceTask is
      Next_Time : Time := Clock;
      Period : Time_Span := milliseconds(100);
      Sonic_Sensor: Ultrasonic_Sensor := Make(Sensor_3);
      Reading: Natural;
      Command: Driving_Command;
      Reference: Integer := 20;
      Base_Speed: Integer := 20;
      Distance_Controller: Controller := (Reference, 5, 0, 1, 0, 0);
      Control_Signal: Integer;
   begin
      loop
	 Ping(Sonic_Sensor);
	 Get_Distance(Sonic_Sensor, Reading);
	 
	 Calc_Control(Reading, Control_Signal, Distance_Controller);
	 
	 --Put_Noupdate("Sonic Reading: ");
	 --Put_Noupdate(Reading);
	 --NewLine_Noupdate;
	 --Put_Noupdate("Control: ");
	 --Put_Noupdate(Control_Signal);
	 --NewLine_Noupdate;

	 Command := Driving_Command_Manager.Get_Driving_Command;
	 if (Command.Update_Priority <= PRIO_DIST) then
	    --Driving_Command_Manager.Change_Driving_Command(Milliseconds(1000), (Control_Signal), 0, PRIO_DIST);
	    null;
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
      Turn_Count: Integer;
      Turn_Limit: Integer := 10;
      Reference: Integer := 0;
      Control_Signal: Integer;
      Bumper: Touch_Sensor (Sensor_4);
      Turn_Controller: Controller := (Reference, 10, 100, 10, 0, 0);
   begin      
      loop
	 
	 Command := Driving_Command_Manager.Get_Driving_Command;
	 --Put_Noupdate("Starting motors...");
	 --NewLine_Noupdate;
	 Command_Motors(Command.Drive_Speed, Drive_Motor_ID);	 
	 
	 Reference := Command.Turn_Speed;

	 if (abs(Reference) > Turn_Limit) then
	    if (Reference  > Turn_Limit) then 
	       Reference := Turn_Limit;
	    elsif (Reference < -Turn_Limit) then
	       Reference := -Turn_Limit;
	    end if;
	    Turn_Controller.Reference := Reference;
	 end if;	 
	   
	 Turn_Count := NXT.Motor_Encoders.Encoder_Count (Steer_Motor_ID);
	 
	 Calc_Control(Turn_Count, Control_Signal, Turn_Controller);
	 
	 Control_Signal := Control_Signal / 1000;
	 
	 --Put_Noupdate("Encoder: ");
	 --Put_Noupdate (Turn_Count); 
	 --Newline_Noupdate;
	 Put_Noupdate("TurnControl: ");
	 Put_Noupdate(Control_Signal);
	 Newline_Noupdate;
	 
	 
	 
	 Command_Motors(-Control_Signal, Steer_Motor_ID);
	 
	 --  if abs(Turn_Count) < Turn_Limit then
	 -- Command_Motors(Command.Turn_Speed, Steer_Motor_ID);
	 --else 
	 --Command_Motors(0, Steer_Motor_ID);
	 --end if;
	 --  if (Turn_Count > 0) and (Command.Turn_Speed < 0) then
	 --     Command_Motors(Command.Turn_Speed, Steer_Motor_ID);
	 --  elsif (Turn_Count < 0) and (Command.Turn_Speed > 0) then
	 --     Command_Motors(Command.Turn_Speed, Steer_Motor_ID);
	 --  else 
	 --     Command_Motors(0, Steer_Motor_ID);
	 --  end if;
	 

	 
	 Next_Time := Next_Time + Period;
	 delay until Next_Time;
      end loop;
   end MotorControlTask; 
   
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
