% Function to open the large text file of year long data and divide into 
% small text files of one year (technically 8months)
% INPUTS:
% textfile = text file name (massive file of all data per station for year)
%    must be a string, can be .dat file
% month = desired month
% day = desired day
% year = desired year
% time = desired time
% OUTPUTS:
% name = name of the text file in the current working folder for the desired 
%       information

function name=extractHuge(textfile,month,day,year,time)
% Troubleshooting values
    % Desired Text File
    %files='72562_010114.txt';
    % Desired Date, Time, Data, must be strings
    %Month='01';       % January
    %Day='05';         % 1st
    %Year='2014';      % Year
    %Time='00';        % midnight or noon
    
% Check for string name of text file
condit=ischar(textfile);        % checks to make sure that textfile is a
if condit==0                     % string input
    error('Argument "textfile" is not a string.')
else
end
    
% Open large file
fileID=fopen(textfile);       % open text file
tline=fgets(fileID);       % extracts the first line

%Formulate date
date=[year,month,day,time]; % forms text string
d=date(9:10);               % extracts the time
d=str2num(d);               % converts time to number
if d>=6                     % if time requested is <= 6
    f='12';                 % find weather data = 12
else                        % otherwise
    f='00';                 % find weather data = 00
end
date=[year,month,day,f];     % reconfigure text string

% Conditional for time adjustment
texstr=tline(7:16);          % extracts text string
dd=texstr(9:10);             % extracts the time
dd=str2num(dd);              % converts time to number
if dd>=6                     % if time requested is <= 6
    ff='12';                 % find weather data = 12
else                         % otherwise
    ff='00';                 % find weather data = 00
end
texstrs=[texstr(1:8),ff];     % reconfigure text string

% Conditional for finding next string
for p=1:50000                         % for 200 iterations:
    if texstrs==date                % if the text matches the desired date
        tit=[tline(2:6),'_',tline(11:14),tline(7:10),'.txt']; % name file
        fileid=fopen(tit,'w');    % open a new text file w/title above 
        for q=1:500
            nxt=str2num(tline(21:24));  % find how many data entries,    
            fprintf(fileid,'%24s\r\n',tline);   % print the header entirely
            for kk=1:nxt-1              % and for all data entries,
                line=fgets(fileID);     % extract the string of data
                line=num2str(line);     % convert the string to numeric
                fprintf(fileid,'%36s\r\n',line);     % and write it to the file
            end
            tline=fgets(fileID);
            if tline==-1
                disp('End of file reached.')
                break
            else
            end
        end
        fclose('all');              % then close the file
        break                       % and exit the for loop prematurly
    else                               % otherwise,
        next=tline(21:24);             % read the number of data entries,
        next=str2num(next);            % convert the string to a number,
        for k=1:next                   % and for all data entries,
            tline=fgets(fileID);       % read and do nothing
        end
        tline=fgets(fileID);           % then, identify the new header
        if tline==-1
            break
        else
        end
        % Time adjustment
        texstrt=tline(7:16);           % extract the text string
        ddd=texstrt(9:10);             % extracts the time
        ddd=str2num(ddd);              % converts time to number
        if ddd>=6                      % if time requested is <= 6
            fff='12';                  % find weather data = 12
        else                           % otherwise
            fff='00';                  % find weather data = 00
        end
        texstrs=[texstrt(1:8),fff];      % reconfigure text string
       
    end
end    
appl=exist('tit','var');
if appl==0
    name='End of file reached. No useable data.';
else
    name=tit;
end
end