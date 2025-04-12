function [] = print_utils(U,max_speed)

    for v_x_index = 1:2*max_speed+1 
        v_x = -max_speed-1 + v_x_index;
        for v_y_index = 1:2*max_speed+1 
            v_y = -max_speed-1 + v_y_index;
    
            u_slice = U(:,:,v_x_index,v_y_index);
    
            % u_slice(~Drive_Track) = 0 ;
            u_slice=u_slice';
    
            fprintf('\nUtilites for v_x and v_y: (%d, %d)\n', v_x, v_y);
            % disp(u_slice(end:-1:1, :))
            disp(flipud(u_slice))
            
        end
    end

end