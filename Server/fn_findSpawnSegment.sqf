#define PREFIX engimaTraffic
#define COMPONENT server
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ["_currentInstanceIndex", "_allPlayerPositions", "_minSpawnDistance", "_maxSpawnDistance", "_activeVehiclesAndGroup"];

private _spawnDistanceDiff = _maxSpawnDistance - _minSpawnDistance;
private _roadSegment = "NULL";
private _refPlayerPos = (_allPlayerPositions selectRandom _allPlayerPositions);
private _areaMarkerName = ENGIMA_TRAFFIC_areaMarkerNames select _currentInstanceIndex;

private _isOk = false;
private _tries = 0;
while {!_isOk && _tries < 10} do {
   _isOk = true;

   private _dir = random 360;

   private _refPosX = (_refPlayerPos select 0) + (_minSpawnDistance + _spawnDistanceDiff / 2) * sin _dir;
   private _refPosY = (_refPlayerPos select 1) + (_minSpawnDistance + _spawnDistanceDiff / 2) * cos _dir;

   private _roadSegments = [_refPosX, _refPosY] nearRoads (_spawnDistanceDiff / 2);

   if (count _roadSegments > 0) then {
      private _roadSegment = _roadSegments selectRandom _roadSegments;

      // Check if road segment is ok
      private _tooFarAwayFromAll = true;
      private _tooClose = false;
      private _insideMarker = true;
      private _tooCloseToAnotherVehicle = false;

      if (_areaMarkerName != "" && !([getPos _roadSegment, _areaMarkerName] enigmaTraffic_fnc_PositionIsInsideMarker)) then {
         _insideMarker = false;
      };

      if (_insideMarker) then {
         {
            private _tooFarAway = false;

            if (_x distance (getPos _roadSegment) < _minSpawnDistance) then {
               _tooClose = true;
            };
            if (_x distance (getPos _roadSegment) > _maxSpawnDistance) then {
               _tooFarAway = true;
            };
            if (!_tooFarAway) then {
               _tooFarAwayFromAll = false;
            };

            sleep 0.01;
         } foreach _allPlayerPositions;

         {
            _x params ["_vehicle"];

            if ((getPos _roadSegment) distance _vehicle < 100) then {
               _tooCloseToAnotherVehicle = true;
            };

            sleep 0.01;
         } foreach _activeVehiclesAndGroup;
      };

      _isOk = true;

      if (_tooClose || _tooFarAwayFromAll || _tooCloseToAnotherVehicle || !_insideMarker) then {
         _isOk = false;
         _tries = _tries + 1;
      };
   }else{
      _isOk = false;
      _tries = _tries + 1;
   };

   sleep 0.1;
};

if (!_isOk) then {
   _result = "NULL";
}
else {
   _result = _roadSegment;
};

_result
