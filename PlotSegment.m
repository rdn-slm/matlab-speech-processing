function  PlotSegment( Y,S1,S2 )
%  This function to plot the segmentation point in a pattern
%  Y is the signal of the pattern
%  S1 & S2 are the segmentation points in unit sample
 
s1 = S1;  % Reference points
s2 = S2; % Auto seg

subplot(211)
plot(Y);
vline(s1,'r');
title('reference segmentation');

subplot(212)
plot(Y)
vline(s2,'r');
title('auto segmentation');


 
end
