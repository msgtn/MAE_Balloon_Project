% Computes the closest four weather stations from a 
% list of latitude and longitude for the weather stations in the US
% INPUTS:
% plat = latitude position of the balloon
% plon = longitude position of the balloon
% Ystart = start time of the desired data
% Yend = end time of the desired data
% OUTPUTS:
% stations = matrix of stations and distances (in kilometers)

function stations=nearest4(plat,plon,Ystart,Yend)

format long

% Constant
re=6371;         % km, mean radius of the earth

% Station#, Latitude, Longitude, Start Year, End Year 
listNum=[
70026	71.30	 -156.78	1948	2013
70133	66.87	 -162.63	1948	2013
70200	64.50	 -165.43	1948	2013
70219	60.78	 -161.80	1948	2013
70231	62.97	 -155.62	1948	2013
70261	64.82	 -147.87	1948	2013
70273	61.16	 -149.98	1948	2013
70308	57.15	 -170.22	1948	2013
70316	55.20	 -162.72	1955	2013
70326	58.68	 -156.65	1953	2013
70350	57.75	 -152.50	1946	2013
70361	59.52	 -139.67	1948	2013
70398	55.03	 -131.57	1948	2013
70414	52.73	  174.10	1959	2013
72201	24.58	  -81.70	1954	2013
72202	25.75	  -80.38	1948	2013
72206	30.50	  -81.70	1955	2013
72208	32.90	  -80.03	1948	2013
72210	27.70	  -82.38	1975	2013
72214	30.45	  -84.30	1948	2013
72215	33.37	  -84.57	1955	2013
72221	30.48	  -86.52	1949	2013
72230	33.17	  -86.77	1974	2013
72233	30.33	  -89.82	1988	2013
72235	32.32	  -90.08	1956	2013
72240	30.12	  -93.22	1962	2013
72248	32.45	  -93.83	1956	2013
72250	25.92	  -97.42	1948	2013
72251	27.78	  -97.51	1953	2013
72261	29.37	 -100.92	1963	2013
72265	31.95	 -102.18	1963	2013
72274	32.12	 -110.92	1956	2013
72293	32.85	 -117.12	1963	2013
72295	33.93	 -118.40	1966	1979
72305	34.78	  -76.88	1957	2013
72317	36.08	  -79.95	1948	2013
72318	37.21	  -80.41	1961	2013
72327	36.25	  -86.57	1948	2013
72340	34.83	  -92.25	1948	2013
72357	35.23	  -97.47	1974	2013
72363	35.23	 -101.70	1956	2013
72364	31.87	 -106.70	1948	2013
72376	35.23	 -111.82	1961	2013
72402	37.93	  -75.48	1963	2013
72403	38.98	  -77.48	1960	2013
72426	39.42	  -83.75	1951	2013
72440	37.23	  -93.38	1970	2013
72451	37.77	  -99.97	1948	2013
72456	39.07	  -95.62	1955	2013
72469	39.76	 -104.87	1956	2013
72476	39.12	 -108.52	1948	2013
72489	39.57	 -119.79	1956	2013
72501	40.87	  -72.87	1980	2013
72518	42.69	  -73.83	1948	2013
72520	40.53	  -80.23	1952	2013
72528	42.93	  -78.73	1948	2013
72558	41.32	  -96.37	1954	2013
72562	41.13	 -100.68	1948	2013
72572	40.77	 -111.97	1956	2013
72582	40.86	 -115.74	1948	2013
72597	42.37	 -122.87	1948	2013
72632	42.70	  -83.47	1956	2013
72645	44.48	  -88.13	1963	2013
72649	44.85	  -93.57	1948	2013
72681	43.57	 -116.22	1963	2013
72694	44.92	 -123.02	1956	2013
72712	46.87	  -68.02	1948	2013
72747	48.57	  -93.38	1948	2013
72764	46.77	 -100.75	1948	2013
72768	48.21	 -106.63	1955	2013
72776	47.46	 -111.38	1948	2013
72786	47.68	 -117.63	1948	2013
72797	47.95	 -124.55	1966	2013
74389	43.90	  -70.25	1948	2013
74455	41.62	  -90.58	1956	2013
74494	41.67	  -69.97	1970	2013
74560	40.15	  -89.33	1988	2013
];

% Checks for valid time data within the time period specified
[a,b]=size(listNum);                % size of the above matrix
for k=1:a                       % for all of the rows in the matrix,
    if listNum(k,5)==2013        % if the end year is 2013,
       listNum(k,5)=2014;      % change it to 2014 (bc there is 2014 data
    else                        % present in the model), otherwise,
    end                         % carry on
    Ystrt=str2num(Ystart);      % convert input Ystart to a number
    Ynd=str2num(Yend);          % convert input Yend to a number
    %con=num2str(listNum(k,4));  % convert the start year to a string
    %com=num2str(listNum(k,5));  % convert the end year to a string
    if Ystrt<listNum(k,4);       % if the start period is before the time
        for L=1:b               % when the station began taking data, then
            listNum(k,L)=0;    % make all entries for that station zeros
            %listNum(k,1)=str2num(listNum(k,1)); % converts stations to #s
            %listNum(k,L)=str2num(listNum(k,L));
        end
    elseif Ynd>listNum(k,5);    % or, if the end period is after the station
        for M=1:b               % finished taking data, then make all
            listNum(k,M)=0;    % entries zeros.
        end
    else                        % otherwise, carry on
    end
end

%{
for K=1:a                           % for every row in the matrix
    name=num2str(listNum(K,1));     % convert the station ID to a string
    name2=[name,'.dat'];            % and add .dat onto the end
    name1=[name,'.txt'];            % or add .txt to the end
    does2=exist(name,'file');   % Check if the dat file exists
    does1=exist(name,'file');   % Check if the txt file exists
    if does2==0 && does1==0 % if the file does not exist in the directory
        for L=1:b            % set all entries to zero
            listNum(K,L)=0;
        end
    else
    end
end
%}

% Compile new matrix for the time specified
listNum1=nonzeros(listNum(1:a,1));   % remove all nonzero terms
listNum2=nonzeros(listNum(1:a,2));   % remove all nonzero terms
listNum3=nonzeros(listNum(1:a,3));   % remove all nonzero terms
listNum=[listNum1,listNum2,listNum3];   % compile new valid data matrix

% Calculate the distance between point and stations
[a,b]=size(listNum);        % size of the station list
for j=1:a                    % for each station, find the distance vector
    d(j)=(((plat-listNum(j,2))^2+(plon-listNum(j,3))^2)^(1/2))*re; % distance
end

% Find four minimum distances
dmat=minNmax(d,'min',4);        % computes the four closestdistances
stattot=[listNum(dmat(1,1));listNum(dmat(2,1));...
    listNum(dmat(3,1));listNum(dmat(4,1))];     % compiles list of stations

[a,b]=size(listNum);                    % size of the station list
for f=1:4                               % for all four stations
    for g=1:a                           % check every row of listNum
        if listNum(g,1)==stattot(f)     % and if a row station = station 
            statlat(f)=listNum(g,2);    % record the latitude
            statlon(f)=listNum(g,3);    % and record the longitude.
        else                            % otherwise, carry on
        end
    end
end

statx=-re*(pi/180)*(plon-statlon');     % x position relative to balloon
staty=re*(pi/180)*(statlat'-plat);      % y position relative to balloon

stations=[stattot,statx,staty];   % generate final matrix
end