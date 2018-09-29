with System;
with NXT.AVR;		        use NXT.AVR;
with Nxt.Display;               use Nxt.Display;
with ADA.Real_time;		use ADA.Real_time;
with NXT.Audio;
-- with NXT.Light_Sensors;		use NXT.Light_Sensors;
-- with NXT.Light_Sensors.Ctors;	use NXT.Light_Sensors.Ctors;
with NXT.Touch_Sensors; use NXT.Touch_Sensors;
with NXT.Motors.Simple.Ctors;

use NXT.Motors.Simple;
use NXT.Motors.Simple.Ctors;
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

    protected DrivingCommandTask is 
        procedure Change_Driving_Command(
            New_Duration: in Time_Span;
            New_Speed: in PWM_Value;
            New_Prio: in Integer
        );
        function Get_Driving_Command return Driving_Command;
        function Get_Update_Priority return Integer;
     private 
        Drive: Driving_Command := (
            Driving_Duration => milliseconds(0),
            Speed => 0,
            Update_Priority => PRIO_IDLE
        );
    end DrivingCommandTask;

    protected body DrivingCommandTask is 
        procedure Change_Driving_Command(
            New_Duration: in Time_Span;
            New_Speed: in PWM_Value;
            New_Prio: in Integer
        ) is

        begin 
            Drive.Driving_Duration := New_Duration;
            Drive.Speed := New_Speed;
            Drive.Update_Priority := New_Prio;
        end Change_Driving_Command;

        function Get_Driving_Command return Driving_Command is 
        begin 
            return Drive;
        end Get_Driving_Command;

        function Get_Update_Priority return Integer is 
        begin 
            return Drive.Update_Priority;
        end Get_Update_Priority;

    end DrivingCommandTask;


    task MotorTask is
        pragma Priority(System.Priority'First + Motor_Priority);
        pragma Storage_Size(1024); 
    end MotorTask;

    task body MotorTask is
        Drive: Driving_Command;
        Speed: PWM_Value := 0;
        Drive_Duration: Time_Span;
        Prio : Integer;
    begin
        loop 
            Drive := DrivingCommandTask.Get_Driving_Command;
            Drive_Duration :=  Drive.Driving_Duration;
            Speed := Drive.Speed;
            Prio := Drive.Update_Priority;

            if (Drive_Duration > milliseconds(0)) then 
                Engine_Left.Set_Power(Speed);
                Engine_Right.Set_Power(Speed);
                if (Prio = PRIO_BUTTON) then
                    Engine_Left.Backward;
                    Engine_Right.Backward;
                elsif (Prio = PRIO_DIST) then
                    Engine_Left.Forward;
                    Engine_Right.Forward;
                end if;
                Drive_duration := Drive_duration - MotorPeriod;
                DrivingCommandTask.Change_Driving_Command(Drive_Duration, Speed, Prio);
            end if;

            if (Drive_Duration <= milliseconds(0) and Prio /= PRIO_IDLE) then 
                DrivingCommandTask.Change_Driving_Command(Drive_duration, Speed, PRIO_IDLE);
                Engine_Left.Stop(Apply_Brake => True);
                Engine_Right.Stop(Apply_Brake => True);
            end if;

            delay until Clock + MotorPeriod;

        end loop;
    end MotorTask;


    task ButtonTask is
        pragma Priority(System.Priority'First + Button_Priority);
        pragma Storage_Size(1024); 
    end ButtonTask;

    task body ButtonTask is
        Current_Prio: Integer;
    begin
        loop
            if (Pressed(Bumper)) then
                NXT.Audio.Play_Tone
                    (
                        Frequency => 800,
                        Interval => 10,
                        Volume => 50
                    );
                    Current_Prio := DrivingCommandTask.Get_Update_Priority;

                    if (PRIO_BUTTON >= Current_Prio) then
                        DrivingCommandTask.Change_Driving_Command(seconds(1), 50, PRIO_BUTTON);
                    end if;
            end if;
            delay until Clock + ButtonPeriod;
        end loop;
    end ButtonTask;

    task DisplayTask is
        pragma Priority(System.Priority'First + Display_Priority);
        pragma Storage_Size(1024); 

    end DisplayTask;

    task body DisplayTask is
        Driving_State: Driving_Command;
    begin
        loop
            Driving_State := DrivingCommandTask.Get_Driving_Command;
            put_noupdate(Driving_State.Update_Priority);
            Newline;
            delay until Clock + DisplayPeriod;
        end loop;
    end DisplayTask;

    task DistanceTask is 
        pragma Priority(System.Priority'First + Distance_Priority);
        pragma Storage_Size(1024); 
    end DistanceTask;
 
    task body DistanceTask is 
        Distance: Natural;
        Limit: constant Natural := 25;
        Current_Prio: Integer;
        P_Constant: constant Integer := 2;
        New_Speed: PWM_Value;
    begin
        Sonar.Set_Mode(Ping);
        loop
            -- Sonar.reset; 
            Ping(Sonar);
            Get_Distance(Sonar, Distance);
            put_noupdate(Distance);
            Newline_Noupdate;
            Current_Prio := DrivingCommandTask.Get_Update_Priority;
            if (PRIO_DIST >= Current_Prio) then 
                if (Distance > Limit) then 
                    New_Speed := PWM_Value((Distance-Limit)*P_Constant);
                    if (New_Speed > 100) then 
                        New_Speed := 100; 
                    end if;
                    DrivingCommandTask.Change_Driving_Command(milliseconds(500), New_Speed, PRIO_DIST);
                elsif (Distance <= Limit) then 
                    DrivingCommandTask.Change_Driving_Command(milliseconds(500), 0, PRIO_DIST);
                end if;
            end if;
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