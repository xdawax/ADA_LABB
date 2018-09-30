with Ada.Real_Time;       use Ada.Real_Time;
with NXT;                 use NXT;
with NXT.Touch_Sensors; use NXT.Touch_Sensors;
-- Add required sensor and actuator package --
with NXT.Motors.Simple.Ctors;

use NXT.Motors.Simple;
use NXT.Motors.Simple.Ctors;
with NXT.Ultrasonic_Sensors;        use NXT.Ultrasonic_Sensors;
with NXT.Ultrasonic_Sensors.Ctors;  use NXT.Ultrasonic_Sensors.Ctors;
with NXT.Light_Sensors;		use NXT.Light_Sensors;
with NXT.Light_Sensors.Ctors;	use NXT.Light_Sensors.Ctors;

package Tasks is

   procedure Background;

   private

    type Command_Type is record 
        Prio: Integer;
        Duration: Time_Span;
        Power_L: Integer; 
        Power_R: Integer;
    end record;


    -- Update_Priorities --
    PRIO_IDLE:  constant Integer := 1;
    PRIO_LIGHT: constant Integer := 2;
    PRIO_DIST:  constant Integer := 3;
    

    -- Task Priorities --

    Distance_Priority:  constant Integer := 3;
    Light_Priority:     constant Integer := 2;
    Motor_Priority:     constant Integer := 1;
    ShutDown_Priority:  constant Integer := 10;

   --  Define periods and times  --
    MotorPeriod:    constant Time_Span := milliseconds(50);
    DistancePeriod: constant Time_Span := milliseconds(100);
    ShutdownPeriod: constant Time_Span := milliseconds(500);

   --  Define used sensor ports  --
    Sonar : Ultrasonic_Sensor := Make (Sensor_3);
    Photo : Light_Sensor := Make (Sensor_1, Floodlight_On => True);
    --  Init sensors --

    -- Engines --
    Engine_Left:  Simple_Motor := Make (Motor_A);
    Engine_Right: Simple_Motor := Make (Motor_B);

end Tasks;