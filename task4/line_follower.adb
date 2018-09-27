with Tasks;
with System;

procedure line_follower is

   pragma Priority (System.Priority'First);

begin

   Tasks.Background;

end line_follower;
