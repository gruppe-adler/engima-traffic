#define PREFIX engimaTraffic
#define COMPONENT debug
#include "\x\cba\addons\main\script_macros_mission.hpp"

/*
* Summary: Shows debug text on all clients.
* Remarks:
*   if global variable "dre_var_CL_SilentDebugMode" is set to true, debug text will only be written to RTF-file and not shown on screen.
* Arguments:
*   _text: Debug text.
*/

ENGIMA_TRAFFIC_DebugTextEventArgs = _this;
publicVariable "ENGIMA_TRAFFIC_DebugTextEventArgs";
