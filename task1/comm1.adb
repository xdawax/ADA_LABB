--Process commnication: Ada lab part 3

with Ada.Calendar;
with Ada.Text_IO;
use Ada.Calendar;
use Ada.Text_IO;
with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;

procedure comm1 is
   Message: constant String := "Process communication";
   G: Generator;
   subtype Buffer_Item is Integer range 0 .. 25;
   task buffer is
      entry Insert(number: in Integer);
      entry Remove(number: out Integer);
      entry Kill;
   end buffer;

   task producer is
      entry Kill;
   end producer;

   task consumer is
   end consumer;

   function Random_Integer(min: Integer; max: Integer) return Integer is
   begin
      return Integer(Random(G) * Float(max)) + min;
   end Random_Integer;

   function Random_Buffer_Item return Buffer_Item is
      
   begin
      return Buffer_Item(Random_Integer(Buffer_Item'First, Buffer_Item'Last));
   end Random_Buffer_Item;

   function Random_Delay(max: Integer) return Duration is
   begin
      return Duration(Random_Integer(max, 1));
   end Random_Delay;

   task body buffer is -- Cyclic buffer code from https://en.wikibooks.org/wiki/Ada_Programming/Tasking
      Message: constant String := "Buffer: executing";
      Q_Size : constant := 10;
      subtype Q_Range is Positive range 1 .. Q_Size;
      Length : Natural range 0 .. Q_Size := 0;
      Head, Tail : Q_Range := 1;
      -- Accept_Message: constant String := "Buffer: accepted";
      Data : array (Q_Range) of Integer;
      Kill_Flag: Boolean := False;
   begin
      Put_Line(Message);
      loop
	 select
	    when Length < Q_Size =>
	       accept Insert (number : in Integer) do
	       -- Put(Accept_Message);
	       -- Put_Line(Integer'Image(number));
	       Data(Tail) := number;
	       end Insert;
	       Tail := Tail mod Q_Size + 1;
	       Length := Length + 1;
	 or
	    when Length > 0 =>
	       accept Remove (number : out Integer) do
		  number := Data(Head);
	       end Remove;
	       Head := Head mod Q_Size + 1;
	       Length := Length - 1;
	 or
	    accept Kill do 
	       Kill_Flag := True;
	    end Kill;
	 end select;
	 if (Kill_Flag) then
	    Put_Line("Buffer: shutting down");
	    exit;
	 end if;

      end loop;
   end buffer;

   task body producer is 
      Message: constant String := "Producer: executing";
      Insert_Message: constant String := "Producer: inserted";
      value: Buffer_Item;
      Kill_Flag: Boolean := False;
   begin
      Put_Line(Message);
      loop
	 select
	    delay Random_Delay(2);
	    value := Random_Buffer_Item;
	    Put(Insert_Message);
	    Put_Line(Integer'Image(value));
	    Buffer.Insert(value);
	 or 
	    accept Kill do
	       Kill_Flag := True;
	    end Kill;
	 end select;
	 
	 if (Kill_Flag) then
	    Put_Line("Producer: shutting down");
	    exit;
	 end if;
	 
      end loop;
   end producer;

   task body consumer is
      Message: constant String := "Consumer: executing";
      Remove_Message: constant String := "Consumer: removed";
      Sum_Message: constant String := "Consumer: sum is now";
      Finish_Message: constant String := "Consumer: Sum is above 100, shutting down...";
      value: Integer;
      Sum: Integer := 0;
   begin
      Put_Line(Message);
  Main_Cycle:
      loop
	 delay Random_Delay(2);
	 Buffer.Remove(value);
	 sum := sum + value;
	 Put(Remove_Message);
	 Put_Line(Integer'Image(value));
	 Put(Sum_Message);
	 Put_Line(Integer'Image(sum));
	 if (sum > 100) then
	    Put_Line(Finish_Message);
	    exit Main_Cycle;
	 end if;
      end loop Main_Cycle; 

      producer.Kill;
      buffer.Kill;

   exception
      when TASKING_ERROR =>
	 Put_Line("Buffer finished before producer");
	 Put_Line("Ending the consumer");
   end consumer;

begin
   Reset(G);
   Put_Line(Message);
end comm1;
