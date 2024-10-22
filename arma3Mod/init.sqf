// _clientID = clientOwner;
// _UID = getPlayerUID player;
// _name = name player;
// checkForDatabase = [_clientID, _UID, _name];
// publicVariableServer "checkForDatabase";

// // Adds an action the player can take to save their details and loadout
// player addAction ["Save Data", {
// 	_UID = getPlayerUID player;
// 	_gear = getUnitLoadout player;
// 	saveData = [_UID, _gear];
// 	publicVariableServer "saveData";
// }];

// // when player is loaded in it loads last saved loadout
// "loadData" addPublicVariableEventHandler {
// 	_gear = (_this select 1);

// 	player setUnitLoadout _gear;
	
// };

// while {true} do {
// 	_UID = getPlayerUID player;
//     _inidbi = ["new", _UID] call OO_INIDBI;

// 	_twitchCommand = ["read", ["Viewer Command", "Command", []]] call _inidbi;


// 	hint format ["Command: %1", _twitchCommand];


//     sleep 2;
// };

[] execVM "spawn.sqf";
player addAction ["Spawn Unit", {

    // Define unit types, positions, and names
    _unitTypes = [
        "B_Soldier_TL_F",   // Team Leader
        "B_Soldier_AR_F",   // Autorifleman
        "B_Soldier_F",      // Rifleman #1
        "B_Soldier_F"       // Rifleman #2
    ];

    _positions = [
        [1749.7,5458.32],  // Position for Team Leader
        [1749.7,5458.32],  // Position for Autorifleman
        [1749.7,5458.32],  // Position for Rifleman #1
        [1749.7,5458.32]   // Position for Rifleman #2
    ];

    _unitNames = [
        "Leader",         // Name for Team Leader
        "Gunner",         // Name for Autorifleman
        "Rifleman1",      // Name for Rifleman #1
        "Rifleman2"       // Name for Rifleman #2
    ];
    // Call the function to spawn the fire team with a group name
    _spawnedUnits = [west, _unitTypes, _positions, _unitNames, "FORM", "Legion"] call spawnUnits;
    hint "Named NATO Fire Team spawned!";
}];

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
				unitName = "Mario";
				destination = [1904.83,5470.57,0];
				(call compile format ["%1", unitName]) move destination;

				// Monitor until movement is complete
                waitUntil { 
                    (call compile format ["%1", unitName]) distance destination < 5 // Check if within 5 meters
                };
                // hint "Movement to attack point complete!";
            };
            case "defend": {
                hint "Defend Command Received";
                // Add logic for AI to defend here
				unitName = "Mario";
				destination = [1822.7,5500.06];
				(call compile format ["%1", unitName]) move destination;

				// Monitor until movement is complete
                waitUntil { 
                    (call compile format ["%1", unitName]) distance destination < 5 // Check if within 5 meters
                };
                hint "Movement to defend point complete!";
            };
            case "spawn": {
                hint "Spawn Command Received";
                // Add logic for spawning units here
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
