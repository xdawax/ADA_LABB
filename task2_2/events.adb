with System;
package body Events is
   protected body Event is
      entry Wait(event_id : out Integer) when Signalled is
      begin
         event_id := Current_event_id;
         Signalled := False;
      end Wait;

      procedure Signal(event_id : in Integer) is
      begin
         Current_event_id := event_id;
         Signalled := True;
      end Signal;
   end Event;
end Events;
