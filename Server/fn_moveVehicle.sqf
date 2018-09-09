#define PREFIX engimaTraffic
#define COMPONENT server
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ["_currentInstanceIndex", "_vehicle", ["_firstDestinationPos", []], ["_debug", false]];

// Set fuel to something in between 0.3 and 0.9.
private _fuel = 0.1 + random (0.4);
_vehicle setFuel _fuel;

private _destinationPos = [];
if (count _firstDestinationPos > 0) then {
   _destinationPos pushBack _firstDestinationPos;
}else{
   private _roadSegments = ENGIMA_TRAFFIC_roadSegments select _currentInstanceIndex;
   _destinationSegment = _roadSegments select (floor (random (count _roadSegments)));
   _destinationPos = getPos _destinationSegment;
};

private _speed = "NORMAL";
if (_vehicle distance _destinationPos < 500) then {
   _speed = "LIMITED";
};

private _waypoint = group _vehicle addWaypoint [_destinationPos, 10];
_waypoint setWaypointBehaviour "CARELESS";
_waypoint setWaypointSpeed _speed;
_waypoint setWaypointCompletionRadius 10;
_waypoint setWaypointStatements ["true", "_nil = [" + (str _currentInstanceIndex) + ", " + (vehicleVarName _vehicle) + ", [], " + (str _debug) + "] call enigmaTraffic_fnc_MoveVehicle;"];
