#I've learned these things:
- break a program with control - c.
- use dot product to compare two vectors and see if they're facing to/ away from each other
- preserve triggers set up by WHEN statements using PRESERVE.
- you can use vector exclude to remove vert/ horizontal v component
- use structures to find either direction or vector
- using dot product to check for vectors more than perpendicular to each other


#Research resources
https://www.reddit.com/r/Kos/comments/35nv23/finding_the_ships_current_velocity_vector/
https://www.reddit.com/r/KerbalSpaceProgram/comments/2k3djr/30_kerbals_gave_their_lives_to_make_this_kos/
http://www.samansari.info/2016/01/building-pid-hover-controller-for.html
https://www.reddit.com/r/Kos/comments/31x3o8/kos_launch_script_works_with_any_staging_to_any/
http://www.troyfawkes.com/adventures-in-ksp-kos-math/
https://github.com/eblume/RexTech/blob/master/hover.ks

Snippets of code

SET antenna TO SHIP:PARTSDUBBED("Communotron 16").
FOR ant IN antenna {
    ant:GETMODULE("ModuleRTAntenna"):DOEVENT("ACTIVATE").
}

MODULE
{
	name = ModuleDeployableSolarPanel
	animationName = solarpanels4
	resourceName = ElectricCharge
	chargeRate = 1.64
	retractable = false
}
