SET current_script TO "LAND SSTO".


run functionlibrary.

SET runmode TO 1.

SET beacon_1 TO LATLNG(-0.0488, -77.745).//:ALTITUDEPOSITION(10000).
SET beacon_2 TO LATLNG(-0.0488, -74.745).//:ALTITUDEPOSITION(80).

SAS OFF.

UNTIL runmode = 0 {
  //ship loses speed until comes within 100k of beacon 1
  //SET my_position TO SHIP:GEOPOSITION.

  IF runmode = 1 {
    SET current_status TO "DE-ORBIT".

    LOCK STEERING TO HEADING(90, 15).
    IF  beacon_1:DISTANCE < 150000 {
      SET runmode to 2.
    }
  }

  //ship steers to beacon 1 until it's .5 degrees awa (5km)
  IF runmode = 2 {
    SET current_status TO "BEACON 1".
    LOCK STEERING TO beacon_1:ALTITUDEPOSITION(10000).
    IF  ship:GEOPOSITION:LNG > -78 {
      SET runmode TO 3.
    }
  }

  //once it's 5 km away from beacon 1 it locks onto beacon 2
  IF runmode = 3 {
    SET current_status TO "BEACON 2".
    LOCK STEERING TO beacon_2:ALTITUDEPOSITION(80).
    IF  beacon_2:DISTANCE < 1000 {
      SET runmode TO 0.
    }
  }


f_info_screen().
}

SAS ON.
