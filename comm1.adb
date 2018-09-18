--Process commnication: Ada lab part 3

with Ada.Calendar;
with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
use Ada.Calendar;
use Ada.Text_IO;

procedure comm1 is
    Message: constant String := "Process communication";
	task buffer is
            -- add your task entries for communication 
	end buffer;

	task producer is
            -- add your task entries for communication  
	end producer;

	task consumer is
            -- add your task entries for communication 
	end consumer;

   task body buffer is -- Cyclic buffer code from https://en.wikibooks.org/wiki/Ada_Programming/Tasking
		Message: constant String := "buffer executing";
      Q_Size : constant := 10;
      subtype Q_Range is Positive range 1 .. Q_Size;
      Length : Natural range 0 .. Q_Size := 0;
      Head, Tail : Q_Range := 1;
      Data : array (Q_Range) of Integer;
      Kill_Flag: Boolean := False;
	begin
		Put_Line(Message);
		loop
	 select
	    when Length < Q_Size =>
	       accept Insert (number : in Integer) do
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
	    Put_Line("buffer was killed");
	    exit;
	 end if;

		end loop;
	end buffer;

	task body producer is 
		Message: constant String := "producer executing";
                -- change/add your local declarations here
	begin
		Put_Line(Message);
		loop
                -- add your task code inside this loop  
		end loop;
	end producer;

	task body consumer is 
		Message: constant String := "consumer executing";
                -- change/add your local declarations here
	begin
		Put_Line(Message);
		Main_Cycle:
		loop 
                -- add your task code inside this loop 
		end loop Main_Cycle; 

                -- add your code to stop executions of other tasks     
		exception
			  when TASKING_ERROR =>
				  Put_Line("Buffer finished before producer");
		Put_Line("Ending the consumer");
	end consumer;
begin
	Put_Line(Message);
end comm1;
