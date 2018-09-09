#define PREFIX engimaTraffic
#define COMPONENT vehicle
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ["_grp", "_car"];

private _crewDriver = _grp createUnit ["C_man_1", _pos, [], 0, "CARGO"];

[_crewDriver] call randomCivilian; // rebel loadout
[_crewDriver, _car, true] call ACE_VehicleLock_fnc_addKeyForVehicle;
_car setFuel 0.1;

_crewDriver assignAsDriver _car;
_crewDriver moveInDriver _car;
[{_this select 0 action ["lightOn", _this select 1]},[_car, _crewDriver],0.1] call CBA_fnc_waitAndExecute;;
// hintsilent format ["ordered %1 to enter %2", _crewDriver,_car];
