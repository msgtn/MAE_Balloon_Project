% Function to call interpolated values for pressure, temperature, wind
% direction and wind speed for the balloon position at time
% INPUTS:
%   fileName  =  file name: stationID,year,month,day,time in a string
%   height  =  height of the balloon as a numerical value
%   position  =  [lat lon] latitude and longitude of the balloon
% OUTPUTS: 
%   values = [pressure, temperature, wind direction, wind speed]
%   where:
%   pressure  =  pressure at the desired point
%   temperature  =  temperature at the desired point
%   wind direction  =  direction of wind
%   wind speed  =  wind speed at the point in question

function values  =  prop(height, position, date)
% Christopher D. Yoder
% MAE 511: Dynamics Project Two
%{
clear all;
clc;
% inputs 
date = '2014010103';            % day time at 0300 hours
height = 35000;                       % meters, height of the balloon
position = [41.13,-100.68];           % latitude longitude of point
plat = position(1);
plon = position(2);
%}

% Define coordinates
lat_p = position(1);    % present latitude
lon_p = position(2);    % present longitude
%{
% Check for string name of text file
condit = ischar(fileName);        % checks to make sure that textfile is a 
if condit =  = 0                     % string input
    error('Argument "textfile" is not a string.')
else
end
%}
% Parse textfile into segments
%sta = fileName(2:6);       % station ID
yr = date(1:4);             % year of data
mo = date(5:6);             % month of data
dy = date(7:8);             % day of data
tme = date(9:10);           % time desired
daten = [yr,mo,dy];         % date for current day, string

% Normalize the time
tmeNum = str2num(tme);      % converts time to a numeric value
if tmeNum<12                % if the numeric value of time is less than 12
    tmes = '00';            % set tmes to  a string of '00'.
else                        % otherwise,
    tmes = '12';            % set tmes to a string of '12'.
end

% Determine times for evaluation
if strcmp(tmes,'00') == 1      % if the time requested is 00 hours,
    tn = '00';                 % timestep n is 00 hours,
    tn1 = '12';                % timestep n+1 is 12 hours,
    daten1 = daten;            % and do not change the date. (string)
elseif strcmp(tmes,'12') == 1  % if the time requested is 12 hours,
    tn = '12';                 % timestep n is 12 hours,
    tn1 = '00';                % timestep n+1 is 00 hours, 
    daten1 = advDay(yr, mo, dy); % and advance the date. (string)
end                    
   
% Compile the file strings desired for properties  
% Example uses small fileName = '#744552014010100.txt'(#StaIDYYYYMMDDTT.txt)
%                               '#74455 2014 01 01 00.txt'
%                               '#StaID YYYY MM DD TT.txt'
% Now have station ID as string, time as raw number, time as normalized
% string of 00 or 12, daten is first entry date as string, daten1 is
% second entry date as string

% Compute four nearest stations
% Lists nearest four stations and x and y coordinates in kilometers 
% assuming the balloon is at 0,0
statlist = nearest4(lat_p, lon_p,daten(1:4), daten1(1:4));  
xvals = 1000*statlist(1:4,2);          % x values in meters
yvals = 1000*statlist(1:4,3);          % y values in meters
% Order values according to x
xvalsN = minNmax(xvals,'min',4);      % orders the data by x
xvalsn = xvalsN(1:4,2);               % extracts the x values of data
yvalsn = [yvals(xvalsN(1,1)),yvals(xvalsN(2,1)),yvals(xvalsN(3,1)),...
    yvals(xvalsN(4,1))];            % extracts y values of data

% Extract data for all four stations at time n
for a = 1:4                                     % for all stations
    stata = num2str(statlist(a,1));             % con verts station to string 
    fileNamen = ['#',stata,daten,tn,'.txt'];    % file name for first time
    A = interExtra(atmoData(fileNamen),height); % array of interp. data
    B = interExtra(windData(fileNamen),height); % array of interp. data
    Pn(a) = A(2);                               % Pa, pressure 
    Tn(a) = A(3);                               % K, temperature
    Dn(a) = B(2);                               % deg from North, direction
    Sn(a) = B(3);                               % m/s, speed
end

% Extract data for all four stations at time n1
for a = 1:4                                     % for all stations
    stata = num2str(statlist(a,1));             % converts station to string 
    fileNamen1 = ['#',stata,daten1,tn1,'.txt'];   % file name for first time
    A = interExtra(atmoData(fileNamen1),height); % array of interp. data
    B = interExtra(windData(fileNamen1),height); % array of interp. data
    Pn1(a) = A(2);                              % pressure
    Tn1(a) = A(3);                              % temperature
    Dn1(a) = B(2);                              % direction
    Sn1(a) = B(3);                              % speed
end

% Arrays
Pvals = [mean(Pn),mean(Pn1)];
Tvals = [mean(Tn),mean(Tn1)];
Dvals = [mean(Dn),mean(Dn1)];
Svals = [mean(Sn),mean(Sn1)];
tnums = [str2num(tn),str2num(tn1)];

% Find properties at time
time = str2num(tme);              % converts the time to a number
Ptme = interp1(tnums,Pvals,time); % finds pressure at time
Ttme = interp1(tnums,Tvals,time); % finds temperature at time
Dtme = interp1(tnums,Dvals,time); % finds direction at time
Stme = interp1(tnums,Svals,time); % finds speed at time

values = [Ptme,Ttme,Dtme,Stme];
end