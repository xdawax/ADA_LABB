--Protected types: Ada lab part 4

with Ada.Calendar;
with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;
use Ada.Calendar;
use Ada.Text_IO;

procedure comm2 is
   Message: constant String := "Protected Object";
   type BufferArray is array (0 .. 9) of Integer;
   
   subtype Buffer_Item is Integer range 0 .. 25;
   package Random_Buffer_Item is new Ada.Numerics.Discrete_Random(Buffer_Item);
   use Random_Buffer_Item;
   Buffer_Item_Generator: Random_Buffer_Item.Generator;

   G: Ada.Numerics.Float_Random.Generator;
   
   protected buffer is
      entry Insert(Value: in Integer);
      entry Remove(Value: out Integer);
   private 
      Max_Size: Integer := Bufferarray'Length;
      Write_Pointer, Read_Pointer: Positive range 1 .. Bufferarray'Length := 1;
      Length: Natural := 0;
      Buffer: BufferArray; 
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

   function Random_Delay(max: Integer) return Duration is
   begin
      return Duration(Random_Integer(max, 1));
   end Random_Delay;

   protected body buffer is 
      entry Insert(Value: in Integer) when (Length < Max_Size) is
      begin
	 Buffer(Write_Pointer) := Value; -- Insert the value where the write pointer is,
	 Write_Pointer := Write_Pointer mod Max_Size + 1; -- move the pointer forward
	 Length := Length + 1; -- and increase the current length.
      end Insert;
      entry Remove(Value: out Integer) when (Length > 0) is
      begin
	 Value := Buffer(Read_Pointer); -- Read the value where the read pointer is,
	 Read_Pointer := Read_Pointer mod Max_Size + 1; -- move the pointer forward
	 Length := Length - 1; -- and decrease the current length.
      end Remove;
   end buffer;

   task body producer is 
      Message: constant String := "producer executing";
      Insert_Message: constant String := "Producer: inserted";
      Value: Buffer_Item;
      Kill_Flag: Boolean := False;
   begin
      Put_Line(Message);
      loop
	 select
	    delay Random_Delay(2); -- Delay up to two seconds
	    Value := Random(Buffer_Item_Generator); -- Generate a random buffer item, a value between 0 and 25.
	    Put(Insert_Message); -- Print the inserted value
	    Put_Line(Integer'Image(value));
	    Buffer.Insert(Value); 
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
	 delay Random_Delay(2); -- Delay up to two seconds
	 Buffer.Remove(value);
	 sum := sum + value;
	 Put(Remove_Message); -- Print the removed value
	 Put_Line(Integer'Image(value));
	 Put(Sum_Message); -- Print the sum
	 Put_Line(Integer'Image(sum));
	 if (sum > 100) then -- Stop when the sum reaches 100
	    Put_Line(Finish_Message);
	    exit Main_Cycle;
	 end if;
      end loop Main_Cycle; 

      producer.Kill; -- Stop the producer

   exception
      when TASKING_ERROR =>
	 Put_Line("Buffer finished before producer");
	 Put_Line("Ending the consumer");
   end consumer;

begin
   Reset(G);
   Reset(Buffer_Item_Generator);
   Put_Line(Message);
end comm2;
