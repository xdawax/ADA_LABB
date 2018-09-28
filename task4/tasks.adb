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
      procedure Change_Speed(Update_Speed: Integer);
      procedure Change_Turn(Update_Turn: Integer);
      
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
      
      procedure Change_Speed(Update_Speed: Integer) is
      begin
	 Command.Drive_Speed := Update_Speed;
      end Change_Speed;
      
      procedure Change_Turn(Update_Turn: Integer) is
      begin
	 Command.Turn_Speed := Update_Turn;
      end Change_Turn;
      
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
      pragma Storage_Size (1024); --  task memory allocation --
   end MotorControlTask; 
   
   task DisplayTask is 
      pragma Priority (System.Priority'First + 2);
      pragma Storage_Size (1024); --  task memory allocation --
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
   
   procedure Command_Motors(Motor: Motor_Id; Speed: Integer) is 
      Current_Speed: Integer;
      Limit: Integer := 40;
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
      Light_Controller: Controller := (Reference, 1000, 10, 1000, 0, 0);
      Control_Signal: Integer;
      Reading: Integer;
      Command: Driving_Command;
      Last_Control: Integer := 0;
      Verbose: Boolean := True;
   begin
      loop
	 
	 if NXT.AVR.Button = Right_Button then 
	    White_Edge := Ls.Light_Value; 
	    Light_Controller.Reference := (White_Edge + Black_Edge)/2; 
	    Light_Controller.Integral := 0;
	    Light_Controller.Last_Error := 0;
	 elsif NXT.AVR.Button = Left_Button then
	    Black_Edge := Ls.Light_Value;
	    Light_Controller.Reference := (White_Edge + Black_Edge)/2;
	    Light_Controller.Integral := 0;
	    Light_Controller.Last_Error := 0;
	 end if;
	 
	 Reading := Ls.Light_Value;
	 Calc_Control(Reading, Control_Signal, Light_Controller);
	 
	 Control_Signal := Control_Signal/100;
	 
	 if (Verbose) then
	    Put_Noupdate("Light: ");
	    Put_Noupdate(Reading);
	    NewLine_Noupdate;
	    Put_Noupdate("R_Light: ");
	    Put_Noupdate(Light_Controller.Reference);
	    NewLine_Noupdate;
	    
	    Put_Noupdate("U_Light: ");
	    Put_Noupdate(Control_Signal);
	    NewLine_Noupdate;
	 end if;

	 --if (Last_Control /= Control_Signal) then
	 Command := Driving_Command_Manager.Get_Driving_Command;
	 if (Command.Update_Priority <= PRIO_LIGHT) then
	    Driving_Command_Manager.Change_Turn(Control_Signal);
	 end if;
	 --end if;
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
      Distance_Controller: Controller := (Reference, 2, 0, 20, 0, 0);
      Control_Signal: Integer;
      Verbose: Boolean := True;
      Last_Control: Integer := 0;
   begin
      loop
	 Ping(Sonic_Sensor);
	 Get_Distance(Sonic_Sensor, Reading);
	 
	 Calc_Control(Reading, Control_Signal, Distance_Controller);
	 
	 Control_Signal := Control_Signal;
	 
	 if (Control_Signal > 50) then
	    Control_Signal := 50;
	 elsif (Control_Signal < -50) then
	    Control_Signal := -50;
	 end if;
	 
	   if (Verbose) then
	    Put_Noupdate("Sonic: ");
	    Put_Noupdate(Reading);
	    NewLine_Noupdate;
	    Put_Noupdate("U_Sonic: ");
	    Put_Noupdate(Control_Signal);
	    NewLine_Noupdate;
	 end if;

	 if (Last_Control /= Control_Signal) then
		 Command := Driving_Command_Manager.Get_Driving_Command;
		 if (Command.Update_Priority <= PRIO_DIST) then
		    Driving_Command_Manager.Change_Speed(Control_Signal);
		 end if;
		 Last_Control := Control_Signal;
	 end if;
	 
	 Next_Time := Next_Time + Period;
	 delay until Next_Time;  

      end loop;
   end DistanceTask;
   
   task body ShutdownTask is 
      Next_Time : Time := Clock;
      Period : Time_Span := milliseconds(500);
      Motor_Stop: Boolean := False;
      Command: Driving_Command;
   begin
      loop
	 
	 if (Motor_Stop) then
	    Motor_Stop := False;
	    Put_Noupdate("Motor Start!");
	    NewLine_Noupdate;
	    Command := Driving_Command_Manager.Get_Driving_Command;
	    if (Command.Update_Priority <= PRIO_STOP) then
	       Driving_Command_Manager.Change_Driving_Command(Milliseconds(1000), 
							      0, 
							      0, PRIO_IDLE);
	    end if;
	 end if;
	 
	 
	 if NXT.AVR.Button = Power_Button then
	    NXT.AVR.Power_Down;
	 end if; 
	 
	 if (NXT.AVR.Button = Middle_Button) then
	    Motor_Stop := True;
	    Put_Noupdate("Motor Stop!");
	    NewLine_Noupdate;
	    Next_Time := Next_Time + Milliseconds(5000);
	    Command := Driving_Command_Manager.Get_Driving_Command;
	    if (Command.Update_Priority <= PRIO_STOP) then
	       Driving_Command_Manager.Change_Driving_Command(Milliseconds(1000), 
							      0, 
							      0, PRIO_STOP);
	    end if;
	 else 
	    Next_Time := Next_Time + Period;
	 end if; 
	 
	 delay until Next_Time;
   end loop;
end ShutdownTask;
   
   

   task body MotorControlTask is
      Next_Time : Time := Clock;
      Period : Time_Span := milliseconds(50);
      Command: Driving_Command;
      Speed: Integer := 0;
      Turn: Integer := 0; 
      Duration: Time_Span := Milliseconds(0);
      Started: Boolean := False;
      Current_Priority: Integer := PRIO_IDLE;
      Verbose: Boolean := True;
   begin     
      loop
	 
	 Command := Driving_Command_Manager.Get_Driving_Command;
	 
	 if (Command.Drive_Speed /= No_Value) then
	    Speed := Command.Drive_Speed;
	    Put_Noupdate("Base Speed: ");
	    Put_Noupdate(Speed);
	    NewLine_Noupdate;
	 end if;
	 
	 if (Command.Turn_Speed /= No_Value) then
	    Turn := Command.Turn_Speed;
	 end if;
	 
	 if (Verbose) then
	    Put_Noupdate("Left Speed: ");
	    Put_Noupdate(Speed - Turn);
	    NewLine_Noupdate;
	    Put_Noupdate("Right Speed: ");
	    Put_Noupdate(Speed + Turn);
	    NewLine_Noupdate;
	 end if;
	 
	 Command_Motors(Left_Motor_Id, Speed - Turn); 
	 Command_Motors(Right_Motor_Id, Speed + Turn);
	 
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
