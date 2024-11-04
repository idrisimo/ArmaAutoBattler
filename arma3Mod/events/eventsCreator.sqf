private _eventQueue = missionNamespace getVariable ["eventQueue", []];
private _bluforGroups = missionNamespace getVariable ["bluforGroups", []];
private _engagedGroups = missionNamespace getVariable ["engagedGroups", []];

// Iterate through each BLUFOR group
{
    private _group = _x;

    // Check if the group is dead
    if ({alive _x} count units _group == 0) then {
        _eventQueue pushBack ["BlueGroupDied", _group];  // Publish the "GroupDied" event

        // Remove the dead group from tracking lists
        _bluforGroups = _bluforGroups - [_group];
        _engagedGroups = _engagedGroups - [_group];
        missionNamespace setVariable ["bluforGroups", _bluforGroups];
        missionNamespace setVariable ["engagedGroups", _engagedGroups];

    } else {
        // Only add "BlueGroupEngaged" event if not already engaged
        if (!(_group in _engagedGroups) && (combatMode leader _group == "RED" || (behaviour leader _group == "COMBAT"))) then {
            _eventQueue pushBack ["BlueGroupEngaged", _group];
            _engagedGroups pushBack _group;  // Mark group as engaged
        };
    };

} forEach _bluforGroups;

// Update global event queue and engaged groups
missionNamespace setVariable ["eventQueue", _eventQueue];
missionNamespace setVariable ["engagedGroups", _engagedGroups];

// Call eventHandlers.sqf to process events
call compile preprocessFileLineNumbers "events\eventHandler.sqf";
