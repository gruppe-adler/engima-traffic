#define PREFIX engimaTraffic
#define COMPONENT vehicle
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ["_pos", "_vehicleType", "_side"];

TRACE_3("creating rebel vehicle type %1 at %2 for side %3", _vehicleType, _pos, _side);
_crewCount = floor (random [9, 2, 0] / 3);

private _veh = createVehicle [_vehicleType, _pos, [], 0, "NONE"];
private _group = createGroup _side;

[_group,_veh] call _createDriver;

if (_vehicleType == "RDS_Ikarus_Civ_01" || _vehicleType == "RDS_Ikarus_Civ_02") exitWith {
	private _crewCount = floor (random 5);

	for [{_i=0}, {_i<_crewCount}, {_i=_i+1}] do {
		[_group,_veh] call _createCargo;
	};
	[_veh,_group]
};

if (_crewCount > 0) then {
	for [{_i=0}, {_i<_crewCount}, {_i=_i+1}] do {
		[_group,_veh] call _createCargo;
	};
};

_veh addEventhandler ["HandleDamage",{if ((_this select 4) == "") then {0};}]; // ignore crash damage

[_veh,_group]
