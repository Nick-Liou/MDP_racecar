function save_experiment(Drive_Track, Start_Track, Finish_Track, path_and_actions,expected_utility,total_utility_collected)

    folder_name = 'experiments';
    if ~isfolder(folder_name)
        mkdir(folder_name);
    end
    
    base_filename = 'experiment';
    extension = '.xlsx';
    
    % Get list of existing experiment files
    existing_files = dir(fullfile(folder_name, [base_filename, '*.xlsx']));
    
    % Extract the highest experiment number used
    experiment_numbers = [];
    
    for k = 1:length(existing_files)
        name = existing_files(k).name;
        tokens = regexp(name, [base_filename '(\d+)_'], 'tokens');
        if ~isempty(tokens)            
            experiment_numbers(end+1) = str2double(tokens{1}{1});            
        end
    end
    
    % Determine next experiment number
    if isempty(experiment_numbers)
        experiment_num = 1;
    else
        experiment_num = max(experiment_numbers) + 1;
    end
    
    % Format utilities
    formatted_utility = strrep(sprintf('%.2f', expected_utility), '.', 'p');
    formatted_total = strrep(sprintf('%.2f', total_utility_collected), '.', 'p');
    
    % Construct filename
    filename = fullfile(folder_name, ...
        sprintf('%s%d_expected%s_actual%s%s', base_filename, experiment_num, formatted_utility, formatted_total, extension));
    
    % filename is ready to use!

    cell_colors = generate_cell_colors(Drive_Track, Start_Track, Finish_Track) ;

    create_colored_excel(filename, flipud(path_and_actions'), flipud(cell_colors'));
end