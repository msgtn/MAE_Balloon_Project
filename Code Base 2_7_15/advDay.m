% Function to advance a calendar day
% INPUTS:
% year = year as a string
% month = month as a string
% day = day as a string
% OUTPUTS:
% dn = string of YYYYMMDD of new advanced day

function dn=advDay(year,month,day)
% Christopher D. Yoder
% MAE 511: Dynamics Project Two

year=str2num(year);     % year as a number
month=str2num(month);   % month as a number
day=str2num(day);       % day as a number

mnth=calendar(year,month);      % pulls the month as a calender

% Organizes the array
array=[mnth(1,1:7)';mnth(2,1:7)';mnth(3,1:7)';mnth(4,1:7)';...
    mnth(5,1:7)';mnth(6,1:7)']; % makes the array a column array
L=length(array);            % find the length of the array

for j=1:L                   % for the entire column array
    if array(j)==day        % if the entry equals the current day,
        ent=j;              % then remember that entry
    else                    % otherwise, 
    end                     % carry on
end

if ent+1>L                  % if the entry is the last array entry
    if month==12            %   and if the month is december,
        newYear=year+1;     %       advance the year, 
        month=1;            %       set the month to january
        newday=1;           %       and set the day to the first.
    else                    %   otherwise,
        newYear=year;       %       keep the year, 
        newMonth=month+1;   %       advance the month,
        newDay=1;           %       and set the day to the first.
    end
else                        % otherwise,         
    nextDay=array(ent+1);   %   pull the next entry in the array
    if nextDay==0           %   and if that entry is a zero,
        if month==12        %       and if the month is december;
            newYear=year+1; %           advance the year
        else                %       otherwise,
            newYear=year;   %           keep the year
        end 
        newMonth=month+1;   %   otherwise, if the month isn't december
        newDay=1;           %       advance the month and set the day to 
    else                    %       the first
        newYear=year;       %   otherwise, advance the day only
        newMonth=month;
        newDay=nextDay;
    end
end

% Convert back to string
if newMonth<=9                      % if the month is a single digit
    newM=['0',num2str(newMonth)];   % add a zero before string
else
    newM=num2str(newMonth);         % otherwise, convert to a string
end

if newDay<=9                        % if the day is a single digit
    newD=['0',num2str(newDay)];     % add a zero before the string
else
    newD=num2str(newDay);           % otherwise, convert to a string
end

dn=[num2str(newYear),newM,newD];    % configure new date
end