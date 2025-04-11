function create_colored_excel(filename, data, colors)
    % create_colored_excel creates an Excel file with a matrix of data 
    % and applies the specified colors to each cell.
    % Inputs:
    %   filename - Name of the output Excel file (including .xlsx extension)
    %   data     - A cell array of strings (e.g., {'A1', 'A2', ...})
    %   colors   - A cell array of RGB color values for each cell, where each 
    %              entry is a 1x3 vector [R, G, B] (0-255).
    
    % Ensure the number of colors matches the size of the data
    [num_rows, num_cols] = size(data);
    if numel(colors) ~= num_rows * num_cols
        error('The number of color entries must match the number of cells in the data.');
    end
    
    % Launch Excel
    excel = actxserver('Excel.Application');
    excel.Visible = false;  % Show Excel (set to false to hide)
    
    % Create a new workbook
    workbook = excel.Workbooks.Add();
    sheet = workbook.Sheets.Item(1);  % First sheet in the workbook
    
    % Write data into Excel
    for row = 1:num_rows
        for col = 1:num_cols
            cell_name = sprintf('%s%d', char('A' + col - 1), row);  % e.g., 'A1', 'B2'
            sheet.Range(cell_name).Value = data{row, col};  % Set cell value
        end
    end    
   
   

    % Apply colors and borders to each cell
    for row = 1:num_rows
        for col = 1:num_cols
            % Get RGB color
            rgb = colors{row, col};
            color = rgb2excel(rgb(1), rgb(2), rgb(3));
            
            % Get the Excel range for the cell
            cell_name = sprintf('%s%d', char('A' + col - 1), row);
            range = sheet.Range(cell_name);
            
            % Set background color
            range.Interior.Color = color;
            
            % Add borders
            borders = range.Borders;
            for edge = 7:12  % xlEdgeLeft (7) to xlInsideHorizontal (12)
                borders.Item(edge).LineStyle = 1;     % xlContinuous
                borders.Item(edge).Weight = 2;        % xlThin
                borders.Item(edge).ColorIndex = 0;    % Black
            end
        end
    end

    
    % Save and close the workbook
    workbook.SaveAs(fullfile(pwd, filename));
    workbook.Close(false);
    excel.Quit();
    delete(excel);
    
    % --- Helper function to convert RGB to Excel color format ---
    function excelColor = rgb2excel(r, g, b)
        excelColor = b * 65536 + g * 256 + r;
    end
end
