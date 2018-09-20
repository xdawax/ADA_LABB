--Process commnication: Ada lab part 3

with Ada.Calendar;
with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with Ada.Numerics.Float_Random;
use Ada.Calendar;
use Ada.Text_IO;
use Ada.Numerics.Float_Random;

procedure comm1 is
    Message: constant String := "Process communication";
	Float_Seed: Generator;

	function Random_Delay Return Duration is
	begin
		Reset(Float_Seed);
		Return Duration(Random(Float_Seed));
	end Random_Delay;
	
	task buffer is
		entry Enqueue(Element : In Integer);
		entry Dequeue(Element : Out Integer);
		entry kill;
	end buffer;

	task producer is 
		entry kill;
	end producer;

	task consumer is
	end consumer;

	task body buffer is 
		Message: constant String := "buffer executing";
		Max_Size: Integer := 10;
		Current_Size: Integer := 0;
		Buffer_First: Integer := 0;
		Buffer_Last: Integer := 0;
		Buffer : array (0 .. Max_Size) of Integer;
	begin
		Put_Line(Message);
		loop
			select 
				when (Current_Size < Max_Size) =>   -- if there is room in the queue add another object
					Accept Enqueue(Element : In Integer) do
						Buffer(Buffer_Last) := Element;
						Buffer_Last := (Buffer_Last + 1) mod Max_Size;
						Current_Size := Current_Size + 1;             
					end Enqueue; 
			or
				when (Current_Size > 0) => -- if there are elements in queue remove and return object
					Accept Dequeue(Element : Out Integer) do
						Element := Buffer(Buffer_First);
						Buffer_First := (Buffer_First + 1) mod Max_Size;
						Current_Size := Current_Size - 1;
					End Dequeue;				
			or
				Accept Kill;
				Put_Line("Shutting down the buffer...");
				exit;			
			end select;
		end loop;
		
	end buffer;

	task body producer is 
		Message: constant String := "producer executing";
		Random_Input: Integer;
		Subtype Element_Range is Integer range 0..25;
		package Random_Range is
			new Ada.Numerics.Discrete_Random(Result_Subtype => Element_Range);
			Seed : Random_Range.Generator;

	begin
		Random_Range.Reset(Seed);
		Put_Line(Message);
		loop
			Random_Input := Random_Range.Random(Seed);
			Select
		Accept Kill;
				Put_Line("Shutting down the producer...");
				Exit;
			or
							Delay Random_Delay;
				Buffer.Enqueue(Random_Input); 
				Put("Produced: ");
				Put_Line(Integer'Image(Random_Input));
		
			End Select; 
		end loop;
	end producer;

	task body consumer is 
		Message: constant String := "consumer executing";
		Sum: Integer:= 0;
		Sum_Limit: Integer:= 100;
		Fetched_Value: Integer;
	begin
		Put_Line(Message);
		Main_Cycle:
		loop 
			Delay Random_Delay;
			Buffer.Dequeue(Fetched_Value);
			Sum := Sum + Fetched_Value;
			Put("Consumed: ");
			Put_Line(Integer'Image(Fetched_Value));
			Put("Current Consumed Sum is: ");
			Put_Line(Integer'Image(Sum));
			exit Main_Cycle when sum > Sum_Limit;
		end loop Main_Cycle; 
			Buffer.Kill;
			Producer.Kill;   
			Put_Line("Shutting down the consumer...");
		exception
			  when TASKING_ERROR =>
				  Put_Line("Buffer finished before producer");
		Put_Line("Ending the consumer");
	end consumer;
	
begin
	Put_Line(Message);	
end comm1;
