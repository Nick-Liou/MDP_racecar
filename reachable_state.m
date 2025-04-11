function [is_reachable] = reachable_state(s, s_hat, Drive_Track)

    % Get the bounding box between s and s_hat
    rangex = min(s(1), s_hat(1)) : max(s(1), s_hat(1));
    rangey = min(s(2), s_hat(2)) : max(s(2), s_hat(2));

    % Extract the subregion from Track
    try
        subregion = Drive_Track(rangex, rangey);
        % Check if all positions are drivable
        is_reachable = all(subregion,"all");  % Must all be true to be reachable
    catch        
        is_reachable = false;
    end

    
end
