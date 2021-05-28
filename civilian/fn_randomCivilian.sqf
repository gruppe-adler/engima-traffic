#define PREFIX engimaTraffic
#define COMPONENT civilian
#include "\x\cba\addons\main\script_macros_mission.hpp"

// civ units made from rhs or rds

params ["_unit"];

private _rds_rhs_civilian = [
	"rds_uniform_Worker1",
	"rds_uniform_Worker2",
	"rds_uniform_Worker3",
	"rds_uniform_Worker4",
	"rds_uniform_Woodlander1",
	"rds_uniform_Woodlander2",
	"rds_uniform_Woodlander3",
	"rds_uniform_Woodlander4",
	"rds_uniform_Villager1",
	"rds_uniform_Villager2",
	"rds_uniform_Villager3",
	"rds_uniform_Villager4",
	"rds_uniform_Profiteer1",
	"rds_uniform_Profiteer2",
	"rds_uniform_Profiteer3",
	"rds_uniform_Profiteer4",
	"rds_uniform_citizen1",
	"rds_uniform_citizen2",
	"rds_uniform_citizen3",
	"rds_uniform_citizen4"
] call BIS_fnc_selectRandom;

private _rhsHeadGear = [
	"rds_Villager_cap1",
	"rds_Villager_cap2",
	"rds_Villager_cap3",
	"rds_Villager_cap4",
	"rds_worker_cap1",
	"rds_worker_cap2",
	"rds_worker_cap3",
	"rds_worker_cap4",
	"rds_Profiteer_cap1",
	"rds_Profiteer_cap2",
	"rds_Profiteer_cap3",
	"rds_Profiteer_cap4",
	"rhs_beanie_green",
	"rhs_beanie_green"
] call BIS_fnc_selectRandom;

private _taliFaces = [
	"PersianHead_A3_01",
	"PersianHead_A3_02",
	"PersianHead_A3_03",
	"PersianHead_A3_01",
	"PersianHead_A3_02",
	"PersianHead_A3_03",
	"PersianHead_A3_01",
	"PersianHead_A3_02",
	"PersianHead_A3_03",
	"WhiteHead_08",
	"WhiteHead_16",
	"GreekHead_A3_01",
	"GreekHead_A3_02",
	"GreekHead_A3_03",
	"GreekHead_A3_04"
] call BIS_fnc_selectRandom;

private _reclotheHim = {
	params ["_unit"];
	_unit forceAddUniform _rds_rhs_civilian;
	if (random 2 > 1) then {
		_unit addHeadgear _rhsHeadGear;
	};

	[[_unit,_taliFaces], "setCustomFace"] call BIS_fnc_MP;
	_unit setVariable ["BIS_noCoreConversations", true];

};

private _addBehaviour = {
	group (_this select 0) setBehaviour "CARELESS";
	(_this select 0) disableAI "TARGET";
	(_this select 0) disableAI "AUTOTARGET";
};

private _addKilledNews = {
	(_this select 0) addEventhandler ["Killed",{
		params ["_unit"];

		CIV_KILLED_POS = (position _unit);
		INFO_1("civ killed at %1", CIV_KILLED_POS);
		publicVariableServer "CIV_KILLED_POS";
		_unit removeAllEventHandlers "Killed";
		_unit removeAllEventHandlers "FiredNear";
	}];
};

private _addGunfightNews = {
	(_this select 0) addEventhandler ["FiredNear",{
		params ["_unit"];

		CIV_GUNFIGHT_POS = (position _unit);
		INFO_1("civ gunfight at %1",CIV_GUNFIGHT_POS);
		publicVariableServer "CIV_GUNFIGHT_POS";
	}];
};

[_unit] call _stripHim;
[_unit] call _reclotheHim;
//if (false) then {[_unit] call enigmaTraffic_fnc_addFleeingBehaviour;};
[_unit] call _addKilledNews;
[_unit] call _addGunfightNews;
[_unit] call _addBehaviour;

{
	[_unit] call _x;
} forEach ENGIMA_TRAFFIC_spawnHandler;
