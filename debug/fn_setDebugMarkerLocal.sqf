#define PREFIX engimaTraffic
#define COMPONENT debug
#include "\x\cba\addons\main\script_macros_mission.hpp"

/*
* Summary: Shows debug marker on local client.
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

if (!isNull player) then {
   if (!ENGIMA_TRAFFIC_SilentDebugMode) then {
      params [
         "_markerName",
         "_position",
         ["_size", 0],
         ["_type", ""],
         ["_direction", 0],
         ["_shape", "ICON"],
         ["_markerColor", "Default"],
         ["_markerText", ""]
      ];

      // Delete old marker
      if ([_markerName] enigmaTraffic_fnc_MarkerExists) then {
         deleteMarkerLocal _markerName;
      };

      // Set new marker
      _marker = createMarkerLocal [_markerName, _position];
      _marker setMarkerShapeLocal _shape;
      _marker setMarkerColorLocal _markerColor;
      _marker setMarkerTextLocal _markerText;

      if (_size > 0) then {
         _marker setMarkerSizeLocal _size;
         _marker setMarkerDirLocal _direction;
      };
      if (_type != "") then {
         _marker setMarkerTypeLocal _type;
      };
   };
};
