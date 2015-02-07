% Function to calculate density for air at altitude
% INPUTS
% Pressure (Pa)
% Temperature (K)
% OUTPUTS
% Air Density (kg/m^3)

function density=Density(pressure,temperature)

% Define Constants
R=287.058;   %J/kgK, gas constant for air

% Calculate Density
density=pressure/(R*temperature);  %kg/m^3 density
end