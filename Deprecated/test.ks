//testing directions vs vectors

SET nd to nextnode.
//ADD nextnode.

print "    ship:facing is " + ship:facing.
print " node direction is " + nd:deltav:direction.
print "node vector mag is " + nd:deltav:mag.

set ship_facing to ship:facing.
set node_direction to nd:deltav:direction.
//SET node_vector TO nd:deltav.


print " attempt to manipulate: " + (node_direction - ship_facing).
print "            curve test: " + 1 / ( 1 + (CONSTANT:E ^ (-0.05 * ( nd:deltav:mag - 100)))).



PRINT " original node vector: " + node_vector.
PRINT "  current node vector: " + nd:deltav.
PRINT "          dot product: " + VDOT(nd:deltav, node_vector).
