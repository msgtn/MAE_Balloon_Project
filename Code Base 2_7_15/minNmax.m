% Code to find the n number of frequencies for either min or max
% INPUTS
%   array - matrix of data values for sorting, horizontal
%   command - a text string either max or min depending on requirement
%   number - the number of values required
% OUTPUTS
%   sols - two columns of indeces and solutions respectively

function sols=minNmax(array,command,number)
    L=length(array);        % row, column number for matrix
    if L<number
        disp('Number exceeds array length (from "minNmax.m)');
        number=L;
    else
    end
    
    %L=length(array);
        if strcmp(command,'max')==1
            for i=1:number      % for the requested # of min/max values
                [val,idx]=max(array);   % returns value and index
                m(i)=val;
                n(i)=idx;
                mult=min(array);
                array(idx)=mult/10;
            end
        elseif strcmp(command,'min')==1
            for i=1:number
                %array;
                [val,idx]=min(array);
                m(i)=val;
                n(i)=idx;
                mult=max(array);
                array(idx)=mult*10;
            end
        else
            error('Invalid Command')
        end
           
sols=[n',m'];
    
end