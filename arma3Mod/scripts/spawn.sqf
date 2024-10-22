/*
    Function to spawn a group of units and assign a group name
    Params:
    0: SIDE - Side to spawn units (e.g., west, east, resistance)
    1: ARRAY - Array of unit classnames (e.g., ["B_Soldier_TL_F", "B_Soldier_AR_F", "B_Soldier_F"])
    2: ARRAY - Array of positions for each unit (e.g., [[1000,0,1000], [1002,0,1002], [1004,0,1004]])
    3: ARRAY - Array of names for each unit (e.g., ["Leader", "Gunner", "Rifleman"])
    4: STRING - Unit behavior (e.g., "AWARE", "SAFE", etc.)
    5: STRING - Group name (e.g., "AlphaSquad")
    Returns:
    ARRAY - Array of spawned unit objects
*/
spawnUnits = {
    params [
        ["_side", west],             // Default side is NATO
        ["_unitTypes", []],          // Array of unit types (class names)
        ["_positions", []],          // Array of positions (x, y, z)
        ["_unitNames", []],          // Array of names for the units
        ["_behavior", "FORM"],      // Default behavior is AWARE
        ["_groupName", ""],           // Optional: Group name
		["_behav", AWARE]
    ];

    _group = createGroup _side;      // Create a group for the specified side

    // Set the group name
    if (_groupName != "") then {
        _group setVariable ["groupName", _groupName];
		_group setGroupId [_groupName]
    };

    // Array to store spawned units
    _spawnedUnits = [];

    // Loop through each unit type and its corresponding position
	{
		_unitType = _unitTypes select _forEachIndex;    // Get the unit type by index
		_position = _positions select _forEachIndex;    // Get the corresponding position by index
		_unitName = _unitNames select _forEachIndex;    // Get the corresponding name by index
		
		_unit = _group createUnit [_unitType, _position, [], 0, _behavior];  // Spawn the unit
		
		// Set the unit name (using setVariable or setVehicleVarName)
		_unit setVariable ["unitName", _unitName];   // Store the name in a custom variable
		_unit setVehicleVarName _unitName;           // Optional: Set as a vehicle variable

		// Add the spawned unit to the array
		_spawnedUnits pushBack _unit;

	} forEach _unitTypes;
	// Makes spawned units editable by zeus
    zeus addCuratorEditableObjects [_spawnedUnits];
    // Return the array of spawned units
    _spawnedUnits;
};
