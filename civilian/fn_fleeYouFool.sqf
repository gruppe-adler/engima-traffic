#define PREFIX engimaTraffic
#define COMPONENT civilian
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ["_thisUnit"];

deleteWaypoint [group _thisUnit, all];
_thisUnit unassignVehicle (vehicle _thisUnit);
_thisUnit leaveVehicle (vehicle _thisUnit);
_thisUnit disableAI "FSM";

private _buildingPosition = 0;

private _building = nearestObjects [_thisUnit, ["House", "Building"], 100] select 0;
if (!isNull _building) then {
	_buildingPosition = [_building] call BIS_fnc_buildingPositions;
};

private _pos = [];
if (count _buildingPosition > 0) then {
	_pos = [_buildingPosition] call BIS_fnc_selectRandom;
	_thisUnit setBehaviour "SAFE";
	_thisUnit doMove _pos;
	_thisUnit setSpeedMode "FULL";
	_thisUnit forceSpeed 25;
	_thisUnit playMove "AmovPercMevaSnonWnonDf";
	_thisUnit setVariable ["fleeing", "true"];
} else {
	_pos = [_thisUnit,[5,20],random 360] call SHK_pos;
	_thisUnit doMove _pos;
	_thisUnit setSpeedMode "FULL";
	_thisUnit forceSpeed 20;
	_thisUnit playMove "AmovPercMevaSnonWnonDf";
	_thisUnit setVariable ["fleeing", "true"];
};

[{(_this select 0) distance (_this select 1) < 2},{
	params ["_thisUnit"];

	_thisUnit playMoveNow 'AinvPknlMstpSnonWnonDnon_1';
	_thisUnit stop true;
	_thisUnit disableAI "autoTarget";
	_thisUnit disableAI "MOVE";
	_thisUnit removeAllEventHandlers "FiredNear";
},[_thisUnit, _pos]] call CBA_fnc_waitUntilAndExecute;
