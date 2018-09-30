with System;
with NXT.AVR;		        use NXT.AVR;
with Nxt.Display;               use Nxt.Display;
with ADA.Real_time;		use ADA.Real_time;
with NXT.Audio;

with NXT.Touch_Sensors; use NXT.Touch_Sensors;
with NXT.Motors.Simple.Ctors;

use NXT.Motors.Simple;
use NXT.Motors.Simple.Ctors;

with NXT.Motor_Controls; use NXT.Motor_Controls;

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

    protected CommandCenter is 
        entry Wait(Command_Out : Out Command_Type);
        function Get_Command return Command_Type;
        procedure Signal (
            New_Prio: in Integer;
            New_Duration: in Time_Span;
            New_Power_L: in Integer;
            New_Power_R: in Integer
        );
        procedure Set_Duration(New_Duration : in Time_Span);
        procedure Set_Idle;
     private 
        Command: Command_Type := (
            Prio => PRIO_IDLE,
            Duration => milliseconds(0),
            Power_L => 0,
            Power_R => 0
        );
        Signalled: Boolean := False;
    end CommandCenter;

    protected body CommandCenter is 
        entry Wait(Command_Out : out Command_Type) when Signalled is
        begin
            Command_Out := Command;
            Signalled := False;
        end Wait;

        function Get_Command return Command_Type is 
        begin 
            return Command;
        end Get_Command;


        procedure Signal(
            New_Prio: in Integer;
            New_Duration: in Time_Span;
            New_Power_L: in Integer;
            New_Power_R: in Integer) is
        begin
            -- Put_Noupdate("Signaled");
            -- Newline;
            if (Command.Prio <= New_Prio) then 
                Command.Prio := New_Prio;
                Command.Duration := New_Duration;
                Command.Power_L := New_Power_L;
                Command.Power_R := New_Power_R; 
                Signalled := True;    
            end if;
        end Signal;

        procedure Set_Duration(New_Duration : in Time_Span) is 
        begin 
            Command.Duration := New_Duration;
        end Set_Duration;

        procedure Set_Idle is 
        begin 
            Command.Prio := PRIO_IDLE;
            Signalled := True;
        end Set_Idle;

    end CommandCenter;

    procedure Set_Motor(Power : in Integer; Engine_Id : in Motor_Id) is 
        Engine:  Simple_Motor := Make (Engine_Id);
    begin
        if (Power > 100) then 
            Engine.Set_Power(100);
            Engine.Forward;
        elsif (Power < -100) then 
            Engine.Set_Power(100);
            Engine.Backward;
        else 
            if (Power > 0) then 
                Engine.Set_Power(Power_Percentage(Power));
                Engine.Forward;
            elsif (Power < 0) then 
                Engine.Set_Power(Power_Percentage((-1)*Power));
                Engine.Backward;
            else
                Engine.Stop (Apply_Brake => True);
            end if;
        end if;
    end Set_Motor;

    task MotorTask is
        pragma Priority(System.Priority'First + Motor_Priority);
        pragma Storage_Size(1024); 
    end MotorTask;

    task body MotorTask is
        New_Command: Command_Type;
        Extra_Left_Power: Integer := 170; -- Compensate for left engine beeing weeker
    begin
        loop 
            -- CommandCenter.Wait(New_Command);
            New_Command := CommandCenter.Get_Command;
            if (New_Command.Prio /= PRIO_IDLE) then  
                -- Put_Noupdate("Inside MotorTask");
                -- Newline;
                if (New_Command.Duration >= milliseconds(0)) then 
                    Set_Motor((New_Command.Power_L*Extra_Left_Power)/100, Engine_Left.id);
                    Set_Motor(New_Command.Power_R, Engine_Right.id);
                else 
                    CommandCenter.Set_Idle;
                    Set_Motor(0, Engine_Left.id);
                    Set_Motor(0, Engine_Right.id);
                end if;
            end if;

            CommandCenter.Set_Duration(New_Command.Duration - MotorPeriod);
            
            delay until Clock + MotorPeriod;
        end loop;
    end MotorTask;

    task LightTask is 
        pragma Priority(System.Priority'First + Light_Priority);
        pragma Storage_Size(1024); 
    end LightTask; 
    
    task body LightTask is 
        Reference: Integer := 35;
        Power_L: Integer;
        Power_R: Integer;
        Base_Power: Integer := 30;
        Error: Integer;
        Last_Error: Integer := 0;
        Integral: Integer := 0;
        Integral_Limit: Integer := 30;
        Kp: Integer := 200;
        Ki: Integer := 0;
        Kd: Integer := 20;
    begin 
        loop 

            Put_Noupdate("L: ");
            Put_Noupdate(Photo.Light_Value);
            Newline_Noupdate;
            Error := (Reference - Photo.Light_Value);
            Put_Noupdate("E: ");
            Put_Noupdate(Error);
            Newline;
            Integral := Integral + Error;
            
            if (Integral > Integral_Limit) then 
                Integral := Integral_Limit;
            elsif (Integral < -Integral_Limit) then 
                Integral := -Integral_Limit;
            end if;

            Power_L := Base_Power + ((Kp*Error)/100 + (Ki*Integral)/100 + (Kd*(Error - Last_Error))/100);
            Power_R := Base_Power - ((Kp*Error)/100 + (Ki*Integral)/100 + (Kd*(Error - Last_Error))/100);
            CommandCenter.Signal(PRIO_LIGHT, milliseconds(100), Power_L, Power_R);
            -- CommandCenter.Signal(PRIO_LIGHT, milliseconds(100), 40, 40);
            Last_Error := Error;
            

            delay until Clock + LightPeriod;
        end loop;
    end LightTask;

    task DistanceTask is 
        pragma Priority(System.Priority'First + Distance_Priority);
        pragma Storage_Size(1024); 
    end DistanceTask;
 
    task body DistanceTask is 
        Distance: Natural;
        Reference: constant Natural := 20;
        New_Speed: Integer;
        P_constant: Integer := 3;
    begin
        Sonar.Set_Mode(Ping);
        loop
            -- Sonar.reset; 
            Ping(Sonar);
            Get_Distance(Sonar, Distance);
            
            New_Speed := (Distance - Reference)*P_Constant;
            if (Distance < 20) then 
                CommandCenter.Signal(PRIO_DIST, milliseconds(100), New_Speed, New_Speed);
            end if;
            -- Put_Noupdate(Distance);
            -- Put_Noupdate(" ");
            -- Put_Noupdate(New_Speed);
            -- Newline;
            delay until Clock + DistancePeriod;
        end loop;
    end DistanceTask;


    task ShutdownTask is 
        pragma Priority (System.Priority'First + Shutdown_Priority);
        pragma Storage_Size (1024); --  task memory allocation --
    end ShutdownTask;
        task body ShutdownTask is 

        begin
            loop
    	    if NXT.AVR.Button = Power_Button then
    	        NXT.AVR.Power_Down;
    	    end if;
    	    delay until Clock + ShutdownPeriod;
          end loop;
    end ShutdownTask;


end Tasks;