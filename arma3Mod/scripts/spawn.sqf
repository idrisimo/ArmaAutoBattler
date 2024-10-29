/*
    Function to spawn a group of units and assign a group name
    Params:
    0: SIDE - Side to spawn units (e.g., west, east, resistance)
    1: STRING - Group Type (e.g., fireTeam, supportTeam)
    2: ARRAY - Array of the position for each unit (e.g., [1000,0,1000])
    3: STRING - Unit behavior (e.g., "AWARE", "SAFE", etc.)
    4: STRING - Group name (e.g., "AlphaSquad")
    Returns:
    ARRAY - Array of spawned unit objects
*/
spawnUnits = {
    private _eventQueue = missionNamespace getVariable ["eventQueue", []]; // Retrieve the event queue
    params [
        ["_side", west],             // Default side is NATO
        ["_groupType", ""],          // Group type to retrieve from database. (e.g., fireTeam)
        ["_position", []],          // Array of positions (x, y, z)
        ["_behavior", "FORM"],      // Default behavior is AWARE
        ["_groupName", ""]           // Optional: Group name
    ];

    // Load fire team configuration
	_inidbi = ["new", databaseName] call OO_INIDBI;
   	_groupRoster = ["read", ["Groups", _groupType, []]] call _inidbi;

    // Prepare arrays for spawning
    _unitTypes = [];
    _unitNames = [];

    // Loop through the infantry units to fill the arrays
    {
        _unitType = _x select 0; // Unit type (e.g., "B_Soldier_TL_F")
        _unitName = _x select 1;

        _unitTypes pushBack _unitType; // Add unit type to the array
        _unitNames pushBack _unitName; // Add name
    } forEach _groupRoster;

    _group = createGroup _side;      // Create a group for the specified side

    // Set the group name
    if (_groupName != "") then {
		_group setGroupId [_groupName];
    };

    // Array to store spawned units
    _spawnedUnits = [];

    // Loop through each unit type and its corresponding position
	{
		_unitType = _unitTypes select _forEachIndex;    // Get the unit type by index
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

    // Publish the "GroupSpawned" event with the new group data
    _eventQueue pushBack ["GroupSpawned", _group];
    missionNamespace setVariable ["eventQueue", _eventQueue];
    // hint format ["spawned group %1", groupId _group];
    // Return the array of spawned units
    _spawnedUnits;
};
