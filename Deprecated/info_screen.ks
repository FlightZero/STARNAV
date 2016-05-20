
DECLARE FUNCTION info_screen {
  DECLARE PARAMETER c_message IS "INIT".
  CLEARSCREEN.
  PRINT "STATUS: " + c_message.
  WAIT 0.
}
