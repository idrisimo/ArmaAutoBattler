private _eventQueue = missionNamespace getVariable ["eventQueue", []];
private _bluforGroups = missionNamespace getVariable ["bluforGroups", []];
{
    private _event = _x select 0;
    private _data = _x select 1;

    // Handle specific events based on type
    switch (_event) do {
        case "BlueGroupDied": {
            hint format ["Blue Group %1 has died.", _data];
            // Additional handling logic for "BlueGroupDied" event here
        };
        
        case "BlueGroupEngaged": {
            hint format ["Blue Group %1 is engaged in combat.", _data];
            // Additional handling logic for "BlueGroupEngaged" event here
            _groupData = spawnDataTemp;
			_groupName = (_groupData select 0);
			_groupType = (_groupData select 1);
			_groupCommand = (_groupData select 2);
			_groupObjective = (_groupData select 3);
			_groupStatus = (_groupData select 4);

			null = [_groupName, _groupType, _groupCommand, _groupObjective, "engaged"] execVM "scripts\setDBGroups.sqf"
        };

		case "GroupSpawned": {
            // hint format ["Group %1 has been spawned.", groupId _data];
            // Additional handling logic for "GroupSpawned" event here
			_bluforGroups = _bluforGroups + [_data];
			missionNamespace setVariable ["bluforGroups", _bluforGroups];
			_groupData = spawnDataTemp;
			_groupName = (_groupData select 0);
			_groupType = (_groupData select 1);
			_groupCommand = (_groupData select 2);
			_groupObjective = (_groupData select 3);
			_groupStatus = (_groupData select 4);

			null = [_groupName, _groupType, _groupCommand, _groupObjective, _groupStatus] execVM "scripts\setDBGroups.sqf"

        };
        
        // Add cases for any other events
        // case "BlueGroupArrived": { /* handle arrival event */ };
    };
} forEach _eventQueue;

// Clear the queue after handling events
missionNamespace setVariable ["eventQueue", []];
