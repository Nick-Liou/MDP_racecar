function [total_utility_collected] = run_experiment(U,Policy,R,Drive_Track, Start_Track, Finish_Track,max_speed,max_accel,p,crash_penalty,goal_utility,gamma ,current_state, save_exp )
 
    max_moves = 1000 ;
    zero_speed_index = max_speed + 1 ;

    
    expected_utility = U(current_state(1),current_state(2),current_state(3),current_state(4)) ;
    total_utility_collected = 0 ; %R(current_state(1),current_state(2),current_state(3),current_state(4));
    path_and_actions = repmat({''},size(Drive_Track));

    move = 0 ;
    while true % move < max_moves && ~Finish_Track(current_state(1),current_state(2))
        move = move + 1 ; 
        
        % Get the action from the Policy
        a = Policy{current_state(1),current_state(2),current_state(3),current_state(4)} ; 
        assert(all(abs(a)<=max_accel) , "New acceleration should be less than the max acceleration")


        position = current_state(1:2) ; 
        speed_index =  current_state(3:4) ;
        
        action_succeeds = rand(1) < p ;

        if action_succeeds 
            speed_index = speed_index + a ; 
            assert(all(abs(speed_index-zero_speed_index)<=max_speed) , "New speed should be less than the max speed")
        end
        
        next_position = position + speed_index-zero_speed_index ;
        if ~reachable_state( position, next_position , Drive_Track)
            next_position = position ;
            speed_index = [zero_speed_index zero_speed_index] ;
            total_utility_collected = total_utility_collected + gamma^(move-1) * crash_penalty ;
        end

        total_utility_collected = total_utility_collected + gamma^(move-1) * R(current_state(1),current_state(2),current_state(3),current_state(4)) ; % R(next_position(1),next_position(2),speed_index(1),speed_index(2));

        


        % Update move notes in the form: "Move (v_x,v_y , ax,ay)"
        extra_string = sprintf("%dη (%d,%d , %d,%d)",move, current_state(3:4) - zero_speed_index , a );
        old_string = path_and_actions{current_state(1),current_state(2)} ;
    
        if old_string ~= ""
            old_string = old_string + ", ";
        end
        path_and_actions{current_state(1),current_state(2)} = old_string + extra_string ;
        
        % Update for next loop
        current_state = [next_position speed_index];

        if Finish_Track(current_state(1),current_state(2))
            move = move + 1 ; 
            total_utility_collected = total_utility_collected + gamma^(move-1) * goal_utility ;
            extra_string = sprintf("%dη (%d,%d , %d,%d)",move, current_state(3:4) - zero_speed_index , a );
            old_string = path_and_actions{current_state(1),current_state(2)} ;
        
            if old_string ~= ""
                old_string = old_string + ", ";
            end
            path_and_actions{current_state(1),current_state(2)} = old_string + extra_string ;
            
            break 
        end

    end


    

    % fprintf('Expected utility: %.2f   |   Total utility collected: %.2f\n', expected_utility, total_utility_collected);


    
    if save_exp 
        save_experiment(Drive_Track, Start_Track, Finish_Track, path_and_actions,expected_utility,total_utility_collected);
    end


end

