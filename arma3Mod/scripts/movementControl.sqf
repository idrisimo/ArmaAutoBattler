moveCommand = {
	params [
		["_groupName", ""],
		["_destination", []],
		["_moveType", ""]
	];

	(call compile format ["%1", _groupName]) move _destination;

	if (_moveType == "attack") {
		hint "Attack Command Received";
		// Monitor until movement is complete
		waitUntil { 
			(call compile format ["%1", _groupName]) distance _destination < 5 // Check if within 5 meters
		};
		hint "Movement to attack point complete!";
	} else {
		hint "Defend Command Received";
		// Monitor until movement is complete
		waitUntil { 
			(call compile format ["%1", _groupName]) distance _destination < 5 // Check if within 5 meters
		};
		hint "Movement to defend point complete!";
	};
};
