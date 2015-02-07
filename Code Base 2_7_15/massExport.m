% Function to open and extract data from several huge files at once.
% Note: files can be zipped with .gz ending
% INPUTS:
% list = list of huge .txt or .dat files within the current working folder
%       for opening, must be string!
% month = desired month
% day = desired day
% year = desired year
% time = desired time
% OUTPUTS:
% outs = list of outcomes from the files

function outs=massExport(list,month,day,year,time)
% Christopher D. Yoder
% MAE 511: Dynamics

A=length(list);
for j=1:A
    textfile=list(j);
    textfile=num2str(textfile);
    textfile=[textfile,'.dat'];
    %exi=exist(textfile,'file'); %Verifies the file exists in the directory
    %if exi~=0
        %filename=unzip(textfile)
        %isnumeric(filename)
        %ischar(filename)
    extractHuge(textfile,month,day,year,time);
    %else
        %name(j)=0;      %error('File is not within the directory.')
    %end        
        
    
    
    
end

outs='done.';

end