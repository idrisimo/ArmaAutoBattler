

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
                hint "Attack Command Received";
                // Add logic for AI to attack here
				unitName = "Mario";
				destination = [1904.83,5470.57,0];
				(call compile format ["%1", unitName]) move destination;

				// Monitor until movement is complete
                waitUntil { 
                    (call compile format ["%1", unitName]) distance destination < 5 // Check if within 5 meters
                };
                hint "Movement to attack point complete!";
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
		hint "no armaCommand";
		null = [] execVM "getData.sqf";
	};

    sleep 1; // Polling interval
};
