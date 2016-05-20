//boot.ks: a boot script which loads scripts into a craft
//created and shared under the MIT License by FlightZero


CLEARSCREEN.
COPY functionlibrary from 0.
COPY launch_to from 0.
COPY donode from 0.
COPY node_peri from 0.
COPY node_apo from 0.
COPY circ from 0.
COPY land from 0.
RUN functionlibrary.
SET current_script TO "BOOT build 7".
SET current_status TO "BOOTED".

PRINT "  _____ _______       _____  _   _     __      __".
PRINT " / ____|__   __|/\   |  __ \| \ | |   /\ \    / /".
PRINT "| (___    | |  /  \  | |__) |  \| |  /  \ \  / / ".
PRINT " \___ \   | | / /\ \ |  _  /| . ` | / /\ \ \/ /  ".
PRINT " ____) |  | |/ ____ \| | \ \| |\  |/ ____ \  /   ".
PRINT "|_____/   |_/_/    \_\_|  \_\_| \_/_/    \_\/    ".
PRINT "                                                 ".
PRINT "             v 0.1 FlightZero 2016               ".
WAIT 1.
f_info_screen().
