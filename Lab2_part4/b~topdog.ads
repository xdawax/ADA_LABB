pragma Ada_95;
pragma Restrictions (No_Exception_Propagation);
with System;
package ada_main is
   pragma Warnings (Off);


   GNAT_Version : constant String :=
                    "GNAT Version: GPL 2011 (20110428)" & ASCII.NUL;
   pragma Export (C, GNAT_Version, "__gnat_version");

   Ada_Main_Program_Name : constant String := "_ada_topdog" & ASCII.NUL;
   pragma Export (C, Ada_Main_Program_Name, "__gnat_ada_main_program_name");

   procedure adainit;
   pragma Export (C, adainit, "adainit");

   procedure main;
   pragma Export (C, main, "main");

   type Version_32 is mod 2 ** 32;
   u00001 : constant Version_32 := 16#29b26195#;
   pragma Export (C, u00001, "topdogB");
   u00002 : constant Version_32 := 16#992eb3bf#;
   pragma Export (C, u00002, "systemS");
   u00003 : constant Version_32 := 16#7c7898e1#;
   pragma Export (C, u00003, "system__taskingB");
   u00004 : constant Version_32 := 16#4b51b3c3#;
   pragma Export (C, u00004, "system__taskingS");
   u00005 : constant Version_32 := 16#2969216a#;
   pragma Export (C, u00005, "ada__exceptionsB");
   u00006 : constant Version_32 := 16#a322b89c#;
   pragma Export (C, u00006, "ada__exceptionsS");
   u00007 : constant Version_32 := 16#3ffc8e18#;
   pragma Export (C, u00007, "adaS");
   u00008 : constant Version_32 := 16#1f8fe6cf#;
   pragma Export (C, u00008, "system__secondary_stackB");
   u00009 : constant Version_32 := 16#86d4835f#;
   pragma Export (C, u00009, "system__secondary_stackS");
   u00010 : constant Version_32 := 16#ace32e1e#;
   pragma Export (C, u00010, "system__storage_elementsB");
   u00011 : constant Version_32 := 16#63e3ce27#;
   pragma Export (C, u00011, "system__storage_elementsS");
   u00012 : constant Version_32 := 16#18acd9c1#;
   pragma Export (C, u00012, "system__task_primitivesS");
   u00013 : constant Version_32 := 16#382f73be#;
   pragma Export (C, u00013, "system__os_interfaceS");
   u00014 : constant Version_32 := 16#1119db69#;
   pragma Export (C, u00014, "system__bbS");
   u00015 : constant Version_32 := 16#778c4164#;
   pragma Export (C, u00015, "system__bb__cpu_primitivesB");
   u00016 : constant Version_32 := 16#9991d030#;
   pragma Export (C, u00016, "system__bb__cpu_primitivesS");
   u00017 : constant Version_32 := 16#f77d8799#;
   pragma Export (C, u00017, "interfacesS");
   u00018 : constant Version_32 := 16#b72cff6b#;
   pragma Export (C, u00018, "system__bb__interruptsB");
   u00019 : constant Version_32 := 16#f888868e#;
   pragma Export (C, u00019, "system__bb__interruptsS");
   u00020 : constant Version_32 := 16#32b67a3e#;
   pragma Export (C, u00020, "system__bb__peripheralsB");
   u00021 : constant Version_32 := 16#b4e93ed4#;
   pragma Export (C, u00021, "system__bb__peripheralsS");
   u00022 : constant Version_32 := 16#3b51c473#;
   pragma Export (C, u00022, "system__bb__peripherals__registersS");
   u00023 : constant Version_32 := 16#ffab4c5e#;
   pragma Export (C, u00023, "system__bb__timeB");
   u00024 : constant Version_32 := 16#223e6a59#;
   pragma Export (C, u00024, "system__bb__timeS");
   u00025 : constant Version_32 := 16#e6f25001#;
   pragma Export (C, u00025, "system__bb__protectionB");
   u00026 : constant Version_32 := 16#7cbd1653#;
   pragma Export (C, u00026, "system__bb__protectionS");
   u00027 : constant Version_32 := 16#d8852a92#;
   pragma Export (C, u00027, "system__bb__parametersS");
   u00028 : constant Version_32 := 16#fa422e1c#;
   pragma Export (C, u00028, "system__parametersB");
   u00029 : constant Version_32 := 16#6a39f7b6#;
   pragma Export (C, u00029, "system__parametersS");
   u00030 : constant Version_32 := 16#8a83f044#;
   pragma Export (C, u00030, "system__bb__threadsB");
   u00031 : constant Version_32 := 16#860b8c39#;
   pragma Export (C, u00031, "system__bb__threadsS");
   u00032 : constant Version_32 := 16#f22a3c08#;
   pragma Export (C, u00032, "system__bb__cpu_primitives__multiprocessorsB");
   u00033 : constant Version_32 := 16#6425a019#;
   pragma Export (C, u00033, "system__bb__cpu_primitives__multiprocessorsS");
   u00034 : constant Version_32 := 16#5a83c3a4#;
   pragma Export (C, u00034, "system__multiprocessorsB");
   u00035 : constant Version_32 := 16#3378c65f#;
   pragma Export (C, u00035, "system__multiprocessorsS");
   u00036 : constant Version_32 := 16#9d58bd70#;
   pragma Export (C, u00036, "system__bb__threads__queuesB");
   u00037 : constant Version_32 := 16#12e64875#;
   pragma Export (C, u00037, "system__bb__threads__queuesS");
   u00038 : constant Version_32 := 16#a3316520#;
   pragma Export (C, u00038, "system__machine_codeS");
   u00039 : constant Version_32 := 16#6d4c1c8f#;
   pragma Export (C, u00039, "system__task_primitives__operationsB");
   u00040 : constant Version_32 := 16#cfc7d8c8#;
   pragma Export (C, u00040, "system__task_primitives__operationsS");
   u00041 : constant Version_32 := 16#0f8eba36#;
   pragma Export (C, u00041, "system__tasking__debugB");
   u00042 : constant Version_32 := 16#a54f0737#;
   pragma Export (C, u00042, "system__tasking__debugS");
   u00043 : constant Version_32 := 16#81c6b8c3#;
   pragma Export (C, u00043, "system__task_infoB");
   u00044 : constant Version_32 := 16#780e5185#;
   pragma Export (C, u00044, "system__task_infoS");
   u00045 : constant Version_32 := 16#e7ea76c3#;
   pragma Export (C, u00045, "tasksB");
   u00046 : constant Version_32 := 16#46bb62a5#;
   pragma Export (C, u00046, "tasksS");
   u00047 : constant Version_32 := 16#e86c1dfa#;
   pragma Export (C, u00047, "ada__real_timeB");
   u00048 : constant Version_32 := 16#91d158a6#;
   pragma Export (C, u00048, "ada__real_timeS");
   u00049 : constant Version_32 := 16#4a32d090#;
   pragma Export (C, u00049, "ada__real_time__delaysB");
   u00050 : constant Version_32 := 16#1a269a20#;
   pragma Export (C, u00050, "ada__real_time__delaysS");
   u00051 : constant Version_32 := 16#8f4db7ab#;
   pragma Export (C, u00051, "ada__tagsB");
   u00052 : constant Version_32 := 16#7d87ad71#;
   pragma Export (C, u00052, "ada__tagsS");
   u00053 : constant Version_32 := 16#83d5bf36#;
   pragma Export (C, u00053, "nxtS");
   u00054 : constant Version_32 := 16#e08e359a#;
   pragma Export (C, u00054, "nxt__audioB");
   u00055 : constant Version_32 := 16#985c6395#;
   pragma Export (C, u00055, "nxt__audioS");
   u00056 : constant Version_32 := 16#a34e0368#;
   pragma Export (C, u00056, "ada__interruptsB");
   u00057 : constant Version_32 := 16#4d3b525e#;
   pragma Export (C, u00057, "ada__interruptsS");
   u00058 : constant Version_32 := 16#4eb204d9#;
   pragma Export (C, u00058, "system__interruptsB");
   u00059 : constant Version_32 := 16#1cafa429#;
   pragma Export (C, u00059, "system__interruptsS");
   u00060 : constant Version_32 := 16#26fcb789#;
   pragma Export (C, u00060, "system__tasking__protected_objectsB");
   u00061 : constant Version_32 := 16#01119edd#;
   pragma Export (C, u00061, "system__tasking__protected_objectsS");
   u00062 : constant Version_32 := 16#c756dd86#;
   pragma Export (C, u00062, "system__multiprocessors__fair_locksB");
   u00063 : constant Version_32 := 16#a70e2885#;
   pragma Export (C, u00063, "system__multiprocessors__fair_locksS");
   u00064 : constant Version_32 := 16#d677746a#;
   pragma Export (C, u00064, "system__multiprocessors__spin_locksB");
   u00065 : constant Version_32 := 16#9ac42bf1#;
   pragma Export (C, u00065, "system__multiprocessors__spin_locksS");
   u00066 : constant Version_32 := 16#b6ebc047#;
   pragma Export (C, u00066, "system__tasking__protected_objects__single_entryB");
   u00067 : constant Version_32 := 16#7097dccb#;
   pragma Export (C, u00067, "system__tasking__protected_objects__single_entryS");
   u00068 : constant Version_32 := 16#3cbe35c1#;
   pragma Export (C, u00068, "system__tasking__protected_objects__multiprocessorsB");
   u00069 : constant Version_32 := 16#c1a39b31#;
   pragma Export (C, u00069, "system__tasking__protected_objects__multiprocessorsS");
   u00070 : constant Version_32 := 16#9a2971e5#;
   pragma Export (C, u00070, "nxt__registersS");
   u00071 : constant Version_32 := 16#0e90d289#;
   pragma Export (C, u00071, "nxt__avrB");
   u00072 : constant Version_32 := 16#5188d06d#;
   pragma Export (C, u00072, "nxt__avrS");
   u00073 : constant Version_32 := 16#45b86ba4#;
   pragma Export (C, u00073, "memory_compareB");
   u00074 : constant Version_32 := 16#e0f49698#;
   pragma Export (C, u00074, "memory_compareS");
   u00075 : constant Version_32 := 16#1a6835fd#;
   pragma Export (C, u00075, "interfaces__cS");
   u00076 : constant Version_32 := 16#786699ab#;
   pragma Export (C, u00076, "nxt__avr_ioB");
   u00077 : constant Version_32 := 16#b1ea2849#;
   pragma Export (C, u00077, "nxt__avr_ioS");
   u00078 : constant Version_32 := 16#409bd207#;
   pragma Export (C, u00078, "memory_setB");
   u00079 : constant Version_32 := 16#7080a1fd#;
   pragma Export (C, u00079, "memory_setS");
   u00080 : constant Version_32 := 16#6dd26f90#;
   pragma Export (C, u00080, "nxt__twiB");
   u00081 : constant Version_32 := 16#e60ae324#;
   pragma Export (C, u00081, "nxt__twiS");
   u00082 : constant Version_32 := 16#58f15b4f#;
   pragma Export (C, u00082, "nxt__displayB");
   u00083 : constant Version_32 := 16#eea91930#;
   pragma Export (C, u00083, "nxt__displayS");
   u00084 : constant Version_32 := 16#16b8005d#;
   pragma Export (C, u00084, "memory_copyB");
   u00085 : constant Version_32 := 16#73d25d3a#;
   pragma Export (C, u00085, "memory_copyS");
   u00086 : constant Version_32 := 16#d4c47034#;
   pragma Export (C, u00086, "nxt__fontsS");
   u00087 : constant Version_32 := 16#d787cbce#;
   pragma Export (C, u00087, "nxt__lcdB");
   u00088 : constant Version_32 := 16#62dc0da3#;
   pragma Export (C, u00088, "nxt__lcdS");
   u00089 : constant Version_32 := 16#4bb72c55#;
   pragma Export (C, u00089, "nxt__spiB");
   u00090 : constant Version_32 := 16#262f2953#;
   pragma Export (C, u00090, "nxt__spiS");
   u00091 : constant Version_32 := 16#f3cfefc9#;
   pragma Export (C, u00091, "system__unsigned_typesS");
   u00092 : constant Version_32 := 16#f50a157d#;
   pragma Export (C, u00092, "nxt__buffersB");
   u00093 : constant Version_32 := 16#f35e19ee#;
   pragma Export (C, u00093, "nxt__buffersS");
   u00094 : constant Version_32 := 16#c4edeed9#;
   pragma Export (C, u00094, "nxt__filteringB");
   u00095 : constant Version_32 := 16#8a6760e4#;
   pragma Export (C, u00095, "nxt__filteringS");
   u00096 : constant Version_32 := 16#7ba88584#;
   pragma Export (C, u00096, "nxt__prioritiesS");
   u00097 : constant Version_32 := 16#84062552#;
   pragma Export (C, u00097, "system__tasking__restricted__stagesB");
   u00098 : constant Version_32 := 16#a30a7965#;
   pragma Export (C, u00098, "system__tasking__restricted__stagesS");
   u00099 : constant Version_32 := 16#328f4145#;
   pragma Export (C, u00099, "system__tasking__restrictedS");
   u00100 : constant Version_32 := 16#442901a5#;
   pragma Export (C, u00100, "nxt__light_sensorsB");
   u00101 : constant Version_32 := 16#8207fff8#;
   pragma Export (C, u00101, "nxt__light_sensorsS");
   u00102 : constant Version_32 := 16#af47268a#;
   pragma Export (C, u00102, "nxt__sensor_portsB");
   u00103 : constant Version_32 := 16#724aa67d#;
   pragma Export (C, u00103, "nxt__sensor_portsS");
   u00104 : constant Version_32 := 16#b2029ba5#;
   pragma Export (C, u00104, "nxt__motor_controlsB");
   u00105 : constant Version_32 := 16#8c809e3a#;
   pragma Export (C, u00105, "nxt__motor_controlsS");
   u00106 : constant Version_32 := 16#8adf3c9a#;
   pragma Export (C, u00106, "nxt__motorsB");
   u00107 : constant Version_32 := 16#f4a25ca9#;
   pragma Export (C, u00107, "nxt__motorsS");
   u00108 : constant Version_32 := 16#e1e1e51f#;
   pragma Export (C, u00108, "nxt__motors__simpleB");
   u00109 : constant Version_32 := 16#bac5158f#;
   pragma Export (C, u00109, "nxt__motors__simpleS");
   u00110 : constant Version_32 := 16#6e1c09a2#;
   pragma Export (C, u00110, "nxt__motor_encodersB");
   u00111 : constant Version_32 := 16#09fe6156#;
   pragma Export (C, u00111, "nxt__motor_encodersS");
   u00112 : constant Version_32 := 16#88e39f3d#;
   pragma Export (C, u00112, "nxt__motors__simple__ctorsB");
   u00113 : constant Version_32 := 16#0f613bb8#;
   pragma Export (C, u00113, "nxt__motors__simple__ctorsS");
   u00114 : constant Version_32 := 16#c349bf0f#;
   pragma Export (C, u00114, "nxt__mallocB");
   u00115 : constant Version_32 := 16#538443b2#;
   pragma Export (C, u00115, "nxt__mallocS");
   u00116 : constant Version_32 := 16#25180f97#;
   pragma Export (C, u00116, "nxt__touch_sensorsB");
   u00117 : constant Version_32 := 16#1318e71f#;
   pragma Export (C, u00117, "nxt__touch_sensorsS");
   u00118 : constant Version_32 := 16#191b33a6#;
   pragma Export (C, u00118, "nxt__ultrasonic_sensorsB");
   u00119 : constant Version_32 := 16#a5443bf2#;
   pragma Export (C, u00119, "nxt__ultrasonic_sensorsS");
   u00120 : constant Version_32 := 16#c6de9c19#;
   pragma Export (C, u00120, "nxt__i2c_portsB");
   u00121 : constant Version_32 := 16#5d527c43#;
   pragma Export (C, u00121, "nxt__i2c_portsS");
   u00122 : constant Version_32 := 16#71ddaece#;
   pragma Export (C, u00122, "nxt__i2c_sensorsB");
   u00123 : constant Version_32 := 16#ffe62913#;
   pragma Export (C, u00123, "nxt__i2c_sensorsS");
   u00124 : constant Version_32 := 16#7fdef4cf#;
   pragma Export (C, u00124, "nxt__light_sensors__ctorsB");
   u00125 : constant Version_32 := 16#76d576fe#;
   pragma Export (C, u00125, "nxt__light_sensors__ctorsS");
   u00126 : constant Version_32 := 16#7640d288#;
   pragma Export (C, u00126, "nxt__ultrasonic_sensors__ctorsB");
   u00127 : constant Version_32 := 16#411e6594#;
   pragma Export (C, u00127, "nxt__ultrasonic_sensors__ctorsS");
   --  BEGIN ELABORATION ORDER
   --  ada%s
   --  interfaces%s
   --  interfaces.c%s
   --  system%s
   --  ada.exceptions%s
   --  ada.exceptions%b
   --  system.bb%s
   --  system.bb.protection%s
   --  system.machine_code%s
   --  system.parameters%s
   --  system.parameters%b
   --  system.storage_elements%s
   --  system.storage_elements%b
   --  ada.tags%s
   --  system.bb.parameters%s
   --  system.bb.cpu_primitives%s
   --  system.bb.peripherals%s
   --  system.bb.peripherals.registers%s
   --  system.bb.interrupts%s
   --  system.multiprocessors%s
   --  system.multiprocessors%b
   --  system.bb.cpu_primitives.multiprocessors%s
   --  system.bb.cpu_primitives.multiprocessors%b
   --  system.bb.time%s
   --  system.bb.peripherals%b
   --  system.bb.threads%s
   --  system.bb.threads.queues%s
   --  system.bb.threads.queues%b
   --  system.bb.threads%b
   --  system.bb.interrupts%b
   --  system.bb.time%b
   --  system.bb.cpu_primitives%b
   --  system.bb.protection%b
   --  system.multiprocessors.spin_locks%s
   --  system.multiprocessors.spin_locks%b
   --  system.multiprocessors.fair_locks%s
   --  system.os_interface%s
   --  system.multiprocessors.fair_locks%b
   --  system.task_info%s
   --  system.task_info%b
   --  system.task_primitives%s
   --  system.tasking%s
   --  system.task_primitives.operations%s
   --  system.tasking.debug%s
   --  system.tasking.debug%b
   --  system.task_primitives.operations%b
   --  system.unsigned_types%s
   --  ada.real_time%s
   --  ada.real_time%b
   --  ada.real_time.delays%s
   --  ada.real_time.delays%b
   --  system.secondary_stack%s
   --  system.tasking%b
   --  ada.tags%b
   --  system.secondary_stack%b
   --  system.tasking.protected_objects%s
   --  system.tasking.protected_objects%b
   --  system.tasking.protected_objects.multiprocessors%s
   --  system.tasking.protected_objects.multiprocessors%b
   --  system.tasking.protected_objects.single_entry%s
   --  system.tasking.protected_objects.single_entry%b
   --  system.interrupts%s
   --  system.interrupts%b
   --  ada.interrupts%s
   --  ada.interrupts%b
   --  system.tasking.restricted%s
   --  system.tasking.restricted.stages%s
   --  system.tasking.restricted.stages%b
   --  memory_compare%s
   --  memory_compare%b
   --  memory_copy%s
   --  memory_copy%b
   --  memory_set%s
   --  memory_set%b
   --  nxt%s
   --  nxt.malloc%s
   --  nxt.malloc%b
   --  nxt.registers%s
   --  nxt.audio%s
   --  nxt.audio%b
   --  nxt.avr_io%s
   --  nxt.buffers%s
   --  nxt.buffers%b
   --  nxt.display%s
   --  nxt.filtering%s
   --  nxt.filtering%b
   --  nxt.lcd%s
   --  nxt.fonts%s
   --  nxt.motor_controls%s
   --  nxt.motor_encoders%s
   --  nxt.motor_encoders%b
   --  nxt.priorities%s
   --  nxt.spi%s
   --  nxt.spi%b
   --  nxt.lcd%b
   --  nxt.display%b
   --  nxt.twi%s
   --  nxt.twi%b
   --  nxt.avr_io%b
   --  nxt.avr%s
   --  nxt.avr%b
   --  nxt.motor_controls%b
   --  nxt.motors%s
   --  nxt.motors%b
   --  nxt.motors.simple%s
   --  nxt.motors.simple%b
   --  nxt.motors.simple.ctors%s
   --  nxt.motors.simple.ctors%b
   --  nxt.sensor_ports%s
   --  nxt.sensor_ports%b
   --  nxt.i2c_ports%s
   --  nxt.i2c_ports%b
   --  nxt.i2c_sensors%s
   --  nxt.i2c_sensors%b
   --  nxt.light_sensors%s
   --  nxt.light_sensors%b
   --  nxt.light_sensors.ctors%s
   --  nxt.light_sensors.ctors%b
   --  nxt.touch_sensors%s
   --  nxt.touch_sensors%b
   --  nxt.ultrasonic_sensors%s
   --  nxt.ultrasonic_sensors%b
   --  nxt.ultrasonic_sensors.ctors%s
   --  nxt.ultrasonic_sensors.ctors%b
   --  tasks%s
   --  tasks%b
   --  topdog%b
   --  END ELABORATION ORDER


end ada_main;
