#define PREFIX engimaTraffic
#define COMPONENT config
#include "\x\cba\addons\main\script_macros_mission.hpp"

// EDIT: fuck that shit. now we're doing a re-usable library, configuration should be done via mission config
/*
 * This file contains parameters to config and function call to start an instance of
 * traffic in the mission. The file is edited by the mission developer.
 *
 * See file Engima\Traffic\Documentation.txt for documentation and a full reference of
 * how to customize and use Engima's Traffic.
 */

 private ["_parameters"];

 private _vehicleSets = [] call CBA_fnc_hashCreate;

 [_vehicleSets, "A3", [
    "C_Offroad_01_F",
    "C_Offroad_01_repair_F",
    "C_Hatchback_01_F",
    "C_Hatchback_01_sport_F",
    "C_SUV_01_F",
    "C_Van_01_transport_F",
    "C_Van_01_box_F",
    "C_Van_01_fuel_F",

    "C_Truck_02_fuel_F",
    "C_Truck_02_box_F"
 ]] call CBA_fnc_hashSet;

 [_vehicleSets, "RHS_GREF", [
    "RHS_Ural_Civ_01",
    "RHS_Ural_Civ_02",
    "RHS_Ural_Civ_03",
    "RHS_Ural_Open_Civ_01",
    "RHS_Ural_Open_Civ_02",
    "RHS_Ural_Open_Civ_03"
 ]] call CBA_fnc_hashSet;

 [_vehicleSets, "RDS_CIV", [
    "RDS_Gaz24_Civ_01",
    "RDS_Gaz24_Civ_02",
    "RDS_Gaz24_Civ_03",
    "RDS_Gaz24_Civ_01",
    "RDS_Gaz24_Civ_02",
    "RDS_Gaz24_Civ_03",
    "RDS_Gaz24_Civ_01",
    "RDS_Gaz24_Civ_02",
    "RDS_Gaz24_Civ_03",

    "RDS_Ikarus_Civ_01",
    "RDS_Ikarus_Civ_02",
    "RDS_Ikarus_Civ_02",

    "RDS_S1203_Civ_01",
    "RDS_S1203_Civ_02",
    "RDS_S1203_Civ_03",

    "RDS_Octavia_Civ_01",

    "RDS_Lada_Civ_01",
    "RDS_Lada_Civ_02",
    "RDS_Lada_Civ_03",

    "RDS_Lada_Civ_05",
    "RDS_Lada_Civ_01",
    "RDS_Lada_Civ_02",
    "RDS_Lada_Civ_03",

    "RDS_Zetor6945_Base"
 ]] call CBA_fnc_hashSet;

private _getEngimaConfigValue = {
    private _key = param [0, ""];
    private _default = param [1];

    [
        _key,
        [(missionConfigFile >> "EngimaTraffic"), _key, _default] call BIS_fnc_returnConfigEntry
    ];
};

private _vehicleSetNames = [(missionConfigFile >> "EngimaTraffic"), "vehicleSets", ["A3"]] call BIS_fnc_returnConfigEntry;
private _vehicleClasses = [];

{
    _vehicleClasses = _vehicleClasses + ([_vehicleSets, _x] call CBA_fnc_HashGet);
} forEach _vehicleSetNames;

TRACE_1("using vehicle classes %1", _vehicleClasses);

// Start an instance of the traffic
([[
    ["VEHICLES", _vehicleClasses] call _getEngimaConfigValue,
    ["SIDE", civilian] call _getEngimaConfigValue,
    ["VEHICLES_COUNT", 10] call _getEngimaConfigValue,
    ["MIN_SPAWN_DISTANCE", 800] call _getEngimaConfigValue,
    ["MAX_SPAWN_DISTANCE", 1200] call _getEngimaConfigValue,
    ["MIN_SKILL", 0.3] call _getEngimaConfigValue,
    ["MAX_SKILL", 0.7] call _getEngimaConfigValue,
    ["AREA_MARKER", ""] call _getEngimaConfigValue,
    ["HIDE_AREA_MARKER", true] call _getEngimaConfigValue,
    ["ON_SPAWN_CALLBACK", {}] call _getEngimaConfigValue,
    ["ON_REMOVE_CALLBACK", {}] call _getEngimaConfigValue,
    ["DEBUG", false] call _getEngimaConfigValue
]] call CBA_fnc_hashCreate) spawn ENGIMA_TRAFFIC_StartTraffic;
