function [all_states] = get_all_starting_states(Start_Track, max_speed)

    % Find linear indices of all true elements
    trueIndices = find(Start_Track);
    
    % Preallocate matrix to store all states
    num_states = numel(trueIndices);
    all_states = zeros(num_states, 4);

    % Zero speed index (assumed to be max_speed + 1 due to indexing scheme)
    zero_speed_index = max_speed + 1;

    for i = 1:num_states
        % Convert linear index to row and column subscripts
        [x, y] = ind2sub(size(Start_Track), trueIndices(i));
        
        % Assign to state matrix
        all_states(i, :) = [x, y, zero_speed_index, zero_speed_index];
    end

end
