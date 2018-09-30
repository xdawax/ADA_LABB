pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b~topdog.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b~topdog.adb");

package body ada_main is
   pragma Warnings (Off);

   E019 : Short_Integer; pragma Import (Ada, E019, "system__bb__interrupts_E");
   E048 : Short_Integer; pragma Import (Ada, E048, "ada__real_time_E");
   E061 : Short_Integer; pragma Import (Ada, E061, "system__tasking__protected_objects_E");
   E069 : Short_Integer; pragma Import (Ada, E069, "system__tasking__protected_objects__multiprocessors_E");
   E098 : Short_Integer; pragma Import (Ada, E098, "system__tasking__restricted__stages_E");
   E055 : Short_Integer; pragma Import (Ada, E055, "nxt__audio_E");
   E077 : Short_Integer; pragma Import (Ada, E077, "nxt__avr_io_E");
   E083 : Short_Integer; pragma Import (Ada, E083, "nxt__display_E");
   E095 : Short_Integer; pragma Import (Ada, E095, "nxt__filtering_E");
   E088 : Short_Integer; pragma Import (Ada, E088, "nxt__lcd_E");
   E105 : Short_Integer; pragma Import (Ada, E105, "nxt__motor_controls_E");
   E111 : Short_Integer; pragma Import (Ada, E111, "nxt__motor_encoders_E");
   E090 : Short_Integer; pragma Import (Ada, E090, "nxt__spi_E");
   E081 : Short_Integer; pragma Import (Ada, E081, "nxt__twi_E");
   E072 : Short_Integer; pragma Import (Ada, E072, "nxt__avr_E");
   E109 : Short_Integer; pragma Import (Ada, E109, "nxt__motors__simple_E");
   E113 : Short_Integer; pragma Import (Ada, E113, "nxt__motors__simple__ctors_E");
   E103 : Short_Integer; pragma Import (Ada, E103, "nxt__sensor_ports_E");
   E121 : Short_Integer; pragma Import (Ada, E121, "nxt__i2c_ports_E");
   E119 : Short_Integer; pragma Import (Ada, E119, "nxt__ultrasonic_sensors_E");
   E127 : Short_Integer; pragma Import (Ada, E127, "nxt__ultrasonic_sensors__ctors_E");
   E046 : Short_Integer; pragma Import (Ada, E046, "tasks_E");

   Is_Elaborated : Boolean := False;

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");

   begin
      Main_Priority := 0;

      System.Bb.Interrupts'Elab_Body;
      E019 := E019 + 1;
      Ada.Real_Time'Elab_Spec;
      Ada.Real_Time'Elab_Body;
      E048 := E048 + 1;
      System.Tasking.Protected_Objects'Elab_Body;
      E061 := E061 + 1;
      System.Tasking.Protected_Objects.Multiprocessors'Elab_Body;
      E069 := E069 + 1;
      System.Tasking.Restricted.Stages'Elab_Body;
      E098 := E098 + 1;
      NXT.AUDIO'ELAB_BODY;
      E055 := E055 + 1;
      E095 := E095 + 1;
      NXT.MOTOR_ENCODERS'ELAB_BODY;
      E111 := E111 + 1;
      NXT.SPI'ELAB_BODY;
      E090 := E090 + 1;
      E088 := E088 + 1;
      NXT.DISPLAY'ELAB_BODY;
      E083 := E083 + 1;
      NXT.TWI'ELAB_BODY;
      E081 := E081 + 1;
      E077 := E077 + 1;
      NXT.AVR'ELAB_BODY;
      E072 := E072 + 1;
      E105 := E105 + 1;
      E109 := E109 + 1;
      E113 := E113 + 1;
      NXT.SENSOR_PORTS'ELAB_SPEC;
      E103 := E103 + 1;
      NXT.I2C_PORTS'ELAB_BODY;
      E121 := E121 + 1;
      NXT.ULTRASONIC_SENSORS'ELAB_SPEC;
      E119 := E119 + 1;
      E127 := E127 + 1;
      Tasks'Elab_Spec;
      Tasks'Elab_Body;
      E046 := E046 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_topdog");

   procedure main is
      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      adainit;
      Ada_Main_Program;
   end;

--  BEGIN Object file/option list
   --   ./ada.o
   --   ./interfac.o
   --   ./i-c.o
   --   ./system.o
   --   ./a-except.o
   --   ./s-bb.o
   --   ./s-maccod.o
   --   ./s-parame.o
   --   ./s-stoele.o
   --   ./s-bbpara.o
   --   ./s-bbpere.o
   --   ./s-multip.o
   --   ./s-bcprmu.o
   --   ./s-bbperi.o
   --   ./s-bbthqu.o
   --   ./s-bbthre.o
   --   ./s-bbinte.o
   --   ./s-bbtime.o
   --   ./s-bbcppr.o
   --   ./s-bbprot.o
   --   ./s-musplo.o
   --   ./s-osinte.o
   --   ./s-mufalo.o
   --   ./s-tasinf.o
   --   ./s-taspri.o
   --   ./s-tasdeb.o
   --   ./s-taprop.o
   --   ./s-unstyp.o
   --   ./a-reatim.o
   --   ./a-retide.o
   --   ./s-taskin.o
   --   ./a-tags.o
   --   ./s-secsta.o
   --   ./s-taprob.o
   --   ./s-tpobmu.o
   --   ./s-tposen.o
   --   ./s-interr.o
   --   ./a-interr.o
   --   ./s-tasres.o
   --   ./s-tarest.o
   --   ./memory_compare.o
   --   ./memory_copy.o
   --   ./memory_set.o
   --   ./nxt.o
   --   ./nxt-malloc.o
   --   ./nxt-registers.o
   --   ./nxt-audio.o
   --   ./nxt-buffers.o
   --   ./nxt-filtering.o
   --   ./nxt-fonts.o
   --   ./nxt-motor_encoders.o
   --   ./nxt-priorities.o
   --   ./nxt-spi.o
   --   ./nxt-lcd.o
   --   ./nxt-display.o
   --   ./nxt-twi.o
   --   ./nxt-avr_io.o
   --   ./nxt-avr.o
   --   ./nxt-motor_controls.o
   --   ./nxt-motors.o
   --   ./nxt-motors-simple.o
   --   ./nxt-motors-simple-ctors.o
   --   ./nxt-sensor_ports.o
   --   ./nxt-i2c_ports.o
   --   ./nxt-i2c_sensors.o
   --   ./nxt-light_sensors.o
   --   ./nxt-light_sensors-ctors.o
   --   ./nxt-touch_sensors.o
   --   ./nxt-ultrasonic_sensors.o
   --   ./nxt-ultrasonic_sensors-ctors.o
   --   ./tasks.o
   --   ./topdog.o
   --   -L./
   --   -L/home/lego/Documents/gnatmindstorms2011/lib/gcc/arm-eabi/4.5.3/rts-ravenscar-sfp/adalib/
   --   -static
   --   -lgnarl
   --   -lgnat
--  END Object file/option list   

end ada_main;
