with Ada.Real_Time;       use Ada.Real_Time;
with NXT;                 use NXT;
with NXT.Touch_Sensors; use NXT.Touch_Sensors;
-- Add required sensor and actuator package --
with NXT.Motors.Simple.Ctors;

use NXT.Motors.Simple;
use NXT.Motors.Simple.Ctors;
with NXT.Ultrasonic_Sensors;        use NXT.Ultrasonic_Sensors;
with NXT.Ultrasonic_Sensors.Ctors;  use NXT.Ultrasonic_Sensors.Ctors;

package Tasks is

   procedure Background;

   private

    type Driving_Command is record 
        Driving_Duration: Time_Span;
        Speed: PWM_Value;
        Update_Priority: Integer;
    end record;


    -- Update_Priorities --
    PRIO_IDLE: Integer := 1;
    PRIO_DIST: Integer := 2;
    PRIO_BUTTON: Integer := 3;

    -- Task Priorities
    Motor_Priority:     Integer := 2;
    Button_Priority:    Integer := 1;
    Display_Priority:   Integer := 0;
    Distance_Priority:  Integer := 5;
    ShutDown_Priority:  Integer := 10;

   --  Define periods and times  --
    MotorPeriod:    Time_Span := milliseconds(50);
    ButtonPeriod:   Time_Span := milliseconds(10);
    DisplayPeriod:  Time_Span := milliseconds(100);
    DistancePeriod: Time_Span := milliseconds(100);
    ShutdownPeriod: Time_Span := milliseconds(500);

   --  Define used sensor ports  --
    Bumper: Touch_Sensor (Sensor_2);
    Sonar : Ultrasonic_Sensor := Make (Sensor_3);
    --  Init sensors --

    -- Engines --
    Engine_Left: Simple_Motor := Make (Motor_A);
    Engine_Right: Simple_Motor := Make (Motor_B);

end Tasks;