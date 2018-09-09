#define PREFIX engimaTraffic
#define COMPONENT config
#include "\x\cba\addons\main\script_macros_mission.hpp"

[] call enigmaTraffic_fnc_initDebug;

ENGIMA_TRAFFIC_instanceIndex = -1;
ENGIMA_TRAFFIC_areaMarkerNames = [];
ENGIMA_TRAFFIC_roadSegments = [];
ENGIMA_TRAFFIC_edgeTopLeftRoads = [];
ENGIMA_TRAFFIC_edgeTopRightRoads = [];
ENGIMA_TRAFFIC_edgeBottomRightRoads = [];
ENGIMA_TRAFFIC_edgeBottomLeftRoads = [];
ENGIMA_TRAFFIC_edgeRoadsUseful = [];
ENGIMA_TRAFFIC_spawnHandler = [];
ENGIMA_TRAFFIC_vehicleSpawnHandler = [];

if (isServer) then {
	[] call enigmaTraffic_fnc_randomCivilian;
	[] call enigmaTraffic_fnc_ConfigAndStart;
};
