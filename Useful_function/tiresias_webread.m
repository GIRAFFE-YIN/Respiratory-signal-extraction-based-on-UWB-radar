function [raw_data] = tiresias_webread(webpage,bins_drop)

%pull a json string from the API
web_data = webread(webpage);

%decode from json into matlab struct
data_Struct = jsondecode(web_data);

data_Cell = struct2cell(data_Struct);
data = struct2cell(data_Cell{1,1});

raw_data_A = [];
raw_data_12 = [];
raw_data_C = [];

for i = 1 : size(data,2)
    switch data{3,i}
        case 'TIRESIAS-0012'
            raw_data_12 = data{1,i};
        case 'TIRESIAS-000A'
            raw_data_A = data{1,i};
        case 'TIRESIAS-000C'
            raw_data_C = data{1,i};
    end
end

if length(raw_data_A) ~= 934
    raw_data_A = ones(934,1);
end
if length(raw_data_12) ~= 934
    raw_data_12 = ones(934,1);
end
if length(raw_data_C) ~= 934
    raw_data_C = ones(934,1);
end
% raw_data_12 = a2{1,1};
raw_data_A = raw_data_A(bins_drop:end);
raw_data_12 = raw_data_12(bins_drop:end);
raw_data_C = raw_data_C(bins_drop:end);

raw_data = [raw_data_A,raw_data_C];

end

