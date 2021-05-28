#define PREFIX engimaTraffic
#define COMPONENT debug
#include "\x\cba\addons\main\script_macros_mission.hpp"

/*
 * Summary: Shows debug text on local client.
 * Remarks:
 *   if global variable "dre_var_CL_SilentDebugMode" is set to true, debug text will only be written to RTF-file and not shown on screen.
 * Arguments:
 *   _text: Debug text.
 */

if (!isNull player) then {
   if (!ENGIMA_TRAFFIC_SilentDebugMode) then {
      systemChat (_this select 0);
   };
};

private _minutes = floor (time / 60);
private _seconds = floor (time - (_minutes * 60));
diag_log ((str _minutes + ":" + str _seconds) + " Debug: " + (_this select 0));
