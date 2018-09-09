#define PREFIX engimaTraffic
#define COMPONENT config
#include "\x\cba\addons\main\script_macros_mission.hpp"

/*
 * Summary: Checks if a position is inside a marker.
 * Remarks: Marker can be of shape "RECTANGLE" or "ELLIPSE" and at any angle.
 * Arguments:
 *   _markerName: Name of current marker.
 *   _pos: Position to test.
 * Returns: true if position is inside marker. Else false.
 */

params ["_pos", "_markerName"];
_pos params ["_px", "_py"];
(getMarkerPos _markerName) params ["_mpx", "_mpy"];
(getMarkerSize _markerName) params ["_msx", "_msy"];
private _ma = -(markerDir _markerName);

private _xmin = _mpx - _msx;
private _xmax = _mpx + _msx;
private _ymin = _mpy - _msy;
private _ymax = _mpy + _msy;

//Now, rotate point to investigate around markers center in order to check against a nonrotated marker
private _rpx = ( (_px - _mpx) * cos(_ma) ) + ( (_py - _mpy) * sin(_ma) ) + _mpx;
private _rpy = (-(_px - _mpx) * sin(_ma) ) + ( (_py - _mpy) * cos(_ma) ) + _mpy;

private	_isInside = false;

if ((markerShape _markerName) == "RECTANGLE") then {
	if (((_rpx > _xmin) && (_rpx < _xmax)) && ((_rpy > _ymin) && (_rpy < _ymax))) then	{
		_isInside = true;
	};
};

if ((markerShape _markerName) == "ELLIPSE") then {
	if ((((_rpx-_mpx)^2)/(_msx^2)) + (((_rpy-_mpy)^2)/(_msy^2)) < 1 ) then	{
		_isInside = true;
	};
};

_isInside
