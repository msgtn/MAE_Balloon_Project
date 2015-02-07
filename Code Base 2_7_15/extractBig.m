% Function to open the large text file of year long data and divide into 
% small text files of one day and time
% INPUTS:
% textfile = text file name (massive file of all data per station for year)
%    must be a string of 'StaID_MMDDYYYY.txt'
% month = desired month
% day = desired day
% year = desired year
% time = desired time
% OUTPUTS:
% name = name of the text file in the current working folder for the desired 
%       information

function name=extractBig(textfile,montH,daY,yeaR,timE)
%clear all
%clc
% Troubleshooting values
    % Desired Text File
    %textfile='72562_01012014.txt';
    % Desired Date, Time, Data, must be strings
    %montH='01';       % January
    %daY='01';         % 1st
    %yeaR='2014';      % Year
    %timE='00';        % midnight or noon    
    
% Check for string name of text file
condit=ischar(textfile);        % checks to make sure that textfile is a
if condit==0                     % string input
    error('Argument "textfile" is not a string.')
else
end

% Open large file
%textfile
fileID=fopen(textfile);       % open text file
tline=fgets(fileID);       % extracts the first line

%Formulate date
date=[yeaR,montH,daY,timE]; % forms text string
d=date(9:10);               % extracts the time
d=str2num(d);               % converts time to number
if d>=6                     % if time requested is <= 6
    f='12';                 % find weather data = 12
else                        % otherwise
    f='00';                 % find weather data = 00
end
date=[yeaR,montH,daY,f];     % reconfigure text string

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
for p=1:200                         % for 200 iterations:
    if texstrs==date                % if the text matches the desired date
        title=[tline(1:16),'.txt']; % then name a text file as the header,
        nxt=str2num(tline(21:24));  % find how many data entries to skip,
        fileid=fopen(title,'w');    % open a new text file, 
        fprintf(fileid,'%s',tline);   % print the header entirely
        for kk=1:nxt              % and for all data entries,
            fgets(fileID);     % extract the string of data
            %line=num2str(line);     % convert the string to numeric
            %fprintf(fileid,'%s',line);     % and write it to the file
            linen=fgets(fileID);            % odd matlab double space
            fprintf(fileid,'%s',linen);     % for some reason (?)
        end
        fclose('all');              % then close the file
        break                       % and exit the for loop prematurly
    else                               % otherwise,
        next=tline(21:24);             % read the number of data entries,
        next=str2num(next);            % convert the string to a number,
        for k=1:2*next+1                   % and for all data entries,
            tline=fgets(fileID);       % read and do nothing
        end
        tline=fgets(fileID);           % then, identify the new header
        %{
         for o=1:3
            if tline==0
                tline=fgets(fileID);
            else
                disp('Investigate text file spacing.')
                break
            end
        end
         %}
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
name=title;
end