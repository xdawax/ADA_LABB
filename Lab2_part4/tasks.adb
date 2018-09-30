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
        entry Wait(Command_Out : Out Command_Type);
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

        procedure Signal(
            New_Prio: in Integer;
            New_Duration: in Time_Span;
            New_Power_L: in Integer;
            New_Power_R: in Integer) is
        begin
            if (Command.Prio >= New_Prio) then 
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
        end Set_Idle;

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