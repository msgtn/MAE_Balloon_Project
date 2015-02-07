% Decision Maker
% INPUTS
% Current lat, long, height
% Desired lat, long, height
% Calculates difference in desired and actual
% OUTPUTS
% Defines mass positions for different scenarios
% newvecs = [x3
function newvecs=CurrentP(Opos,Bangs,Dpos,alpha,wdirB)
% Opos = latitude and longitude and height in O frame
% Bangs = angles ax,ay,az 
% Dpos = position vector of desired position in O frame
% alpha = [aoaH aoaV]
%function position=CurrentP(latitude, longitude, CMheight)
% Position gives the current position of the system
% Latitude is the current latitude at time
% Longitude is the current longitude at time
% Components of the position of the system

% Inputs
ax=Bangs(1);            % Current ax angle
ay=Bangs(2);            % Current ay angle
az=Bangs(3);            % Current az angle
dirBx=wdirB(1);
dirBy=wdirB(2);
dirBz=wdirB(3);

% Rotating from the B frame to the O frame
Rx=[1 0 0;0 cos(ax) sin(ax);0 -sin(ax) cos(ax)];  % X rotation matrix
Ry=[cos(ay) 0 -sin(ay);0 1 0;sin(ay) 0 cos(ay)];  % Y rotation matrix
Rz=[cos(az) sin(az) 0;-sin(az) cos(az) 0;0 0 1];  % Z rotation matrix
BCO=Rz*Ry*Rx;       % BCO matrix
OCB=BCO';           % OCB matrix

% Heading out of vertical wing nose
noseB=[0;1;0];      % direction out of vertical wing in B
noseO=BCO*noseB;    % direction out of vertical wing in O

RotCurrentP=Opos; % Current lat,lon,height in the O frame

lat=Dpos(1);   % Desired latitude of the system (degrees)
lon=Dpos(2);   % Desired longitude of the system (degrees)
cmh=Dpos(3);   % Desired center of mass height (m)

Difflat=RotCurrentP(1)-lat;    % Difference in wanted and actual latitude (degrees)
Difflong=RotCurrentP(2)-lon;   % Difference in wanted and actual longitude (degrees)
DiffCM=RotCurrentP(3)-cmh;     % Difference in wanted and actual height

% Determine outputs
if Difflat<0      % If the diff in lat is less than 0
    y4d=ycmb+5;        % Move the y-axis mass in the positive direction
    % Change the vertical angle of attack
    if noseO(2)=>0
        if noseO(1)>0
            aoaVy=-0.5+alpha(2);
        else
            aoaVy=-0.5+alpha(2);
        end
    else
        if noseO(1)>0
            aoaVy=0.5+alpha(2);
        else
            aoaVy=0.5+alpha(2);
        end
    end
    
elseif Difflat>0  % If the diff in lat is greater than 0
    y4d=ycmb-5       % Move the y-axis mass in the negative direction
        % Change the vertical angle of attack
    if noseO(2)=>0
        if noseO(1)>0
            aoaVy=0.5+alpha(2);
        else
            aoaVy=0.5+alpha(2);
        end
    else
        if noseO(1)>0
            aoaVy=-0.5+alpha(2);
        else
            aoaVy=-0.5+alpha(2);
        end
    end
else 
end
if Difflong<0    % Same concept as lat but move x axis mass
    x3d=xcmb+5
    % need +iO force
        % Change the vertical angle of attack
    if noseO(2)=>0
        if noseO(1)>0
            aoaVx=0.5+alpha(2);
        else
            aoaVx=-0.5+alpha(2);
        end
    else
        if noseO(1)>0
            aoaVx=0.5+alpha(2);
        else
            aoaVx=-0.5+alpha(2);
        end
    end
elseif Difflong>0
    x3d=xcmb-5
    % need -iO force
            % Change the vertical angle of attack
    if noseO(2)=>0
        if noseO(1)>0
            aoaVx=-0.5+alpha(2);
        else
            aoaVx=0.5+alpha(2);
        end
    else
        if noseO(1)>0
            aoaVx=-0.5+alpha(2);
        else
            aoaVx=0.5+alpha(2);
        end
    end
else
end

% Choose which way to move aoaV
if abs(aoaVy)>abs(aoaVx)        % if the need to go in Y is bigger than X
    aoaV=aoaVy;                 % actuate the wing to choose Y motion
else                            % otherwise, choose X motion
    aoaV=aoaVx;
end

if DiffCM<0     % If diff in Cm height less than 0
     alpha=alpha+[0.5 0]  % Adjust angle of attack to generate lift force
elseif DiffCM>0   % If diff in CM height greater than 0
     alpha=alpha-[0.5 0] % Adjust angle of attack to generate negative lift
end



newvecs=[x3d,y4d,aoaH,aoaV];
end
    
  


