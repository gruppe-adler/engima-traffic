call compile preprocessFileLineNumbers "node_modules\engima-traffic\Common\Common.sqf";
call compile preprocessFileLineNumbers "node_modules\engima-traffic\Common\Debug.sqf";

ENGIMA_TRAFFIC_instanceIndex = -1;
ENGIMA_TRAFFIC_areaMarkerNames = [];
ENGIMA_TRAFFIC_roadSegments = [];
ENGIMA_TRAFFIC_edgeTopLeftRoads = [];
ENGIMA_TRAFFIC_edgeTopRightRoads = [];
ENGIMA_TRAFFIC_edgeBottomRightRoads = [];
ENGIMA_TRAFFIC_edgeBottomLeftRoads = [];
ENGIMA_TRAFFIC_edgeRoadsUseful = [];

if (isServer) then {
	call compile preprocessFileLineNumbers "node_modules\engima-traffic\Server\randomCivilian.sqf";
	call compile preprocessFileLineNumbers "node_modules\engima-traffic\Server\Functions.sqf";
	call compile preprocessFileLineNumbers "node_modules\engima-traffic\ConfigAndStart.sqf";
};
