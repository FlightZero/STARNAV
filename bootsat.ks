//bootsat.ks: comms sat init and station keeping
//created and shared under the MIT License by FlightZero
SET num_processors to 0.
UNTIL num_processors = 1 {
  SET num_processors to 0.
  LIST PROCESSORS IN processor_list.
  FOR pro IN processor_list {
      SET num_processors TO num_processors + 1.
  }
  //PRINT num_processors.
  WAIT 2.
  //get target_period from handoff file
}
LOCK STEERING TO PROGRADE.
//circularize at AP
//if ORBIT:PERIOD is less than target_period
//rcs forward until ORBIT:PERIOD is greater than or equal to target_period
