// _databaseName = (_this select 0);

_inidbi = ["new", databaseName] call OO_INIDBI;

//Get  Data
// _teamStatus = ["read", ["Team Status", "Command", []]] call _inidbi;
_getGroupNames = ["getKeys", "Team Status"] call _inidbi;
_twitchGroups = [];

{
	_group = ["read", ["Team Status", _x, []]] call _inidbi;
	_twitchGroups pushBack [_x, _group];
	
} forEach _getGroupNames;


missionNamespace setVariable ["twitchGroups", _twitchGroups];


