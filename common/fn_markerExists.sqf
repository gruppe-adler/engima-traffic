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

private _exists = false;
if (((getMarkerPos _marker) select 0) != 0 || ((getMarkerPos _marker) select 1 != 0)) then {
	_exists = true;
};
_exists
