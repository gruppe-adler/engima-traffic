#define PREFIX engimaTraffic
#define COMPONENT civilian
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ["_unit"];
_unit setVariable ["enigmaTraffic_fleeing",false];

_unit addEventHandler ["FiredNear", {
   params ["_thisUnit"];
   if (_thisUnit getVariable ["enigmaTraffic_fleeing", false]) exitWith {};
   [{
      {
         [_x] call enigmaTraffic_fnc_fleeYouFool;
      } forEach crew (vehicle _this);
   },_thisUnit,(random 1)] call CBA_fnc_waitAndExecute;

}];
