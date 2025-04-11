function [colors_cell] = generate_cell_colors(Drive_Track, Start_Track, Finish_Track)

    % Define colors
    yellow = [255, 255, 0];   % Start line
    gray   = [190, 190, 190]; % Undrivable
    green  = [0, 255, 0];     % Finish line
    white  = [255, 255, 255]; % Drivable

    % Initialize cell array with all cells set to white (drivable)
    colors_cell = repmat({white}, size(Drive_Track));

    % Set undrivable areas to gray
    colors_cell(~Drive_Track) = {gray};

    % Set start line to yellow
    colors_cell(Start_Track) = {yellow};

    % Set finish line to green
    colors_cell(Finish_Track) = {green};

end
