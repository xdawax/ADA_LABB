with Tasks;
with System;

procedure TopDog is

   pragma Priority (System.Priority'First);

begin

   Tasks.Background;

end TopDog;