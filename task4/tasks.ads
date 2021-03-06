with Ada.Real_Time;       use Ada.Real_Time;
with NXT;                 use NXT;
with NXT.Motor_Controls;  use NXT.Motor_Controls;

-- Add required sensor and actuator package --

package Tasks is

   procedure Background;

   private

   --  Define periods and times  --

   --  Define of used sensor ports  --

   --  Init sensors --

   --------------------------------
   --  Definition of used ports  --
   --------------------------------
      
      Drive_Motor_ID : constant Motor_Id := Motor_B;
      Steer_Motor_ID : constant Motor_Id := Motor_C;
   --Right_Motor_Id : constant Motor_Id := Motor_A;
   --Left_Motor_Id : constant Motor_Id := Motor_C;

   ----------------------------------
   --  Definition of motors speed  --
   ----------------------------------
   Speed_Full : constant Power_Percentage := 50;
   Speed_Half : constant Power_Percentage := 25;
   Speed_Stop : constant Power_Percentage := 0;
   
   
   PRIO_IDLE: Integer := 1;
   PRIO_DIST: Integer := 2;
   PRIO_LIGHT: Integer := 2;
   PRIO_BUTTON: Integer := 3;




end Tasks;
