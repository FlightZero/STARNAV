//launch_ssto.ks: land a capable craft from orbit to surface
//created and shared under the MIT License by FlightZero.
SET start_time TO TIME:SECONDS.
LOG TIME:SECONDS - start_time to launchtime.
LOCK THROTTLE TO 1.
BRAKES OFF.
STAGE.
LOCK STEERING TO HEADING(90,35).
WHEN ALTITUDE > 80 THEN
{
  GEAR OFF.
}
WAIT UNTIL APOAPSIS > 71000.
UNTIL ALTITUDE > 65000 {
  LOCK THROTTLE TO 0.
  IF APOAPSIS < 71000 {
    LOCK THROTTLE TO 1.
  }
}
RUN circ.
LOG TIME:SECONDS - start_time to launchtime.
PANELS ON.
SET antenna TO SHIP:PARTSDUBBED("Communotron 16").
FOR ant IN antenna {
    ant:GETMODULE("ModuleRTAntenna"):DOEVENT("ACTIVATE").
}
SAS ON.
lock throttle to 0.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
unlock throttle.
unlock steering.
