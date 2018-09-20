#define PREFIX engimaTraffic
#define COMPONENT civilian
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ["_unit"];
removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeAllContainers _unit;
removeHeadgear _unit;
removeGoggles _unit;
