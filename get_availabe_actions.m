function [actions_and_new_speeds] = get_availabe_actions(vx, vy, max_speed, max_accel)
    % get_availabe_actions computes the available acceleration actions based on 
    % the current velocities (vx, vy), the maximum allowed speed (max_speed),
    % and the maximum allowed acceleration (max_accel). The function returns a 
    % 2D matrix where each row represents a valid acceleration pair [ax, ay] 
    % and the corresponding new velocities [new_vx, new_vy] after applying the 
    % acceleration. It ensures that the new velocities do not exceed the bounds 
    % of max_speed.
    
    % Inputs:
    %   vx       - Current velocity in the x-direction.
    %   vy       - Current velocity in the y-direction.
    %   max_speed - Maximum allowed speed (positive scalar).
    %   max_accel - Maximum allowed acceleration (positive scalar).
    
    % Outputs:
    %   actions_and_new_speeds - A 2D matrix where each row represents:
    %                             [ax, ay, new_vx, new_vy]
    %                             - ax: acceleration in the x-direction
    %                             - ay: acceleration in the y-direction
    %                             - new_vx: resulting velocity in the x-direction
    %                             - new_vy: resulting velocity in the y-direction
    %                             The accelerations and velocities are constrained 
    %                             such that the new velocities do not exceed the max_speed.

    % Initialize an empty array to hold valid actions and new velocities
    actions_and_new_speeds = [];  

    % Loop over all possible accelerations in x and y (ax, ay) ∈ {-max_accel, ..., 0, ..., max_accel}
    for ax = -max_accel:max_accel
        for ay = -max_accel:max_accel
            % Compute new velocities based on the current velocity and acceleration
            new_vx = vx + ax;
            new_vy = vy + ay;

            % Check if new velocities are within the bounds of max_speed
            if abs(new_vx) <= max_speed && abs(new_vy) <= max_speed
                % If valid, add the acceleration and new velocities to the result
                actions_and_new_speeds(end+1, :) = [ax, ay, new_vx, new_vy];
            end
        end
    end
end
