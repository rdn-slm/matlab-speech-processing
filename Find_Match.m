function [M] = Find_Match(V,U, Time)
%FUNCTION TO CALCULATE MATCH GIVEN 
% V = THE REFERENCE POINT IN UNIT SAMPLE AND
% U = AUTOMATIC POINTS IN UNIT SAMPLE
% Time = TIME TOLERANCE IN UNIT SECOND

Fs = 16000;  %sampling rate
Vt = V/Fs;   % convert to unit time
Ut = U/Fs;   % convert to unit time

M = 0;

for n = 1:length(V)
    % RESET T and ind for EACH reference point
    T = zeros(1, length(U));  % Pre-allocate for efficiency
    ind = 1;
    
    for j = 1:length(U)  
        T(ind) = abs(Ut(j) - Vt(n));  
        ind = ind + 1;   
    end
    
    N = find(T <= Time);
    if ~isempty(N)  % Better than N > 0
        M = M + 1;
    end
end
end