with System;
with NXT.AVR;		        use NXT.AVR;
with Nxt.Display;               use Nxt.Display;
with ADA.Real_time;		use ADA.Real_time;
with NXT.Audio;

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

    protected CommandCenter is 
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
    end CommandCenter;

    protected body CommandCenter is 
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

    end CommandCenter;


    task MotorTask is
        pragma Priority(System.Priority'First + Motor_Priority);
        pragma Storage_Size(1024); 
    end MotorTask;

    task body MotorTask is
    begin
        loop 
            null;
            delay until Clock + MotorPeriod;
        end loop;
    end MotorTask;


    task DistanceTask is 
        pragma Priority(System.Priority'First + Distance_Priority);
        pragma Storage_Size(1024); 
    end DistanceTask;
 
    task body DistanceTask is 
        Distance: Natural;
        Reference: constant Natural := 20;
    begin
        Sonar.Set_Mode(Ping);
        loop
            -- Sonar.reset; 
            Ping(Sonar);
            Get_Distance(Sonar, Distance);
            Put_Noupdate(Distance);
            Newline;
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