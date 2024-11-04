// initialise global event queue
missionNamespace setVariable ["eventQueue", []];

// Load scripts
[] execVM "scripts\spawn.sqf";
[] execVM "scripts\movementControl.sqf";
[] execVM "events\eventsCreator.sqf";
[] execVM "events\eventHandler.sqf";

// Global variables
databaseName = "database";
bluforGroups = allGroups select {side _x == west};
opforGroups = allGroups select {side _x == east};
playerBase = markerPos "playerSpawnMarker";
enemyBases = [markerPos "enemyBase1", markerPos "enemyBase2", markerPos "enemyBase3" ];
missionNamespace setVariable ["bluforGroups", bluforGroups];
missionNamespace setVariable ["twitchGroups", []];
// initialise global event queue
missionNamespace setVariable ["eventQueue", []];


//Check if database exists
_playerName = name player;
_inidbi = ["new", databaseName] call OO_INIDBI;
// _fileExist = "exists" call _inidbi;
// if(_fileExist) then {
//     hint "File Exists, getting data";
//     // null = [] execVM "scripts\getData.sqf";
//     null = [] execVM "scripts\getDbGroups.sqf";
// } else {
//     hint "File doesn't Exists, creating database";
//     null = [_playerName] execVM "scripts\createDatabase.sqf";
// };

// player addAction ["Spawn Unit", {
//     _groupType = "fireTeam";
//     _groupName = "twitch User";
//     // Call the function to spawn the fire team with a group name
//     _spawnedUnits = [west, _groupType, playerBase, "FORM", _groupName] call spawnUnits;
//     // hint "Group spawned!";
//     // hint _groupName;
// }];

// Polling loop to check for commands
while {true} do {
    [] execVM "scripts\getDbGroups.sqf";
    _bluforGroups = missionNamespace getVariable["bluforGroups", []];
    _twitchGroups = missionNamespace getVariable["twitchGroups", []];
    // hint format ["Twitch Groups: %1", _twitchGroups];
    {    
        _groupName = _x select 0;
        _groupType = _x select 1 select 0;
        _groupCommand = _x select 1 select 1;
        _groupObjective = _x select 1 select 2;
        _groupStatus = _x select 1 select 3;

        _destination = [];

        switch (_groupCommand) do {
            case "joinGame": {
                if !(format ["%1", _groupName] in (bluforGroups apply {groupId _x})) then {
                    _spawnedGroups = [west, _groupType, playerBase, "FORM", _groupName] call spawnUnits;
                    _x set [1,"spawned"];

                    spawnDataTemp = [_groupName, _groupType, "spawned", _groupObjective, _groupStatus];
                } else {
                    hint "Unit exists in db";
                };
            };
            case "attack": {
                // hint "attack Command received";
                if(format ["%1", _groupName] in (bluforGroups apply {groupId _x}) && (_groupStatus != "dead" || _groupStatus != "moving") && _groupObjective != "") then {
                    switch (_groupObjective) do {
                        case "A": {
                            _destination = enemyBases select 0
                        };

                        case "B": {
                            _destination = enemyBases select 1
                        };

                        case "C": {
                            _destination = enemyBases select 2
                        };
                    };
                    // Find the index of the group in bluforGroups
                    _groupIndex = _bluforGroups findIf {groupId _x == _groupName};

                    if (_groupIndex != -1) then {
                        _group = _bluforGroups select _groupIndex;
                        // Now you can use _group in moveCommand
                        _moveCommand = [_group, _destination, "attack"] call moveCommand;
                    } else {
                        hint format ["Group %1 not found in bluforGroups.", _groupName];
                    };
                };
            };

            case "defend": {
              if(format ["%1", _groupName] in (bluforGroups apply {groupId _x}) && (_groupStatus != "dead" || _groupStatus != "moving")) then {
                    _groupIndex = _bluforGroups findIf {groupId _x == _groupName};

                    if (_groupIndex != -1) then {
                        _group = _bluforGroups select _groupIndex;
                        // Now you can use _group in moveCommand
                        _moveCommand = [_group, playerBase, "defend"] call moveCommand;
                    } else {
                        hint format ["Group %1 not found in bluforGroups.", _groupName];
                    };
                };
            };
        };

    } forEach _twitchGroups;

    sleep 1; // Polling interval

    // Execute Event Listeners to detect and publish removeAllEventHandlers
    call compile preprocessFileLineNumbers "events\eventsCreator.sqf";
    
};
