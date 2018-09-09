#define PREFIX engimaTraffic
#define COMPONENT vehicle
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ["_grp", "_car"];

private _crewCargo = _grp createUnit ["C_man_1", _pos, [], 0, "CARGO"];
_crewCargo disableAI "FSM";

[_crewCargo] call randomCivilian; // rebel loadout

_crewCargo assignAsCargo _car;
_crewCargo moveInCargo _car;
