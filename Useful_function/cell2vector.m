function [output,fs] = cell2vector(input)


fs = length(input{1});

output = zeros(length(input)*fs,1);

for i = 1:length(input)
    output((i-1)*length(input{1})+1:i*length(input{1})) = input{i};
end


end

