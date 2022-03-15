function [linecount] = linecount(datafile)
linecount = sum(fileread(datafile) == 10) - 1;
end

