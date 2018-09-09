#define PREFIX engimaTraffic
#define COMPONENT server
#include "\x\cba\addons\main\script_macros_mission.hpp"

if (!isServer) exitWith {};

private _side = [_this, "SIDE"] call CBA_fnc_hashGet;
private _possibleVehicles = [_this, "VEHICLES"] call CBA_fnc_hashGet;
private _vehicleCount = [_this, "VEHICLES_COUNT"] call CBA_fnc_hashGet;
private _minSpawnDistance = [_this, "MIN_SPAWN_DISTANCE"] call CBA_fnc_hashGet;
private _maxSpawnDistance = [_this, "MAX_SPAWN_DISTANCE"] call CBA_fnc_hashGet;
private _minSkill = [_this, "MIN_SKILL"] call CBA_fnc_hashGet;
private _maxSkill = [_this, "MAX_SKILL"] call CBA_fnc_hashGet;
private _areaMarkerName = [_this, "AREA_MARKER"] call CBA_fnc_hashGet;
private _hideAreaMarker = [_this, "HIDE_AREA_MARKER"] call CBA_fnc_hashGet;
private _fnc_OnSpawnVehicle = [_this, "ON_SPAWN_CALLBACK"] call CBA_fnc_hashGet;
private _fnc_OnRemoveVehicle = [_this, "ON_REMOVE_CALLBACK"] call CBA_fnc_hashGet;
private _debug = [_this, "DEBUG"] call CBA_fnc_hashGet;

if (_areaMarkerName != "" && _hideAreaMarker) then {
   _areaMarkerName setMarkerAlpha 0;
};

ENGIMA_TRAFFIC_instanceIndex = ENGIMA_TRAFFIC_instanceIndex + 1;
private _currentInstanceIndex = ENGIMA_TRAFFIC_instanceIndex;

ENGIMA_TRAFFIC_areaMarkerNames set [_currentInstanceIndex, _areaMarkerName];
ENGIMA_TRAFFIC_edgeRoadsUseful set [_currentInstanceIndex, false];
ENGIMA_TRAFFIC_roadSegments set [_currentInstanceIndex, []];

private _activeVehiclesAndGroup = [];

[] call enigmaTraffic_fnc_FindEdgeRoads;

[{ENGIMA_TRAFFIC_edgeRoadsUseful select (_this select 0)},{
   [{
      params ["_args", "_handle"];
      _args params [
         "_currentInstanceIndex",
         "_side",
         "_possibleVehicle",
         "_vehicleCount",
         "_minSpawnDistance",
         "_maxSpawnDistance",
         "_minSkill",
         "_maxSkill",
         "_areaMarkerName",
         "_hideAreaMarker",
         "_fnc_OnSpawnVehicle",
         "_fnc_OnRemoveVehicle",
         "_debug"
      ];

      private _allPlayerPositionsTemp = [];
      if (isMultiplayer) then {
         {
            if (isPlayer _x) then {
               _allPlayerPositionsTemp = _allPlayerPositionsTemp + [position vehicle _x];
            };
         } foreach (playableUnits);
      }else{
         _allPlayerPositionsTemp = [position vehicle player];
      };

      if (count _allPlayerPositionsTemp > 0) then {
         _allPlayerPositions = _allPlayerPositionsTemp;
      } else {
         _allPlayerPositions = [0,0,0];
      };

      // If there are few vehicles, add a vehicle
      if (_areaMarkerName == "") then {
         _correctedVehicleCount = _vehicleCount;
      }else{
         _markerSize = getMarkerSize _areaMarkerName;
         _avgMarkerRadius = ((_markerSize select 0) + (_markerSize select 1)) / 2;

         if (_avgMarkerRadius > _maxSpawnDistance) then {
            _correctedVehicleCount = floor (_vehicleCount / 2);
            _coveredShare = 0;

            {
               _restDistance = _maxSpawnDistance - ((_x distance getMarkerPos _areaMarkerName) - _avgMarkerRadius);
               _coveredAreaShare = _restDistance / (_maxSpawnDistance * 2);
               if (_coveredAreaShare > _coveredShare) then {
               _coveredShare = _coveredAreaShare;
               };
            } foreach (_allPlayerPositions);

            _correctedVehicleCount = floor (_vehicleCount * _coveredShare);
         }else{
            _correctedVehicleCount = _vehicleCount;
         };
      };

      _tries = 0;
      while {count _activeVehiclesAndGroup < _correctedVehicleCount && _tries < 1} do {

         // Get all spawn positions within range
         if (_firstIteration) then {
            _minDistance = 300;

            if (_minDistance > _maxSpawnDistance) then {
               _minDistance = 0;
            };
         }else{
            _minDistance = _minSpawnDistance;
         };

         _spawnSegment = [_currentInstanceIndex, _allPlayerPositions, _minDistance, _maxSpawnDistance, _activeVehiclesAndGroup] call enigmaTraffic_fnc_findSpawnSegment;

         // If there were spawn positions
         if (str _spawnSegment != """NULL""") then {

            // Get first destination
            _trafficLocation = floor random 5;
            switch (_trafficLocation) do {
               case 0: {_roadSegments = (getPos (ENGIMA_TRAFFIC_edgeBottomLeftRoads select _currentInstanceIndex)) nearRoads 100;};
               case 1: {_roadSegments = (getPos (ENGIMA_TRAFFIC_edgeTopLeftRoads select _currentInstanceIndex)) nearRoads 100;};
               case 2: {_roadSegments = (getPos (ENGIMA_TRAFFIC_edgeTopRightRoads select _currentInstanceIndex)) nearRoads 100;};
               case 3: {_roadSegments = (getPos (ENGIMA_TRAFFIC_edgeBottomRightRoads select _currentInstanceIndex)) nearRoads 100;};
               default {_roadSegments = ENGIMA_TRAFFIC_roadSegments select _currentInstanceIndex};
            };

            private _destinationSegment = _roadSegments select (floor (random (count _roadSegments)));
            private _destinationPos = getPos _destinationSegment;

            private _direction = ((_destinationPos select 0) - (getPos _spawnSegment select 0)) atan2 ((_destinationPos select 1) - (getposATL _spawnSegment select 1));
            private _roadSegmentDirection = getDir _spawnSegment;

            if ((_roadSegmentDirection < 0) || (_roadSegmentDirection > 360)) then {
               _roadSegmentDirection = _roadSegmentDirection mod 360;
            };

            if ((_direction < 0) || (_direction > 360)) {
               _direction = _direction mod 360;
            };

            private _testDirection = _direction - _roadSegmentDirection;

            if ((_testDirection < 0) || (_testDirection > 360)) {
               _testDirection = _testDirection mod 360;
            };

            if (_testDirection > 90 && _testDirection < 270) then {
               _direction = _roadSegmentDirection + 180;
            }
            else {
               _direction = _roadSegmentDirection;
            };

            (getPos _spawnSegment) params ["_posX", "_posY"];

            _posX = _posX + 2.5 * sin (_direction + 90);
            _posY = _posY + 2.5 * cos (_direction + 90);
            private _pos = [_posX, _posY, 0];

            // Create vehicle
            private _vehicleType = _possibleVehicles select (floor (random (count _possibleVehicles)));

            // Run spawn script and attach handle to vehicle
            private _vehicleArray = [_pos,_vehicleType,_side] call enigmaTraffic_fnc_createRebelVehicle;
            _vehicleArray params ["_vehicle", "_vehicleGroup"];
            INFO_1("enigmaTraffic: vehicle is %1", _vehicle);

            {[_vehicle] call _x;} forEach enigmaTraffic_fnc_vehicleSpawnHandler;

            private _vehiclesCrew = units _vehicleGroup;
            // Array - 0: created vehicle (Object), 1: all crew (Array of Objects), 2: vehicle's group (Group)
            private _result = [_vehicle, _vehiclesCrew, _vehicleGroup];

            // Name vehicle
            if (isNil "enigmaTraffic_MilitaryTraffic_CurrentEntityNo") then {
               enigmaTraffic_MilitaryTraffic_CurrentEntityNo = 0
            };

            _currentEntityNo = enigmaTraffic_MilitaryTraffic_CurrentEntityNo;
            enigmaTraffic_MilitaryTraffic_CurrentEntityNo = enigmaTraffic_MilitaryTraffic_CurrentEntityNo + 1;

            _vehicleVarName = "enigmaTraffic_MilitaryTraffic_Entity_" + str _currentEntityNo;
            _vehicle setVehicleVarName _vehicleVarName;
            _vehicle call compile format ["%1=_this;", _vehicleVarName];

            // Set crew skill
            {
               _skill = _minSkill + random (_maxSkill - _minSkill);
               _x setSkill _skill;
            } foreach _vehiclesCrew;

            _debugMarkerName = "enigmaTraffic_MilitaryTraffic__DebugMarker" + str _currentEntityNo;

            // Start vehicle
            [_currentInstanceIndex, _vehicle, _destinationPos, _debug] spawn ENGIMA_TRAFFIC_MoveVehicle;
            _activeVehiclesAndGroup pushBack [_vehicle, _vehicleGroup, _vehiclesCrew, _debugMarkerName];

            // Run spawn script and attach handle to vehicle
            _vehicle setVariable ["enigmaTraffic_scriptHandle", _result spawn _fnc_OnSpawnVehicle];
         };

         _tries = _tries + 1;
      };

      _firstIteration = false;

      // If any vehicle is too far away, delete it
      private _tempVehiclesAndGroup = [];
      private _deletedVehiclesCount = 0;
      {
         _x params ["_vehicle", "_group", "_crewUnits", "_debugMarkerName"];
         _closestUnitDistance = 1000000;

         {
            _distance = (_x distance _vehicle);
            if (_distance < _closestUnitDistance) then {
               _closestUnitDistance = _distance;
            };
         } foreach _allPlayerPositions;

         if (_closestUnitDistance < _maxSpawnDistance) then {
            _tempVehiclesAndGroup pushBack _x;
         }else{
            // Run callback before deleting
            _vehicle call _fnc_OnRemoveVehicle;

            // Delete crew
            {
               deleteVehicle _x;
            } foreach _crewUnits;

            // Terminate script before deleting the vehicle
            _scriptHandle = _vehicle getVariable "enigmaTraffic_scriptHandle";
            if (!(scriptDone _scriptHandle)) then {
               waitUntil {scriptDone _scriptHandle};
            };

            deleteVehicle _vehicle;
            deleteGroup _group;

            [_debugMarkerName] enigmaTraffic_fnc_DeleteDebugMarkerAllClients;
            _deletedVehiclesCount = _deletedVehiclesCount + 1;
         };

         sleep 0.01;
      } foreach _activeVehiclesAndGroup;

      _activeVehiclesAndGroup = _tempVehiclesAndGroup;

      // Do nothing but update debug markers for X seconds
      if (_debug) then {
         for "_i" from 1 to _sleepSeconds do {
            {
               _x params ["_vehicle", "_group", "", "_debugMarkerName"]
               _side = side _group;

               private _debugMarkerColor = switch (_side) do {
                  case west : {"ColorBlue"};
                  case east : {"ColorRed"};
                  case civilian : {"ColorYellow"};
                  case resistance : {"ColorGreen"};
                  default {"Default"};
               };
               [_debugMarkerName, (getPos _vehicle), 0, "mil_dot", 0, "ICON", _debugMarkerColor, "Traffic"] enigmaTraffic_fnc_SetDebugMarkerAllClients;

            } foreach _activeVehiclesAndGroup;
         };
      };
   },_this,0,5] call CBA_fnc_waitAndExecute;
},[
   _currentInstanceIndex,
   _side,
   _possibleVehicle,
   _vehicleCount,
   _minSpawnDistance,
   _maxSpawnDistance,
   _minSkill,
   _maxSkill,
   _areaMarkerName,
   _hideAreaMarker,
   _fnc_OnSpawnVehicle,
   _fnc_OnRemoveVehicle,
   _debug
],5] call CBA_fnc_waitUntilAndExecute;
