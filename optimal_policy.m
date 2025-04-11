function [Policy] = optimal_policy(U, State_Track, Drive_Track, max_speed, max_accel, p, crash_penalty)
    % optimal_policy computes the optimal action to take at each state
    % given a utility matrix U and environment constraints.
    %
    % Inputs:
    %   U              - Utility matrix of all states.
    %   State_Track    - Logical mask of valid (reachable) states.
    %   Drive_Track    - Logical mask of drivable track.
    %   max_speed      - Maximum absolute velocity allowed in x and y.
    %   max_accel      - Maximum absolute acceleration allowed in x and y.
    %   p              - Probability of taking intended action.
    %   crash_penalty  - Penalty applied when a move results in a crash.
    %
    % Output:
    %   Policy         - A cell array containing optimal action [ax, ay] at each state.

    Policy = cell(size(U));

    [row, col] = find(State_Track); 
    
    for k = 1:length(row)
        x = row(k);
        y = col(k);        
        % fprintf('Track is true at (%d, %d)\n', x-1, y-1);
        

        for v_x_index = 1:2*max_speed+1 
            v_x = -max_speed-1 + v_x_index;
            for v_y_index = 1:2*max_speed+1 
                v_y = -max_speed-1 + v_y_index;                    

                                
                actions_and_speeds = get_availabe_actions(v_x,v_y,max_speed,max_accel);
    
                % Preallocate array
                expected_util_after_actions = zeros(size(actions_and_speeds,1),1) ;

                for a = 1:size(actions_and_speeds,1)
                    % Location now
                    s = [x,y];
                    
                    % Location of the next state if action 'a' succeeds
                    s_hat = s + actions_and_speeds(a,3:4) ;                        
                    if reachable_state( s, s_hat , Drive_Track)
                        u_with_a = U(s_hat(1), s_hat(2), ...
                            max_speed+1+actions_and_speeds(a,3), ...
                            max_speed+1+actions_and_speeds(a,4)...
                            ) ;     
                    else
                        u_with_a = crash_penalty;
                    end

                    % Location of the next state if action 'a' fails
                    s_hat_hat = s + [v_x,v_y] ;    
                    if reachable_state( s, s_hat_hat, Drive_Track)
                        u_failed_a = U(s_hat_hat(1), s_hat_hat(2) ,v_x_index, v_y_index) ;     
                    else
                        u_failed_a = crash_penalty;
                    end
                        
                    expected_util_after_actions(a) = p * u_with_a + (1-p)*u_failed_a ;
                end

                
                [~, best_a] = max(expected_util_after_actions) ;

                Policy{x,y,v_x_index,v_y_index} = actions_and_speeds(best_a,1:2);
            
            end
        end

    end
    


end