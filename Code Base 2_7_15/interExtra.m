% Function to interpolate/extrapolate the properties desired wrt height
% Assumes height is the domain wrt interpolation
% INPUTS:
%   matrix = matrix of values for given domain
%   domainPoints = ROW VECTOR of points for desired values (for length>1)
% OUTPUTS:
%   values = array of values corresponding to domainPoints

function values=interExtra(matrix,domainPoints)

format long

% Imput Matrix for testing code
% matrix=1.0e+05*[
%    0.000050000000000   1.009000000000000   0.002636500000000
%    0.000740000000000   1.000000000000000   0.002650500000000
%    0.006780000000000   0.925000000000000   0.002664500000000
%    0.013400000000000   0.850000000000000   0.002674500000000
%    0.028440000000000   0.700000000000000   0.002608500000000
%    0.053800000000000   0.500000000000000   0.002506500000000
%    0.069800000000000   0.400000000000000   0.002388500000000
%    0.089300000000000   0.300000000000000   0.002252500000000
%    0.101100000000000   0.250000000000000   0.002166500000000
%    0.115200000000000   0.200000000000000   0.002164500000000
%    0.133500000000000   0.150000000000000   0.002162500000000
%    0.159200000000000   0.100000000000000   0.002180500000000
%    0.182100000000000   0.070000000000000   0.002186500000000
%    0.203700000000000   0.050000000000000   0.002212500000000
%    0.237100000000000   0.030000000000000   0.002238500000000
%    0.264100000000000   0.020000000000000   0.002304500000000];
% 
% domainPoints=[1,2,6,2550.7,50,20200,3000];

[L,m]=size(matrix);
p=length(domainPoints);
domain=matrix(1:L,1);

% Conditionals
for j=1:p
    for k=2:m
        if domainPoints(j)<domain(L) && domainPoints(j)>domain(1)
            vq(j,k)=interp1(domain,matrix(1:L,k),domainPoints(j));
        else
            vq(j,k)=interp1(domain,matrix(1:L,k),domainPoints(j),'linear'...
                ,'extrap');
        end
    end
end 

domainfull=[domainPoints',zeros(2,p)'];  % places the domain in proper size
values=domainfull+vq;                    % constructs the values matrix
end