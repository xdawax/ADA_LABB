protected Event is
       entry Wait(event_id : out Integer);
       procedure Signal(event_id : in Integer);
private
        -- assign priority that is ceiling of the user tasks priorities --
       Current_event_id : Integer;     -- Event data declaration
       Signalled : Boolean := False;   -- This is flag for event signal
end Event;

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
