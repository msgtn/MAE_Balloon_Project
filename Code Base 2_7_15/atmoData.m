% Function to return a matrix of height, pressure, temperature for a given
% text file.
% INPUTS
% fileName = desired station, year, month, day, time string, small file
% Example uses massive fileName='74455_01012014.txt' (StaID_MMDDYYYY.txt)
%         and small fileName='#744552014010100.txt'(#StaIDYYYYMMDDTT.txt)
% OUTPUTS 
% outs = matrix of height in meters, pressure in Pa, and temperature in K

function outs=atmoData(fileName)
% Christopher D. Yoder
% MAE 511: Dynamics Project Two


% NOTE: THE MASSIVE FILE NAME MUST HAVE THE STATION NUMBER, THEN:
%        '_010114.txt' AS THE FILE NAME!!!!!!
marker='_01012014.txt';

% Check for/create needed text file
does=exist(fileName,'file'); 
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
fileID=fopen(fileName);                 % open text file
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
    a=str2num(new(10:14));              % number array of height (m)
    b=str2num(new(3:8));                % number array of pressure (N/m2)
    c=(str2num(new(16:20))/10)+273.15;  % number array of temperature (K)
   if a>-9999 && b>-9999 && c>-9999     % checks valid measurement
            A(j)=a;         % height (m)
            B(j)=b;         % pressure (N/m2)
            C(j)=c;         % temperature (deg K)
   else 
            A(j)=0;         % zero
            B(j)=0;         % zero
            C(j)=0;         % zero
   end
end

A=nonzeros(A);              % eliminates zero entries (height)
B=nonzeros(B);              % eliminates zero entries
C=nonzeros(C);              % eliminates zero entries
cap=[35500,0,273.15-33];      % high end cap for values
A=[A;cap(1)];
B=[B;cap(2)];
C=[C;cap(3)];
outs=[A,B,C];             % matrix of height, pressure, temperature
end