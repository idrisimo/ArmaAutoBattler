

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
missionNamespace setVariable ["bluforGroups", bluforGroups];
missionNamespace setVariable ["twitchGroups", []];
// initialise global event queue
missionNamespace setVariable ["eventQueue", []];


//Check if database exists
_playerName = name player;
_inidbi = ["new", databaseName] call OO_INIDBI;
_fileExist = "exists" call _inidbi;
if(_fileExist) then {
    hint "File Exists, getting data";
    // null = [] execVM "scripts\getData.sqf";
    null = [] execVM "scripts\getDbGroups.sqf";
} else {
    hint "File doesn't Exists, creating database";
    null = [_playerName] execVM "scripts\createDatabase.sqf";
};

player addAction ["Spawn Unit", {
    _groupType = "fireTeam";
    _groupName = "twitch User";
    // Call the function to spawn the fire team with a group name
    _spawnedUnits = [west, _groupType, playerBase, "FORM", _groupName] call spawnUnits;
    // hint "Group spawned!";
    // hint _groupName;
}];

// Polling loop to check for commands
while {true} do {
    _bluforGroups = missionNamespace getVariable["bluforGroups", []];
    _bluforGroupIdArray = [];
    {
        _bluforGroupIdArray pushback (groupId _x)
    } forEach _bluforGroups;

    _twitchGroups = missionNamespace getVariable["twitchGroups", []];
    // hint format ["Group: %1", _twitchGroups];
    {    
        _groupName = _x select 0;
        _groupType = _x select 1 select 0;
        _groupCommand = _x select 1 select 1;
        _groupObjective = _x select 1 select 2;
        _groupStatus = _x select 1 select 3;

        switch (_groupCommand) do {
            case "joinGame": {
                if !(_groupName in _bluforGroupIdArray) then {
                    _spawnedGroups = [west, _groupType, playerBase, "FORM", _groupName] call spawnUnits;
                    spawnDataTemp = [_groupName, _groupType, "spawned", _groupObjective, _groupStatus];
                } else {
                    hint "not able to spawn";
                };
            };
        };

    } forEach _twitchGroups;

    // hint format ["Blufor Groups: %1", bluforGroups];
    // Here we will just check the command variable
    // _teamStatus;
    // if (armaCommand != "") then {
    // hint format ["%1", armaCommand];
    //     switch (armaCommand) do {
    //         case "attack": {
    //             // hint "Attack Command Received";
    //             // Add logic for AI to attack here
	// 			_unitName = "twitch user";
	// 			_destination = markerPos "enemySpawnMarker";
    //             _attackCommand = [_unitName, _destination, "attack"] call moveCommand;
    //         };
    //         case "defend": {

    //             // Add logic for AI to defend here
	// 			_unitName = "Mario";
	// 			_destination = [1822.7,5500.06];
    //             _attackCommand = [_unitName, _destination, "attack"] call moveCommand;
    //         };
    //         case "joinGame" : {

    //         }
    //     };

    //     // Reset command after processing
    //     armaCommand = ""; 
    // } else {
	// 	// hint "no armaCommand";
	// 	null = [] execVM "scripts\getData.sqf";
	// };

    sleep 1; // Polling interval

    // Execute Event Listeners to detect and publish removeAllEventHandlers
    call compile preprocessFileLineNumbers "events\eventsCreator.sqf";
    
};
