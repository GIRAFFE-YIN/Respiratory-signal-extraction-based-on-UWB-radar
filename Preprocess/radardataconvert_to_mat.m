function [data,time,date_start,date_end,device,debugstruct,unixTime] = radardataconvert_to_mat(datafile,radarType,dataType)
%This function interprets binary or text raw radar data (Everes or
%Tiresias) and converts them to a structured matlab binary format with unix
%and relative time vectors, metadata and debug information. Note that some
%recordings may have incorrect unix timestamps due to integer overflow - this
%has to be manually checked and corrected.
frames = linecount(datafile);
badframes = []; %records which frames in the recording are corrupted (wrong
%number of bins). These should be quite rare.


device = '';


fid = fopen(datafile,'r');

if (strcmp(dataType,'text')) %'text' only option for now, will later implement binary conversion
    for i=1:5
       %Ignore three first frames as they may contain junk data
       lc = fgets(fid);
    end
    %Use fifth frame to determine number of range bins in file
    for i=1:30
        lc_san = lc(logical((lc~='[').*(lc~=']')));
        datal = split(lc_san,',');
        if str2num(datal{1})~=-1
           %test the first element in the dataline - if the frame is bad
           %the number will be read as -1 by Matlab
           break; 
        end
        frames = frames-1;
        lc = fgets(fid);
    end
    if i>=30
       disp('good frame not found within the first 30 frames read. Check data file integrity.')
       return
    end
    

    if (strcmp(radarType,'everes'))
        %If radar type is everes the device identifier isn't included
        unix_time_start =  str2double(datal(end));
        datal(end) = [];
        datal = str2double(datal);
        bins = length(datal);
        device = '';
    else
        %If type isn't everes then it's Tiresias by default: tiresias data
        %lines include the device identifier as penultimate element with
        %timestamp as last element in each line. Everything before that is raw
        %radar data with each elemnt corresponding to the data from one bin.
        unix_time_start =  str2double(datal(end-1));
        device = datal(end);
        datal(end) = [];
        datal(end) = [];
        datal = str2double(datal);
        bins = length(datal);
    end

    %datal = sscanf(lc_san,'%f,');
    %unix_time_start = datal(end-1);

    date_start = datetime(unix_time_start,'ConvertFrom','epochtime','TicksPerSecond',1e3,'Format','dd-MMM-yyyy HH:mm:ss.SSS');

    frames = frames-4;

    %count the number of range bins = number of radar data integers per line,
    %minus timestamp and device identifier
    %bins = length(datal(1:end-2));
    %device = (lc_san(1,end-6:end-3));

    %initialize matrices for efficient file reading
    data = (zeros(frames,bins)); %[unitless] raw RF ADC values (32 bit, but here we need them to be floats for further processing) 
    unixTime = zeros(frames,1); %[unitless] integer value for unix timestamps (millisecond resolution) corresponding to time in the recording
    time = zeros(frames,1); %[s] time vector in seconds for radar raw data, starting at 0.
    debugstruct.frameBins = zeros(frames,1); %Used to count the number of bins in each frame for debugging purposes.

    %Create a waitbar
    f = waitbar(0,'Please wait...');
    time1 = tic;
    for i=1:frames
        lc = fgets(fid);
        lc_san = lc(logical((lc~='[').*(lc~=']')));
        %datal = split(lc_san,',');
        %data(i,:) = str2double(datal(1:bins));
        try 
            datal = sscanf(lc_san,'%f,',bins+1);
        catch
            badframes = [badframes i];
            disp('bad frame at: ')
            disp(i)
            continue;
        end
        if (length(datal)~=(bins+1))
            %If we have an unexpected dataline length, the frame may be
            %corrupted (occasionally happens)
            badframes = [badframes i];
            disp('bad frame at: ')
            disp(i)
            continue;
        end
        data(i,:)  = datal(1:bins);
        unixTime(i) = datal(end);
        time(i) = datal(end)/1000;
    %     if (strcmp(radarType,'everes'))
    %         %For now both radar types use the same location in the data line to
    %         %store the timestamp
    %         time(i) = str2double(datal(end))/1000;
    %     else
    %         time(i) = str2double(datal(end))/1000;
    %     end
        %time(i) = str2double(datal(end))/1000;
        %datal = sscanf(lc_san,'%f,');
        %debugstruct.frameBins(i) = length(datal)-2;
        %data(i,:) = uint32(datal(1:bins));
        %time(i) = datal(end-1)/1000; %Convert timestamp to seconds
        if (~mod(i,1000))
            waitbar(i/frames,f,'Processing...');
            timeElapsed = toc(time1);
            disp('ETA ')
            disp((frames-i)/(i/timeElapsed))
        end
    end
    
else
    %if the data is not text, then it's binary. In case of binary data,
    %like for text we need to skip the first few frames, however we don't
    %have something nicely formatted, so we need to look for the device
    %identifier as that's always the last thing in each frame.
    rawData = fread(fid,'uint8');
    rawDataChar = char(rawData);
    identifiers = {['0005'],['0006'],['0007'],['0008'],['0010'],['0011']};
    for i=1:length(identifiers)
        deviceIDX = [];
        deviceIDX = strfind(rawDataChar',identifiers{i});
        if ~isempty(deviceIDX)
            device = identifiers{i};
            frames = length(deviceIDX)-3;
            bins = (deviceIDX(4)-deviceIDX(3)-14)/4;
                %measure number of bins not at the start of the file but a
                %couple of frames afterwards, where there's a better chance
                %the frames will contain the right number of bins.
                
            
            unix_time_start = typecast(uint8(rawData(deviceIDX(4)-8:deviceIDX(4)-1)),'uint64');
            date_start = datetime(unix_time_start,'ConvertFrom','epochtime','TicksPerSecond',1e3,'Format','dd-MMM-yyyy HH:mm:ss.SSS');
            break; %When you find the device, stop looking for any more identifiers
        end
        %If we get here there's been a problem since we haven't found the
        %identifier. Display error message and quit.
        disp('Device identifier not found, check input file format.')
        fclose(fid);
        return
    end
    
    data = (zeros(frames,bins)); %[unitless] raw RF ADC values (32 bit) 
    unixTime = zeros(frames,1); %[unitless] integer value for unix timestamps (millisecond resolution) corresponding to time in the recording
    time = zeros(frames,1); %[s] time vector in seconds for radar raw data, starting at 0.
    debugstruct.frameBins = zeros(frames,1); %Used to count the number of bins in each frame for debugging purposes.
    
    f = waitbar(0,'Please wait...');
    time1 = tic;
    for i=4:1:length(deviceIDX)
        data(i-3,:) = typecast(uint8(rawData(deviceIDX(i)-bins*4-8:deviceIDX(i)-9)),'uint32');
        unixTime(i-3) = typecast(uint8(rawData(deviceIDX(i)-8:deviceIDX(i)-1)),'uint64');
        if (~mod(i,1000))
            waitbar(i/frames,f,'Processing...');
            timeElapsed = toc(time1);
            disp('ETA ')
            disp((frames-i)/(i/timeElapsed))
        end
    end
    time = (unixTime-unixTime(1))/1000;
    
    clear('deviceIDX')
    clear('identifiers')
    clear('rawData')
    clear('rawDataChar')
    
end
close(f)
date_end = datetime(unixTime(end),'ConvertFrom','epochtime','TicksPerSecond',1e3,'Format','dd-MMM-yyyy HH:mm:ss.SSS');
%zero time
time = time-time(1); 

%Remove bad frames from data and time by rewriting the entire array
completeIndex = 1:1:length(time);
logIdx = ismember(completeIndex,badframes);
logIdx = -logIdx;
logIdx = logical(logIdx + 1);
data = data(logIdx,:);
time = time(logIdx);
unixTime = unixTime(logIdx);
frames = length(time);

% for i=length(badframes):-1:1
%     data(badframes(i),:) = [];
%     time(badframes(i)) = [];
% end

%Report likely missing samples
diffTime = diff(time);
missingS = sum(diffTime(diffTime>0.18))/0.1;
missLoad = (missingS / (frames+missingS))*100;
disp('Likely number of missing samples:')
disp(missingS)
disp('Missing sample load (%):')
disp(missLoad)


%finished reading file, close it.
fclose(fid);

%Delete variables we don't need
clear('lc')
clear('lc_san')
clear('i')
clear('f')
clear('fid')
clear('datal')
clear('time1')
clear('timeElapsed')
clear('logIdx')
clear('completeIndex')

%Save data to .mat file
matFileName = strtok(datafile,'.');
save([matFileName '.mat'])
end