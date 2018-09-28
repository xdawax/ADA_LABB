
with System;


package Events is
  
	protected Event is
		entry Wait(event_id : out Integer);
		procedure Signal(event_id : in Integer);
  	private
      -- assign priority that is ceiling of the user tasks priorities --
      pragma Priority(System.Priority'First + 10);
      Current_event_id : Integer;     -- Event data declaration
      Signalled : Boolean := False;   -- This is flag for event signal
      
   end Event;
   
   ----------------------------------
   --            Event IDs         --
   ----------------------------------
    TouchOnEvent: Integer := 1;
    TouchOffEvent: Integer := 2;
    OffTable: Integer := 3;
    OnTable: Integer := 4;
end Events;