function [status] = make_folder(folder)

% use strrep() to replace the colons with something else
folder = strrep(folder, ':' , '_' );

if ~exist(folder,'dir')
    status = mkdir(folder);
    if status == 0
        disp('error: unable to creatre the folder ')
    end
end

end

