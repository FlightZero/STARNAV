//gotomun.ks: creates a maneuver node for an orbit which intersects with the mun
//start with 100k circular orbit 
//flightzero

function bodyang
  {
    DECLARE PARAMETER body2.

    SET body1p TO SHIP:position - SHIP:body:position.
    SET body2p TO body2:position - SHIP:body:position.
    SET phaseangle TO ARCTAN2(body1p:x,body1p:z) - ARCTAN2(body2p:x,body2p:z).

    if phaseangle < 0 {
    SET phaseangle TO phaseangle + 360.
    }
    return phaseangle.
  }

function maneuvertime
  {
    DECLARE PARAMETER ang1.
    DECLARE PARAMETER ang2.
    SET degreestogo TO ang1 - ang2.
    if degreestogo < 0
    {
      SET degreestogo TO degreestogo + 360.
    }
    SET mtime TO degreestogo / anglespeed.
    return mtime.
  }

set phase_angle to 90.
set deltaV to 847.

lock actualang to bodyang(mun).

wait 1.
LOCK anglespeed TO 360/SHIP:ORBIT:PERIOD.
set manev to node(time:seconds+maneuvertime(actualang,phase_angle),0,0,deltaV).
add manev.

UNLOCK actualang.
clearscreen.
