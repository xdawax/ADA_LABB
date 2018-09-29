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
            Car_Speed => 0,
            Update_Priority => 0
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
            Drive.Car_Speed := New_Speed;
            
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


    task MotorControlTask is
        pragma Priority(System.Priority'First + 2);
        pragma Storage_Size(1024); 
        -- entry 
    end MotorControlTask;

    task body MotorControlTask is
        Drive: Driving_Command;
        Speed: PWM_Value := 0;
        Drive_Duration: Time_Span;
        Prio : Integer;
    begin
        loop 
            Drive := DrivingCommandTask.Get_Driving_Command;
            Drive_Duration :=  Drive.Driving_Duration;
            Speed := Drive.Car_Speed;
            Prio := Drive.Update_Priority;

            if (Drive_Duration > milliseconds(0)) then 
                Engine_Left.Set_Power(Speed);
                Engine_Right.Set_Power(Speed);
                Engine_Left.Backward;
                Engine_Right.Backward;
                Drive_duration := Drive_duration - MotorControlPeriod;
                DrivingCommandTask.Change_Driving_Command(Drive_Duration, Speed, Prio);
            end if;

            if (Drive_Duration <= milliseconds(0) and Prio /= PRIO_IDLE) then 
                DrivingCommandTask.Change_Driving_Command(Drive_duration, Speed, PRIO_IDLE);
                Engine_Left.Stop(Apply_Brake => True);
                Engine_Right.Stop(Apply_Brake => True);
            end if;

            delay until Clock + MotorControlPeriod;

        end loop;
    end MotorControlTask;


    task ButtonTask is
        pragma Priority(System.Priority'First + 11);
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

                    if (PRIO_BUTTON > Current_Prio) then
                        DrivingCommandTask.Change_Driving_Command(seconds(1), 50, PRIO_BUTTON);
                    end if;
            end if;
            delay until Clock + ButtonPeriod;
        end loop;
    end ButtonTask;

    task DisplayTask is
        pragma Priority(System.Priority'First + 12);
        pragma Storage_Size(1024); 
        
    end DisplayTask;

    task body DisplayTask is
        Driving_State: Driving_Command;
    begin
        loop
            Driving_State := DrivingCommandTask.Get_Driving_Command;
            put_noupdate(" P:");
            put_noupdate(Driving_State.Update_Priority);
            Newline;
            delay until Clock + DisplayPeriod;
        end loop;
    end DisplayTask;

    -- task DistanceTask is 
    --     pragma Priority(System.Priority'First + 11);
    --     pragma Storage_Size(1024); 
    -- end DistanceTask;
    -- 
    -- task body DistanceTask is 
    --     Distance: Integer;
    --     Distance_Array: Distances (1..8);
    --     Num_Detected: Integer;
    -- begin
    --     Sonar.Set_Mode(Ping);
    --     Sonar.reset;
    --     loop 
    --         put_noupdate("DistanceTask");
    --         Newline;
    --         Sonar.Ping;
    --         Sonar.Get_Distances(Distance_Array, Num_Detected);
    --         Distance := Integer(Distance_Array(Num_Detected));
    --         put_noupdate("Dist: ");
    --         put_noupdate(Distance);
    --         Newline;
-- 
    --         delay until Clock + DistancePeriod;
    --     end loop;
    -- end DistanceTask;


    task ShutdownTask is 
        pragma Priority (System.Priority'First + 10);
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