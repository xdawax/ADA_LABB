with Tasks;
with System;

procedure event_program is

   pragma Priority (System.Priority'First);

begin

   Tasks.Background;

end event_program;
