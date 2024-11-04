moveCommand = {
    params [
        ["_group", grpNull],        // Now expects the group object
        ["_destination", []],       // Destination position as an array
        ["_moveType", ""]           // Move type: "attack" or "defend"
    ];

    // Command the group to move
    _group move _destination;

    // Continuously monitor the group's progress
    private _distanceThreshold = 5;  // Set threshold for arrival
    private _lastCheckPos = position (leader _group);  // Track last position

    hint format ["%1 Command Received", _moveType];

    while {true} do {
        // If the leader gets within the threshold, exit the loop
        if ((leader _group) distance _destination < _distanceThreshold) exitWith {
            hint format ["Movement to %1 point complete!", _moveType];
        };

        // If the group leader's position hasn't changed for a while, reissue the command
        if ((leader _group) distance _lastCheckPos < 2) then {
            _group move _destination;
        };

        // Update last known position of the leader
        _lastCheckPos = position (leader _group);
        
        sleep 2;  // Check every 2 seconds
    };
};
