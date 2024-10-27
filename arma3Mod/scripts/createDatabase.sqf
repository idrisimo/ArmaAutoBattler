_playerName = (_this select 0);
_inidbi = ["new", databaseName] call OO_INIDBI;

["write", ["Player Info", "Name", _playerName]] call _inidbi;
