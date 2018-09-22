--Process commnication: Ada lab part 3
with Ada.Text_io;
with Ada.Numerics.Float_random;
with Ada.Numerics.Discrete_Random;
with Ada.Calendar;
use Ada.Text_io;
use Ada.Calendar;


procedure comm1 is
	Message: constant String := "Process communication";
	task buffer is --task for the FIFO buffer
		entry push_buff(i : in Integer);
		entry get_buff(i : out Integer);
		entry done;
	end buffer;

	task producer is --task for the producer 
		entry done;
	end producer;

	task consumer is --task for the consumer
	end consumer;

	task body buffer is
		Message: constant String := "buffer executing";
		type int_array is array(1..10) of Integer;--creating a type of array to hold 10 Integers
		fifo : int_array; --initializing buffer
		length : Integer := 1; --current index position of array
		Fin : Boolean := false; --status of the termination
	begin
		Put_Line(Message);
			while not Fin loop --loop until termination 
				select
					when length < fifo'Length => accept push_buff(i : in Integer) do --producer can push integers into buffer ONLY if current index of buffer does not exceed the maximum capacity of the buffer
						fifo(length) := i; --assign the random integer to the current index position 
						length := length + 1; --increment the current index position
					end push_buff;

				or

					when length > 1 => accept get_buff(i : out Integer) do --consumer can take out integers only if the current index is not less that the minimum capacity of the buffer 
						i := fifo(1); --assign the first element of the buffer to the variable
						fifo := fifo(2..10) & 0;  --push the buffer elements forward by one and add 0 as the element
						length := length - 1;  --decrease the current index position
					end get_buff;
				or
					accept done do
						Fin := true; --set termination status to True
					end done;
				end select;
                      end loop;
	end buffer;


	task body producer is
		Message: constant String := "producer executing";
		subtype input_range is Integer range 0..25;  --create a subtype of 0 to 25 integers
		package random_input is new Ada.Numerics.Discrete_Random(input_range); --create a package to randomly generate numbers using the subtype
		use random_input;
		Wait : Duration := 0.0; --delay time
		input : input_range; --random number between 0 and 25 
		Gen : Generator;
		Fin : Boolean := false; --status of the termination
	begin
		Put_Line(Message);
		Reset(Gen);
			while not Fin loop --loop until termination
				Wait := Duration(Random(Gen)/10); --randomize the wait variable (producer delay is kept lower than consumer)
				select
					delay Wait; 
					input := Random(Gen); --randomise the number to be input
					Put("Produced: ");
					Put_Line(Integer'Image(input)); --display the current integer produced
					buffer.push_buff(input); --call the buffer to push "input" into FIFO buffer
				or
					
					accept done do
						Fin := true; --set termination status to True
					end done;
				end select;
			end loop;
	end producer;


	task body consumer is
		Message: constant String := "consumer executing";
		use Ada.Numerics.Float_random;
		Wait : Duration := 0.0; --delay time
		Sum, Val : Integer := 0; -- sum of the integers taken out by consumer , current integer taken out by consumer
		Gen : Generator;
	begin
		Put_Line(Message);
		Reset(Gen);
			while sum < 100 loop  --untill the total sum of integers taken out by consumer is less than 100
				Wait := Duration(Random(Gen)); --randomize the wait variable
				delay Wait;
				buffer.get_buff(val); -- call buffer to get the first element of FIFO
				sum := sum + val;  --adds all the integers taken out by consumer
				Put("Consumed:");
				Put_Line(Integer'Image(val)); --display the current consumed integer
				Put("Sum :");
				Put_LIne(Integer'IMage(sum)); --display the total sum so far
			end loop;
		producer.done;
		buffer.done;
		exception
			  when TASKING_ERROR =>
				  Put_Line("Buffer finished before producer");
		Put_Line("Ending the consumer");

	end consumer;
begin
Put_Line(Message);
end comm1;
