#define PREFIX engimaTraffic
#define COMPONENT debug
#include "\x\cba\addons\main\script_macros_mission.hpp"

/*
* Summary: Shows debug marker on all clients.
* Remarks:
*   if global variable "ENGIMA_TRAFFIC_SilentDebugMode" is set to true, debug marker will not shown.
* Arguments:
*   _markerName: Marker's name. (must be global unique).
*   _position: Marker's position.
*   [_size]: Optional. Marker's size on array format [x, y].
*   [_type]: Optional. Markers icon type (applies to icons in cfgIcons, like "Warning", "Dot" etc.).
*   [_direction]: Optional. Marker's direction.
*   [_shape]: Optional. "RECTANGLE" or "ELLIPSE".
*   [_markerColor]: Optional. Marker's color ("Default", "ColorRed", "ColorYellow" etc.).
*   [_markerText]: Optional. Marker's text.
*/

ENGIMA_TRAFFIC_DebugMarkerEventArgs = _this;
publicVariable "ENGIMA_TRAFFIC_DebugMarkerEventArgs";
