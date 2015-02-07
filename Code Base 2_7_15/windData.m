% Function to return a matrix of height, wind direction, and wind speed for
% a given text file
% INPUTS
% fileName = desired station, year, month, day, time string, small file
% Example uses massive fileName='74455_01012014.txt' (StaID_MMDDYYYY.txt)
%         and small fileName='#744552014010100.txt'(#StaIDYYYYMMDDTT.txt)
% OUTPUTS 
% matrix = matrix of values for height, wind direction, wind speed in
% meters, degrees from north, and meters per second respectively

function matrix=windData(fileName)

% Christopher D. Yoder
% December 2nd, 2014
% MAE 511: Dynamics

% NOTE: THE MASSIVE FILE NAME MUST HAVE THE STATION NUMBER, THEN:
%        '_01012014.txt' AS THE FILE NAME!!!!!!
marker='_01012014.txt';

% Check for/create needed text file
does=exist(fileName,'file');    % if the small day file does not exist
if does==0              % if the file does not exist in the directory
    month=fileName(11:12);                  % month of record
    day=fileName(13:14);                    % day of record
    year=fileName(7:10);                    % year of record
    time=fileName(15:16);                   % hour of record
    station=fileName(2:6);                  % desired station
    findFile=[station,marker];              % constructs file to lookup
    extractBig(findFile,month,day,year,time);   % creates text file
elseif does~=2
    error('Cannot locate text file or fileName is not a text file.')
else 
end

% Open file for one entry
fileID=fopen(fileName);    % open text file
tline=fgets(fileID);                    % extracts the first line

% Heading for that entry and station
station=tline(2:6);                     % station number
month=tline(11:12);                     % month of record
day=tline(13:14);                       % day of record
year=tline(7:10);                       % year of record
hour=tline(15:16);                      % hour of record
number=tline(21:24);                    % number of data entries
n=str2num(number);                      % converts to number for use

for j=1:n-1   
    new=fgets(fileID);                  % new line of text file
    start=str2num(new(1:2));            % major/minor type
    a=str2num(new(10:14));              % number array of height (m)
    b=str2num(new(27:31));              % number array of wind dir (deg)
    c=str2num(new(32:36))/10;           % number array of wind vel (m/s)
    if start==30
        if a>-9999 && b>-9999 && c>-9999    % checks valid measurement
            A(j)=a;         % height (m)
            B(j)=b;         % wind direction (deg)
            C(j)=c;         % wind velocity (m/s)
        else 
            A(j)=0;         % zero
            B(j)=0;         % zero
            C(j)=0;         % zero
        end
    else
        %A(j)=0;         % zero
        %B(j)=0;         % zero
        %C(j)=0;         % zero
    end              
end

alp=length(A);
for k=1:alp
    if A(k)>0
        non=k;
        break
    else
    end
end

A=A(non-1:alp);              % eliminates zero entries
B=B(non-1:alp);              % eliminates zero entries
C=C(non-1:alp);              % eliminates zero entries
matrix=[A',B',C'];             % matrix of height, direction, speed
end