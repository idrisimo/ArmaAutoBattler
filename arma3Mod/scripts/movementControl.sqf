// moveCommand = {
// 	params [
// 		["_groupName", ""],
// 		["_destination", []],
// 		["_moveType", ""]
// 	];

// 	(call compile format ["%1", _groupName]) move _destination;

// 	if (_moveType == "attack") then {
// 		hint "Attack Command Received";
// 		// Monitor until movement is complete
// 		waitUntil { 
// 			(call compile format ["%1", _groupName]) distance _destination < 5 // Check if within 5 meters
// 		};
// 		hint "Movement to attack point complete!";
// 	} else {
// 		hint "Defend Command Received";
// 		// Monitor until movement is complete
// 		waitUntil { 
// 			(call compile format ["%1", _groupName]) distance _destination < 5 // Check if within 5 meters
// 		};
// 		hint "Movement to defend point complete!";
// 	};
// };

moveCommand = {
    params [
        ["_group", grpNull],        // Now expects the group object
        ["_destination", []],       // Destination position as an array
        ["_moveType", ""]           // Move type: "attack" or "defend"
    ];

    // Get the position of the group leader
    private _leaderPos = leader _group;

    // Command the group to move
    _group move _destination;

    if (_moveType == "attack") then {
        hint "Attack Command Received";
        // Monitor until movement is complete
        waitUntil {
            _leaderPos distance _destination < 5 // Check if within 5 meters
        };
        hint "Movement to attack point complete!";
    } else {
        hint "Defend Command Received";
        // Monitor until movement is complete
        waitUntil {
            _leaderPos distance _destination < 5 // Check if within 5 meters
        };
        hint "Movement to defend point complete!";
    };
};

