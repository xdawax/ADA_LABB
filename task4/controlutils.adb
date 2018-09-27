package body ControlUtils is

   function Control(Reference: in Integer; Input: in Integer; Kp: in Integer; Ki: in Integer; Kd: in Integer) return Integer is 
      Error, Last_Error: Integer := 0;
      Integral: Integer := 0;
      Derivative: Integer := 0;
      Output: Integer := 0;
begin
   Error := Input - Reference;
   Last_Error := Error;
   Integral := Integral + Error;
   Derivative := Error - Last_Error;
   Output := Kp * Error + Ki * Integral + Kd * Derivative;
   return Output;
end Control;

end ControlUtils;
