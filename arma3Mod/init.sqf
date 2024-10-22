[] execVM "spawn.sqf";
[] execVM "movementControl.sqf";
// [] execVM "groupRoster.sqf";

//Check if database exists
databaseName = "database";
_playerName = name player;

_inidbi = ["new", databaseName] call OO_INIDBI;
_fileExist = "exists" call _inidbi;
if(_fileExist) then {
    hint "File Exists, getting data";
    null = [] execVM "getData.sqf";
} else {
    hint "File doesn't Exists, creating database";
    null = [_playerName] execVM "createDatabase.sqf";
};

player addAction ["Spawn Unit", {

    _positions = [
        [1749.7,5458.32],  // Position for Team Leader
        [1749.7,5458.32],  // Position for Autorifleman
        [1749.7,5458.32],  // Position for Rifleman #1
        [1749.7,5458.32]   // Position for Rifleman #2
    ];
    _groupType = "fireTeam";
    _groupName = "twitch User";
    // Call the function to spawn the fire team with a group name
    _spawnedUnits = [west, _groupType, _positions, "FORM", _groupName] call spawnUnits;
    hint "Group spawned!";
}];


// Define a global variable to hold the command
armaCommand = "";

// Polling loop to check for commands
while {true} do {
    // Here we will just check the command variable
    if (armaCommand != "") then {

        switch (armaCommand) do {
            case "attack": {
                // hint "Attack Command Received";
                // Add logic for AI to attack here
				_unitName = "Mario";
				_destination = [1904.83,5470.57,0];
                _attackCommand = [_unitName, _destination, "attack"] call moveCommand;
            };
            case "defend": {

                // Add logic for AI to defend here
				_unitName = "Mario";
				_destination = [1822.7,5500.06];
                _attackCommand = [_unitName, _destination, "attack"] call moveCommand;
            };
        };

        // Reset command after processing
        armaCommand = ""; 
    } else {
		// hint "no armaCommand";
		null = [] execVM "getData.sqf";
	};

    sleep 1; // Polling interval
};
