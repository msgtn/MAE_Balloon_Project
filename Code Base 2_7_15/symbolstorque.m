% MAE 511 Group Project Two
% Generates symbolic torque
% 25460084
% Legend:
% d is derivative wrt time
% dd is double derivative wrt time

clc
clear all

syms mt xcmb xcmbd xcmbdd ycmb ycmbd ycmbdd zcmb zcmbd zcmbdd ...
    x1 x1d x1dd x2 x2d x2dd x3 x3d x3dd x4 x4d x4dd y1 y1d y1dd ...
    y2 y2d y2dd y3 y3d y3dd y4 y4d y4dd z1 z1d z1dd z2 z2d z2dd ...
    z3 z3d z3dd z4 z4d z4dd wx wxd wy wyd wz wzd Ixx m1 m2 m3 m4 xb ...
    xbd xbdd yb ybd ybdd zb zbd zbdd ib jb kb Iyy Izz

ohbi=(mt*(ycmb*(z1d+z2d+z3d+z4d+zbd+wx*yb-wy*xb)-zcmb*(y1d+y2d+y3d+y4d+ybd ...
    +wz*xb-zb*wx))+wx*(m1*(y1*y1+z1*z1)+m2*(y2*y2+z2*z2)+m3*(y3*y3+z3*z3 ...
    )+m4*(y4*y4+z4*z4))-wy*(m1*x1*y1+m2*x2*y2+m3*x3*y3+m4*x4*y4)-wz*( ...
    m1*x1*z1+m2*x2*z2+m3*x3*z3+m4*x4*z4)+Ixx*wx);

ohbj=(mt*(zcmb*(x1d+x2d+x3d+x4d+xbd+wx*yb-wy*xb)-xcmb*(z1d+z2d+z3d+z4d+zbd ...
    +wy*zb-wz*yb))+wy*(m1*(x1*x1+z1*z1)+m2*(x2*x2+z2*z2)+m3*(x3*x3+z3*z3) ...
    +m4*(x4*x4+z4*z4))-wx*(m1*x1*y1+m2*x2*y2+m3*x3*y3+m4*x4*y4)-wz*( ...
    m1*y1*z1+m2*y2*z2+m3*y3*z3+m4*z4*y4)+Iyy*wy);

ohbk=(mt*(xcmb*(y1d+y2d+y3d+y4d+ybd+xb*wz-wx*zb)-ycmb*(x1d+x2d+x3d+x4d+xbd ...
    +wy*zb-wz*yb))+wz*(m1*(x1*x1+y1*y1)+m2*(x2*x2+y2*y2)+m3*(x3*x3+y3*y3) ...
    +m4*(x4*x4+y4*y4))-wx*(m1*x1*z1+m2*x2*z2+m3*x3*z3+m4*x4*z4)-wy*( ...
    m1*y1*z1+m2*y2*z2+m3*y3*z3+m4*y4*z4)+Izz*wz);

w=[wx wy wz];
ohb=[ohbi ohbj ohbk];
cri=wy*ohbk-wz*ohbj;
crj=wz*ohbi-wx*ohbk;
crk=wx*ohbj-wy*ohbi;

cr=[cri;crj;crk];

addi=(ybd+xb*wz-wx*zb)*(zcmbd+wx*ycmb-wy*xcmb)-(zbd+wx*yb-wy*xb)*(ycmbd+wz*xcmb-wx*zcmb);

addj=(zbd+wx*yb-wy*xb)*(xcmbd+wy*zcmb-wz*ycmb)-(xbd+wy*zb-wz*yb)*(zcmbd+wx*ycmb-wy*xcmb);

addk=(xbd+wy*zb-wz*yb)*(xcmbd+wy*zcmb-wz*ycmb)-(ybd+xb*wz-wx*zb)*(xcmbd+wy*zcmb-wz*ycmb);

add=[addi;addj;addk];
h=cr+add;            % addition of w x hb and mtvbo x ovcmo

Dohbi=mt*(ycmbd*(z1d+z2d+z3d+z4d+zbd+wx*yb-wy*xb)+ycmb*(z1dd+z2dd+z3dd+ ...
    z4dd+zbdd+wxd*yb+wx*ybd-wyd*xb-wx*ybd)-zcmbd*(y1d+y2d+y3d+y4d+ybd+ ...
    wz*xb-zb*wx)-zcmb*(y1dd+y2dd+y3dd+y4dd+ybdd+wz*xbd+wzd*xb-zbd*wx- ...
    zb*wxd))+wx*(m1*(2*y1*y1d+2*z1*z1d)+2*m2*(y2*y2d+z2*z2d)+2*m3*(y3* ...
    y3d+z3*z3d)+2*m4*(y4*y4d+z4*z4d))+wxd*(m1*(y1*y1+z1*z1)+m2*(y2*y2+ ...
    z2*z2)+m3*(y3*y3+z3*z3)+m4*(y4*y4+z4*z4))-wyd*(m1*x1*y1+m2*x2*y2+ ...
    m3*x3*y3+m4*x4*y4)-wy*(m1*(x1*y1d+x1d*y1)+m2*(x2*y2d+x2d*y2)+m3*( ...
    x3*y3d+x3d*y3)+m4*(x4*y4d+x4d*y4))-wzd*(m1*x1*z1+m2*x2*z2+m3*x3*z3+ ...
    m4*x4*z4)-wz*(m1*(x1d*z1+x1*z1d)+m2*(x2d*z2+x2*z2d)+m3*(x3d*z3+x3*z3d) ...
    +m4*(x4d*z4+x4*z4d))+Ixx*wxd;

Dohbj=mt*(zcmbd*(x1d+x2d+x3d+x4d+xbd+wx*yb-wy*xb)+zcmb*(x1dd+x2dd+x3dd+ ...
    x4dd+xbdd+wxd*yb+wx*ybd-wyd*xb-wy*xbd)-xcmbd*(z1d+z2d+z3d+z4d+zbd+ ...
    wy*zb-yb*wz)-xcmb*(z1dd+z2dd+z3dd+z4dd+zbdd+wy*zbd+wyd*zb-ybd*wz- ...
    yb*wzd))+wy*(m1*(2*x1*x1d+2*z1*z1d)+2*m2*(x2*x2d+z2*z2d)+2*m3*(x3* ...
    x3d+z3*z3d)+2*m4*(x4*x4d+z4*z4d))+wyd*(m1*(x1*x1+z1*z1)+m2*(x2*x2+ ...
    z2*z2)+m3*(x3*x3+z3*z3)+m4*(x4*x4+z4*z4))-wxd*(m1*x1*y1+m2*x2*y2+ ...
    m3*x3*y3+m4*x4*y4)-wx*(m1*(x1*y1d+x1d*y1)+m2*(x2*y2d+x2d*y2)+m3*( ...
    x3*y3d+x3d*y3)+m4*(x4*y4d+x4d*y4))-wz*(m1*(y1d*z1+y1*z1d)+m2*(y2d*z2 ...
    +y2*z2d)+m3*(y3d*z3+y3*z3d)+m4*(y4d*z4+y4*z4d))-wzd*(m1*y1*z1+m2*y2*z2+ ...
    m3*y3*z3+m4*y4*z4)+Iyy*wyd;

Dohbk=mt*(xcmbd*(y1d+y2d+y3d+y4d+ybd+xb*wz-wx*zb)+xcmb*(y1dd+y2dd+y3dd+y4dd+ ...
    ybdd+xbd*wz+xb*wzd-wx*zbd-wxd*zb)-ycmbd*(x1d+x2d+x3d+x4d+xbd+wy*zb- ...
    wz*yb)-ycmb*(x1dd+x2dd+x3dd+x4dd+xbdd+wy*zbd+wyd*zb-wz*ybd-wzd*yb))+ ...
    2*wz*(m1*(x1*x1d+y1*y1d)+m2*(x2*x2d+y2*y2d)+m3*(x3*x3d+y3*y3d)+m4*( ...
    x4*x4d+y4*y4d))+wzd*(m1*(x1*x1+y1*y1)+m2*(x2*x2+y2*y2)+m3*(x3*x3+y3*y3)...
    +m4*(x4*x4+y4*y4))-wxd*(m1*x1*z1+m2*x2*z2+m3*x3*z3+m4*x4*z4)-wx*(m1*( ...
    x1*z1d+x1d*z1)+m2*(x2*z2d+x2d*z2)+m3*(x3*z3d+x3d*z3)+m4*(x4*z4d+x4d*z4))...
    -wyd*(m1*y1*z1+m2*y2*z2+m3*y3*z3+m4*y4*z4)-wy*(m1*(y1*z1d+y1d*z1)+m2*( ...
    y2*z2d+y2d*z2)+m3*(y3*z3d+y3d*z3)+m4*(y4*z4d+y4d*z4))+Izz*wzd;

Dohb=[Dohbi;Dohbj;Dohbk];

T=Dohb+h ;       % torque monster expressed in the B frame

% Setting things to zero
% z1d=z2d=z3d=z4d=0
% z1dd=z2dd=z3dd=z4dd=0
% zbd=zbdd=0 "assumes no horizontal wing"
% zcmb=zcmbd=zcmbdd=0 "assumes that cm is only in iB jB plane"
% m1=balloon, m2=wing, can't move
% x1d=x1dd=x2d=x2dd=0
% y1d=y1dd=y2d=y2dd=0
% z1d=z1dd=z2d=z2dd=0
% assume m3 along i only, then m4 along j only
% y3=y3d=y3dd=0
% x4=x4d=x4dd=0
% Assume masses move at constant speed
% x3dd=y4dd=0
% z3=z4=0 bc in same plane as B

z1d=0;
z2d=0;
z3d=0;
z4d=0;
z1dd=0;
z2dd=0;
z3dd=0;
z4dd=0;
zbd=0;
zbdd=0;
zcmb=0;
zcmbd=0;
zcmbdd=0;
x1d=0;
x1dd=0;
x2d=0;
x2dd=0;
y1d=0;
y1dd=0;
y2d=0;
y2dd=0;
z1d=0;
z1dd=0;
z2d=0;
z2dd=0;
y3=0;
y3d=0;
y3dd=0;
x4=0;
x4d=0;
x4dd=0;
x3dd=0;
y4dd=0;

% Substitute the inertia terms from SolidWorks here
Ixx=24390981087;
Iyy=24390981445;
Izz=112861.06;

z3=0;
z4=0;

T=eval(T);

% to get from O frame to B frame we need to rotate by ax about io, ay about
%jo and az about ko
syms ax ax ay ay az az
R1=[1 0 0;0 cos(ax) sin(ax);0 -sin(ax) cos(ax)];
R2=[cos(ay) 0 -sin(ay);0 1 0;sin(ay) 0 cos(ay)];
R3=[cos(az) sin(az) 0;-sin(az) cos(az) 0;0 0 1];
R=R1*R2*R3;

%We will get forces in the O frame from the velocities in O frame and then
%use the rotation matrix to transfer these forces to the O frame
% In the follo calculations all forces are taken to be in the B frame


 syms fbxo fbyo fbzo fv1xo fv1yo fv1zo fgxo fgyo fgzo flxo flyo flzo fdxo fdyo fdzo

fbo=[fbxo;fbyo;fbzo];
fv1o=[fv1xo;fv1yo;fv1zo];
fgo=[fgxo;fgyo;fgzo];
flo=[flxo;flyo;flzo];
fdo=[fdxo;fdyo;fdzo];

% fbb=R*fbo;
% fbx=fbb(1);
% fby=fbb(2);
% fbz=fbb(3);

% syms fbx fby fbz %fb is boutant force acting in B frame

% t1ib=fbz*y1-z1*fby;
% t1jb=z1*fbx-fbz*x1;
% t1kb=x1*fby-y1*fbx;

fv1b=R*fv1o;
% fv1x=fv1b(1); fv1y=fv1b(2); fv1z=fv1b(3); %fv1 is wind force on ballon at point m1 in B frame

syms fv1x fv1y fv1z % wind force on balloon

t2ib=y1*fv1z-z1*fv1y;
t2jb=z1*fv1x-x1*fv1z;
t2kb=x1*fv1y-y1*fv1x;

fgb=R*fgo;

% fgx=fgb(1); fgy=fgb(2); fgz=fgb(3); %gravity force in the B frame
syms fgx fgy fgz
t3ib=ycmb*fgz-zcmb*fgy;
t3jb=zcmb*fgx-xcmb*fgz;
t3kb=xcmb*fgy-ycmb*fgx;

% flb=R*flo;
% 
% flx=flb(1); fly=flb(2); flz=flb(3); %lift force components in B frame
% t4ib=y2*flz-z2*fly;
% t4jb=z2*flx-x2*flz;
% t4kb=x2*fly-y2*flx;

fdb=R*fdo;

% fdx=fdb(1); fdy=fdb(2); fdz=fdb(3); %wing force components in B frame
syms fdx fdy fdz    
t5ib=y2*fdz-z2*fdy;
t5jb=z2*fdx-x2*fdz;
t5kb=x2*fdy-y2*fdx;

ti=t2ib+t3ib+t5ib;
tj=t2jb+t3jb+t5jb;
tk=t2kb+t3kb+t5kb;

Ti=T(1);
Tj=T(2);
Tk=T(3);

ti0=ti-Ti;
ti0=expand(simplify(ti0));

tj0=tj-Tj;
tj0=expand(simplify(tj0));
tk0=tk-Tk;
tk0=expand(simplify(tk0));

y1=0;
y2=0;
x1=0;
x2=0;
z1=9353.8577;   % m, position of cm of balloon relative to cm sys
z2=-4681.121;   % m, position of cm of wing relative to cm system 
m1=203.77;      % kg, mass balloon
m2=300;         % kg, mass of wing
m3=10;
m4=10;
ti0=eval(ti0);
tj0=eval(tj0);
tk0=eval(tk0);


[s1,s2,s3]=solve(ti0==0,tj0==0,tk0==0,wxd,wyd,wzd);
axdd=simplify(s1)   % wx dot 
aydd=simplify(s2)   % wy dot
azdd=simplify(s3)   % wz dot

% at t=0
% ax=0;ay=0;az=0;
% 
% ti0=eval(ti0);
% tj0=eval(tj0);
% tk0=eval(tk0);

%{
% Remaining variables
fv1x=1;
fv1y=1;
fv1z=1;
fdx=1;
fdy=1;
fdz=1;
fgx=1;
fgy=1;
fgz=1;
xb=1;
yb=1;
zb=1;
xbd=1;
ybd=1;
zbd=1;
x3=1;
y4=1;
x3d=1;
y4d=1;
wx=1;
wy=1;
wz=1;
dt=1;
mt=600;
xcmb=1;
ycmb=1;
xbdd=1;
ybdd=1;
zbdd=1;
xcmbd=1;
ycmbd=1;

axdd=eval(axdd)
aydd=eval(aydd)
azdd=eval(azdd)
%}