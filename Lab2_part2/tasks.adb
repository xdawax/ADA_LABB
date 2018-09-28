with System;
with NXT.AVR;		        use NXT.AVR;
with Nxt.Display;               use Nxt.Display;
with ADA.Real_time;		use ADA.Real_time;
with NXT.Audio;
with NXT.Light_Sensors;		use NXT.Light_Sensors;
with NXT.Light_Sensors.Ctors;	use NXT.Light_Sensors.Ctors;
with NXT.Touch_Sensors; use NXT.Touch_Sensors;
with Events; use Events;
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

    task MotorControlTask is 
        Pragma Priority(System.Priority'First + 1);
        pragma Storage_Size(4096);
    end MotorControlTask;

    task body MotorControlTask is 
        Event_ID: Integer;
        Engine_Left: Simple_Motor := Make (Motor_A);
        Engine_Right: Simple_Motor := Make (Motor_B);
        IsOnTable: Boolean := True;
    begin
        loop 
            Event.Wait(Event_ID);

            if (Event_ID = OffTable) then 
                IsOnTable := False;
                Engine_Left.Stop (Apply_Brake => True);
                Engine_Right.Stop (Apply_Brake => True);
            elsif (Event_ID = OnTable) then
                IsOnTable := True;
            end if;

            if (Event_ID = TouchOnEvent and IsOnTable) then 
                Engine_Left.Set_Power(50);
                Engine_Right.Set_Power(50);
                Engine_Left.Forward;
                Engine_Right.Forward;
            elsif (Event_ID = TouchOffEvent) then 
                Engine_Left.Stop (Apply_Brake => True);
                Engine_Right.Stop (Apply_Brake => True);
            end if;
            delay until Clock + milliseconds(10);
        end loop;
    end MotorControlTask;

    task EventdispatcherTask is 
        Pragma Priority(System.Priority'First + 2);
        pragma Storage_Size(4096);
    end EventdispatcherTask;

    task body EventdispatcherTask is 
        Bumper: Touch_Sensor (Sensor_2);
        Bumper_Status: Boolean := false;
        Photo: Light_Sensor := Make (Sensor_1, True);
        Last_Light_Value: Integer := 100;
        Light_Threshold: Integer := 33;
        Table_Status: Boolean := True;
    begin 
        loop
            if (Pressed(Bumper)) then 
                NXT.Audio.Play_Tone
                    (
                        Frequency => 800,
                        Interval => 10,
                        Volume => 50
                    );
            end if;

            if (Pressed(Bumper) and not Bumper_Status) then 
                Bumper_Status := True;
                Event.Signal(TouchOnEvent);
                put_noupdate("Touch ON");
                Newline;
            elsif (not Pressed(Bumper) and Bumper_Status) then 
                Bumper_Status := False;
                Event.Signal(TouchOffEvent);
                put_noupdate("Touch OFFFFFFFF");
                Newline;
            end if;
            
            -- put_noupdate("Light Value: ");
            -- put_noupdate(Photo.Light_Value);
            -- Newline;

            if (Photo.Light_Value > Light_Threshold and not Table_Status) then 
                Event.Signal(OnTable);
                Table_Status := True;
                -- put_noupdate(" On Table");
                -- NewLine;
            elsif (Photo.Light_Value < Light_Threshold and Table_Status) then 
                Event.Signal(OffTable);
                Table_Status := False;
                -- put_noupdate(" Off Table");
                -- NewLine;
            end if;

            Last_Light_Value := Photo.Light_Value;

            delay until Clock + Milliseconds(10);
        end loop;
    end EventdispatcherTask;



    task ShutdownTask is 
            pragma Priority (System.Priority'First + 10);
            pragma Storage_Size (1024); --  task memory allocation --
    end ShutdownTask;
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


end Tasks;
