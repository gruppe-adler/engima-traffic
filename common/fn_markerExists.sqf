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

(getMarkerPos _marker) params ["_x", "_y"];
(_x != 0 || _y != 0)
