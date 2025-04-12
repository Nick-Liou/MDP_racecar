function [U] = value_iteration(U, R, State_Track, Drive_Track, max_speed, max_accel, gamma, p, crash_penalty)
    % value_iteration performs value iteration on a grid-based driving problem.
    %
    % Inputs:
    %   U              - Initial utility matrix (same size as state space).
    %   R              - Reward matrix for each state.
    %   State_Track    - Logical mask for valid (reachable) states.
    %   Drive_Track    - Logical mask for drivable track area.
    %   max_speed      - Maximum absolute velocity allowed in x and y.
    %   max_accel      - Maximum absolute acceleration allowed in x and y.
    %   gamma          - Discount factor for future rewards.
    %   p              - Probability of taking intended action.
    %   crash_penalty  - Penalty applied when crashing (invalid move).
    %
    % Output:
    %   U              - Updated utility matrix after convergence.

    tolerance = 1e-6;
    max_iter = 1000;
    zero_speed_index = max_speed + 1 ;
    U_old = U ;

    iter = 0;
    [row, col] = find(State_Track);    

    while true
        iter = iter + 1 ;
        fprintf('Value Iteration %d\n', iter);
        
        
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

                        % Note use the values of U instead of U_old to converge sooner 
                        % (to implement the clasical value iteration to calculate/update
                        % the utility we should have used U_old 
                        
                        % Location of the next state if action 'a' succeeds
                        s_hat = s + actions_and_speeds(a,3:4) ;                        
                        if reachable_state( s, s_hat , Drive_Track)
                            u_with_a = U(s_hat(1), s_hat(2), ...
                                max_speed+1+actions_and_speeds(a,3), ...
                                max_speed+1+actions_and_speeds(a,4)...
                                ) ;     
                        else
                            u_with_a = crash_penalty + U(x,y,zero_speed_index,zero_speed_index) ;
                        end
    
                        % Location of the next state if action 'a' fails
                        s_hat_hat = s + [v_x,v_y] ;    
                        if reachable_state( s, s_hat_hat, Drive_Track)
                            u_failed_a = U(s_hat_hat(1), s_hat_hat(2) ,v_x_index, v_y_index) ;     
                        else
                            u_failed_a = crash_penalty + U(x,y,zero_speed_index,zero_speed_index) ;
                        end
                            
                        expected_util_after_actions(a) = R +  p * u_with_a + (1-p)*u_failed_a ;
                    end
    
                    U(x,y,v_x_index,v_y_index) =   gamma * max(expected_util_after_actions); % R(x,y,v_x_index,v_y_index) +
                
                end
            end
    
        end
    
        % Check for convergence
        if all(abs(U(:) - U_old(:)) < tolerance)
            disp(['Converged at iteration ', num2str(iter)]);
            break;
        end
    
        % Optional: prevent infinite loops
        if iter >= max_iter
            warning('Max iterations reached without convergence.');
            break;
        end
    
        % Prepare for next iteration
        U_old = U;
    end


end

