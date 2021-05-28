#define PREFIX engimaTraffic
#define COMPONENT server
#include "\x\cba\addons\main\script_macros_mission.hpp"

private _worldTrigger = call BIS_fnc_worldArea;
private _worldSize = triggerArea _worldTrigger;
private _mapTopLeftPos = [0, 2 * (_worldSize select 1)];
private _mapTopRightPos = [2 * (_worldSize select 0), 2 * (_worldSize select 1)];
private _mapBottomRightPos = [2 * (_worldSize select 0), 0];
private _mapBottomLeftPos = [0, 0];

ENGIMA_TRAFFIC_minTopLeftDistances = [];
ENGIMA_TRAFFIC_minTopRightDistances = [];
ENGIMA_TRAFFIC_minBottomRightDistances = [];
ENGIMA_TRAFFIC_minBottomLeftDistances = [];

for "_i" from 0 to ENGIMA_TRAFFIC_instanceIndex do {
   ENGIMA_TRAFFIC_minTopLeftDistances pushBack 1000000;
   ENGIMA_TRAFFIC_minTopRightDistances pushBack 1000000;
   ENGIMA_TRAFFIC_minBottomRightDistances pushBack 1000000;
   ENGIMA_TRAFFIC_minBottomLeftDistances pushBack 1000000;
};

ENGIMA_TRAFFIC_allRoadSegments = [0,0,0] nearRoads 1000000;
[{
   TRACE_1("ENGIMA found %1 road segments.", (count ENGIMA_TRAFFIC_allRoadSegments));

   // Find all edge road segments
   [{
      params ["_args", "_handle"];
      _args params ["_mapTopLeftPos", "_mapTopRightPos", "_mapBottomLeftPos", "_mapBottomRightPos"];

      if ((count ENGIMA_TRAFFIC_allRoadSegments) == 0) exitWith {
         [_handle] call CBA_fnc_removePerFrameHandler;

         ENGIMA_TRAFFIC_minTopLeftDistances = nil;
         ENGIMA_TRAFFIC_minTopRightDistances = nil;
         ENGIMA_TRAFFIC_minBottomRightDistances = nil;
         ENGIMA_TRAFFIC_minBottomLeftDistances = nil;

         ENGIMA_TRAFFIC_edgeRoadsInitialized = true;
         publicVariable "ENGIMA_TRAFFIC_edgeRoadsInitialized";
         INFO("................ENGIMA_TRAFFIC_edgeRoadsInitialized................");
      };


      private _road = ENGIMA_TRAFFIC_allRoadSegments select 0;
      private _roadPos = getPos _road;
      private _index = 0;

      // Top left
      while {_index <= ENGIMA_TRAFFIC_instanceIndex} do {
         private _markerName = ENGIMA_TRAFFIC_areaMarkerNames select _index; // Get the marker name for the current instance

         private _insideMarker = true;
         if (_markerName != "") then {
            _insideMarker = [_roadPos, _markerName] enigmaTraffic_fnc_PositionIsInsideMarker;
         };

         if (_insideMarker) then {
            // Top left
            if (_roadPos distance _mapTopLeftPos < (ENGIMA_TRAFFIC_minTopLeftDistances select _index)) then {
               ENGIMA_TRAFFIC_minTopLeftDistances set [_index, _roadPos distance _mapTopLeftPos];
               ENGIMA_TRAFFIC_edgeTopLeftRoads set [_index, _road];
            };

            // Top right
            if (_roadPos distance _mapTopRightPos < (ENGIMA_TRAFFIC_minTopRightDistances select _index)) then {
               ENGIMA_TRAFFIC_minTopRightDistances set [_index, _roadPos distance _mapTopRightPos];
               ENGIMA_TRAFFIC_edgeTopRightRoads set [_index, _road];
            };

            // Bottom right
            if (_roadPos distance _mapBottomRightPos < (ENGIMA_TRAFFIC_minBottomRightDistances select _index)) then {
            ENGIMA_TRAFFIC_minBottomRightDistances set [_index, _roadPos distance _mapBottomRightPos];
            ENGIMA_TRAFFIC_edgeBottomRightRoads set [_index, _road];
            };

            // Bottom left
            if (_roadPos distance _mapBottomLeftPos < (ENGIMA_TRAFFIC_minBottomLeftDistances select _index)) then {
            ENGIMA_TRAFFIC_minBottomLeftDistances set [_index, _roadPos distance _mapBottomLeftPos];
            ENGIMA_TRAFFIC_edgeBottomLeftRoads set [_index, _road];
            };

            if (!(ENGIMA_TRAFFIC_edgeRoadsUseful select _index)) then {
            ENGIMA_TRAFFIC_edgeRoadsUseful set [_index, true];
            };
         };

         _index = _index + 1;
      };

      for "_i" from 0 to 50 do {
         if ((count ENGIMA_TRAFFIC_allRoadSegments) <= 0) exitWith {};
         ENGIMA_TRAFFIC_allRoadSegments deleteAt 0;
      };
   },_this,0] call CBA_fnc_addPerFrameHandler;
},[_mapTopLeftPos, _mapTopRightPos, _mapBottomLeftPos, _mapBottomRightPos],0.1] call CBA_fnc_waitAndExecute;
