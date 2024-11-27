%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Helper Predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check if a door is passable, either directly or through a key.
passable(CurrentRoom, NextRoom, _) :- 
    door(CurrentRoom, NextRoom); 
    door(NextRoom, CurrentRoom).

% Check if a door is locked and if the player has the key.
passable(CurrentRoom, NextRoom, Keys) :-
    (locked_door(CurrentRoom, NextRoom, LockColor); 
     locked_door(NextRoom, CurrentRoom, LockColor)),
    member(LockColor, Keys). % If the player has the correct key.
    
% Add a key to the key list if present in the room, avoiding duplicates.
pickup_keys(CurrentRoom, Keys, UpdatedKeys) :-
    (key(CurrentRoom, KeyColor), \+ member(KeyColor, Keys) ->
        UpdatedKeys = [KeyColor | Keys]; % Add key if not already picked.
        UpdatedKeys = Keys).           % No change if key is already picked.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Breadth-First Search (BFS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Base case: When we reach a room with a treasure, return the path.
bfs([[Path, CurrentRoom, _] | _], Path) :-
    treasure(CurrentRoom).

% Recursive case: Explore the next possible moves and keep track of the path.
bfs([[Path, CurrentRoom, Keys] | RestQueue], Solution) :-
    findall(
        [NewPath, NextRoom, UpdatedKeys],
        (
            passable(CurrentRoom, NextRoom, Keys),       % Check if the door is passable.
            \+ member(move(CurrentRoom, NextRoom), Path), % Avoid revisiting the same move.
            pickup_keys(NextRoom, Keys, UpdatedKeys),     % Pick up keys in the next room.
            append(Path, [move(CurrentRoom, NextRoom)], NewPath) % Add the move to the path.
        ),
        NewPaths
    ),
    append(RestQueue, NewPaths, NewQueue), % Add new paths to the queue for further exploration.
    bfs(NewQueue, Solution). % Continue exploring with the new queue.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Entry Point for the Search
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The search entry point which starts the BFS from the initial room.
search(Actions) :-
    initial(StartRoom), % Start the search from the initial room.
    bfs([[[ ], StartRoom, []]], Actions). % Initialize BFS with an empty path and no keys.
