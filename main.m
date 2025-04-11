
clear;

max_speed = 2;  % must be >= 1
max_accel = 1;  % must be >= 1
gamma = 1;      % must be in (0,1]
p = 1;        % must be in (0,1]
crash_penalty = -10;    % must be negative
goal_utility = 100;     % must be positive
time_step_cost = 1 ;    % must be positive
number_of_experiments = 1 ; % per starting state
save_exp = false ;

% Create the track (drivable spaces) and Start , Finish
Drive_Track = false(16,12) ;

Drive_Track(3:13,8:10) = true;
Drive_Track(12:14,4:9) = true;
Drive_Track(6:13,3:5) = true;


Start_Track = false(16,12) ;
Start_Track(3,8:10) = true;

Finish_Track = false(16,12);
Finish_Track(6:7,3:5) = true;

State_Track = Drive_Track ;
State_Track(Finish_Track) = false; %Remove the finish line from the states



% Print the track (similar to the provided diagram)
At = Drive_Track';                % Transpose the matrix first
disp(At(end:-1:1, :));      % Then reverse the rows


% Initialize stantard scores
R = - time_step_cost * ones([size(Drive_Track) 2*max_speed+1  2*max_speed+1 ]);
R(6:7,3:5,:,:) = goal_utility - time_step_cost ; 
R(repmat(~Drive_Track, [1, 1, size(R,3), size(R,4)])) = crash_penalty;

% Initialize utility scores 
U = zeros([size(Drive_Track) 2*max_speed+1  2*max_speed+1 ]);
U(6:7,3:5,:,:) = goal_utility  ;


tic
U = value_iteration(U,R,State_Track,Drive_Track,max_speed,max_accel,gamma,p,crash_penalty);
toc

% print_utils(U,max_speed)

tic
Policy = optimal_policy(U,State_Track,Drive_Track,max_speed,max_accel,p,crash_penalty);
toc

% print_policy(Policy, max_speed)



%% Run experiments 
all_states = get_all_starting_states(Start_Track, max_speed); 
num_states = size(all_states, 1);
zero_speed_index = max_speed + 1 ;

tic
for i = 1:num_states
    start_state = all_states(i, :);
    fprintf('For start state (x, y, v_x, v_y): (%d, %d, %d, %d)\n', ...
            start_state(1), start_state(2), start_state(3)-zero_speed_index, start_state(4)-zero_speed_index);

    % Fetch expected utility once
    expected_utility = U(start_state(1), start_state(2), start_state(3), start_state(4));

    % Preallocate experiment_utilities for speed
    experiment_utilities = zeros(1, number_of_experiments);

    for j = 1:number_of_experiments    
        experiment_utilities(j) = run_experiment(U, Policy, R, Drive_Track, ...
            Start_Track, Finish_Track, max_speed, max_accel, p, crash_penalty, ...
            gamma, start_state, save_exp);
        
    end

    avg_utility = mean(experiment_utilities);
    fprintf('For %d runs: Expected utility: %.2f   |   Avg utility collected: %.2f\n\n', ...
            number_of_experiments, expected_utility, avg_utility);
end
toc




