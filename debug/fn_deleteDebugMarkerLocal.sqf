#define PREFIX engimaTraffic
#define COMPONENT debug
#include "\x\cba\addons\main\script_macros_mission.hpp"

/*
 * Summary: Deletes a debug marker on local client.
 * Arguments:
 *   _markerName: Name of marker to delete.
 */

params ["_markerName"];

deleteMarkerLocal _markerName;
