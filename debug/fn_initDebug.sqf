#define PREFIX engimaTraffic
#define COMPONENT debug
#include "\x\cba\addons\main\script_macros_mission.hpp"

ENGIMA_TRAFFIC_SilentDebugMode = false;

ENGIMA_TRAFFIC_DebugTextEventArgs = []; // Empty
ENGIMA_TRAFFIC_DebugMarkerEventArgs = []; // [name, position, size, direction, shape ("RECTANGLE" or "ELLIPSE"), markerColor, markerText (optional)] or alternatively [name, position, type, markerColor (optional), markerText (optional)]
ENGIMA_TRAFFIC_DeleteDebugMarkerEventArgs = [];  // [name]

"ENGIMA_TRAFFIC_DebugTextEventArgs" addPublicVariableEventHandler {
    ENGIMA_TRAFFIC_DebugTextEventArgs enigmaTraffic_fnc_ShowDebugTextLocal;
};

"ENGIMA_TRAFFIC_DebugMarkerEventArgs" addPublicVariableEventHandler {
    ENGIMA_TRAFFIC_DebugMarkerEventArgs enigmaTraffic_fnc_SetDebugMarkerLocal;
};

"ENGIMA_TRAFFIC_DeleteDebugMarkerEventArgs" addPublicVariableEventHandler {
    ENGIMA_TRAFFIC_DeleteDebugMarkerEventArgs enigmaTraffic_fnc_deleteDebugMarkerLocal;
};
