#define PREFIX engimaTraffic
#define COMPONENT config
#include "\x\cba\addons\main\script_macros_mission.hpp"

/*
 * Summary: Checks if a marker exists.
 * Arguments:
 *   _marker: Marker name of marker to test.
 * Returns: true if marker exists, else false.
 */

params ["_marker"];

private _markerPos = (getMarkerPos _marker);
if ((_markerPos select 0) != 0 || (_markerPos select 1 != 0)) exitWith {true;};

false
