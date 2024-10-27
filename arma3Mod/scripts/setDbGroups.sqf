_groupName = (_this select 0);
_groupType = (_this select 1);
_groupCommand = (_this select 2);
_groupObjective = (_this select 3);
_groupStatus = (_this select 4);

_inidbi = ["new", databaseName] call OO_INIDBI;

["write", ["Team Status", _groupName, [_groupType, _groupCommand, _groupObjective, _groupStatus]]] call _inidbi;
