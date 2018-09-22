--Protected types: Ada lab part 4
with Ada.Text_io;
with Ada.Numerics.Float_random;
with Ada.Numerics.Discrete_Random;
with Ada.Calendar;
use Ada.Text_io;
use Ada.Calendar;


procedure comm2 is
	Message: constant String := "Process communication";
        type int_array is array(1..10) of Integer; --creating a type of array to hold 10 Integers
	protected buffer is   --protected  object for the buffer 
		entry push_buff(i : in Integer);
		entry get_buff(i : out Integer);
	private		
		fifo : int_array; --initializing buffer
		length : Integer := 1; --current index position of array
		Fin : Boolean := false; --status of the termination
	end buffer;

	protected body buffer is
					entry push_buff(i : in Integer) when length <= fifo'Length is --buffer can accept integers into FIFO, ONLY if current index of buffer does not exceed the maximum capacity of the buffer
					begin
						fifo(length) := i; --assign the integer "i" to the current index position
						length := length + 1; --increment the current index position
					end push_buff;

				

					entry get_buff(i : out Integer) when length > 1 is --buffer can send out integers only if the current index is not less that the minimum capacity of the buffer 
					begin
						i := fifo(1); --assign the first element of the buffer to the variable
						fifo := fifo(2..10) & 0; --push the buffer elements forward by one and add 0 as the element
						length := length - 1; --decrease the current index position
					end get_buff;
				
	end buffer;
				

	task producer is
		entry done;
	end producer;

	task consumer is
	end consumer;

	task body producer is
		Message: constant String := "Producer executing";
		subtype input_range is Integer range 0..25; --create a package to randomly generate numbers using the subtype
		package random_input is new Ada.Numerics.Discrete_Random(input_range);
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
		Message: constant String := "Consumer executing";
		use Ada.Numerics.Float_random;
		Wait : Duration := 0.0; --delay time
		Sum, Val : Integer := 0; -- sum of the integers taken out by consumer , current integer taken out by consumer
		Gen : Generator;
	begin
		Put_Line(Message);
		Reset(Gen);
		
			while sum < 100 loop --untill the total sum of integers taken out by consumer is less than 100
				Wait := Duration(Random(Gen)); --randomize the wait variable
				delay Wait;
				buffer.get_buff(val); -- call buffer to get the first element of FIFO
				sum := sum + val; --adds all the integers taken out by consumer
				Put("Consumed:");
				Put_Line(Integer'Image(val)); --display the current consumed integer
				Put("Sum :");
				Put_LIne(Integer'IMage(sum)); --display the total sum so far
			end loop;
		
		producer.done;
		
		Put_Line("Ending the consumer");

	end consumer;
begin
Put_Line(Message);
end comm2;
