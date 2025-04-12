function [] = print_policy(Policy, max_speed)
    % print_policy displays the actions in the Policy for all velocity combinations
    %
    % Inputs:
    %   Policy     - A cell array of size (X x Y x 2*max_speed+1 x 2*max_speed+1)
    %                where each cell contains a 1x2 vector [ax ay] or is empty.
    %   max_speed  - Maximum speed in either direction

    for v_x_index = 1:2*max_speed+1 
        v_x = -max_speed - 1 + v_x_index;
        for v_y_index = 1:2*max_speed+1 
            v_y = -max_speed - 1 + v_y_index;
    
            u_slice = Policy(:, :, v_x_index, v_y_index);
            u_slice = u_slice';  % Transpose to match display orientation

            fprintf('\nPolicy for v_x = %d, v_y = %d\n', v_x, v_y);
            
            % Create a readable display version
            display_matrix = strings(size(u_slice));
            for i = 1:size(u_slice,1)
                for j = 1:size(u_slice,2)
                    action = u_slice{i,j};
                    if isempty(action)
                        display_matrix(i,j) = "";
                    else
                        display_matrix(i,j) = sprintf("[%2d %2d]", action(1), action(2));
                    end
                end
            end

            % Flip rows for bottom-up display like a grid
            display_matrix = flipud(display_matrix);

            disp(display_matrix)
        end
    end
end
