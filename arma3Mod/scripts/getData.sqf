// _databaseName = (_this select 0);

_inidbi = ["new", databaseName] call OO_INIDBI;

//Get command Data
_twitchCommand = ["read", ["Viewer Command", "Command", []]] call _inidbi;

armaCommand = _twitchCommand;

