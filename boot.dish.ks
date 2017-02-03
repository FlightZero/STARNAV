//boot.dish.ks: sets a dish to follow a target
//by FlightZero, based on code by u/space_is_hard
//to use this code, build an antenna structure of parts in the following order:
// 1. a rotatron, 2. a hinge and 3. a kOS cpu core 4. desired antenna.
//tag the rotatron and hinge "rotate" and "hinge," respectively.
// tag the cpu core to the target you'd like to track. target can be re-assigned on the fly.
//the script will continually reverse the part's direction if the error is getting larger, until it
// is centered on the target within one degree.


local rotate_servo to ship:partstagged("rotate").
local hinge_servo to ship:partstagged("hinge").

set startv to true.

function startbeep {
	SET V0 TO GETVOICE(0).
	V0:PLAY(
	  LIST(
	    NOTE("c4",  0.1,  0.2),
	    NOTE("f4",  0.1,  0.2),
	    NOTE("a4",  0.1,  0.2),
	    NOTE("f5",  0.1,  0.25)
	  )
	).
}

function errorbeep {
	SET V0 TO GETVOICE(0).
	V0:PLAY(
	  LIST(
	    NOTE("c6",  0.1,  0.2),
			NOTE("",  0.1,  0.1),
			NOTE("c6",  0.1,  0.2),
			NOTE("",  0.1,  0.1),
	    NOTE("c6",  0.1,  0.3)
	  )
	).
}

set servos to addons:ir:allservos.
for s in servos
{
	if (s:part:tag = "rotate")
	{
		set rotate_servo to s.
	}
		if (s:part:tag = "hinge")
	{
		set hinge_servo to s.
	}
}


//u/gisikw
function orbitable {
    parameter name.

    local count to 0.
    local vessels to list().
    list targets in vessels.
    for vs in vessels {
        if vs:name = name {
            return vessel(name).
            break.

        } else {
            set count to count + 1.

        }.

    }.

    if count = vessels:length {
        return body(name).
    }.

}.

//Sets target to core's part tag
LOCAL pointing_target TO ORBITABLE(CORE:PART:TAG).

function switchdir {
  local parameter movedir.
    if movedir = movehingeleft@ {set movedir to movehingeright@.}
    else if movedir = movehingeright@ {set movedir to movehingeleft@.}
    else if movedir = moverotateleft@ {set movedir to moverotateright@.}
    else if movedir = moverotateright@ {set movedir to moverotateleft@.}
  return movedir.
}

function movehingeleft {
  hinge_servo:moveleft().
}

function movehingeright {
  hinge_servo:moveright().
}

function moverotateleft {
  rotate_servo:moveleft().
}

function moverotateright {
  rotate_servo:moveright().
}

function start {
	if startv = true {
		set movediry to moverotateright@.
		set movedirx to movehingeright@.
		set rotate_servo:speed to 0.2.
		set hinge_servo:speed to 0.2.

		set startv to false.
	}
}

function track {
	set rotate_servo:speed to 0.1.
	set hinge_servo:speed to 0.1.
  if y_ang > 1 {
		set y_0 to y_ang.
		wait 0.1.
		update.
		if y_0 < y_ang {
			set movediry to switchdir(movediry).
			movediry().
		}
  } else {rotate_servo:stop().}
	if x_ang > 1 {
		set x_0 to x_ang.
		wait 0.1.
		update.
		if x_0 < x_ang {
			set movedirx to switchdir(movedirx).
			movedirx().
		}
		if hinge_servo:position > 179.5 {
			clearscreen.
			print "TARGET BELOW DISH HORIZON. REPOSITION".
			//errorbeep().
			wait 1.
		}
	} else {hinge_servo:stop().}

}

function update {
set point_vector to -pointing_target:position - core:part:position.
//set tgtarrow to vecdraw(core:part:position, -point_vector,red,"tgt",1,true,0.1).

set pointing_target to orbitable(core:part:tag).
set y_ang to vang(rotate_servo:part:facing:topvector:normalized, vxcl(rotate_servo:part:facing:forevector,point_vector):normalized).

set x_ang to vang(-hinge_servo:part:facing:topvector:normalized,point_vector).

clearscreen.
print "Y AXIS: " + round(y_ang,4).

print "X AXIS: " + round(x_ang,4).

}

startbeep().
until false {
	//clearvecdraws().
  update().
	start().
  track().
}
