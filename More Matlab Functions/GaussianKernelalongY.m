function [ Y_GAUSSIAN ] = GaussianKernelalongY( kernelSize, sigma )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
for x=1:kernelSize
    for y=1:kernelSize
        Y_GAUSSIAN(x,y) = -( (x-((kernelSize-1)/2)-1)/( 2* pi * sigma^3 ) ) * exp ( - ( (x-((kernelSize-1)/2)-1)^2 + (y-((kernelSize-1)/2)-1)^2 )/ (2*sigma^2) );
    end
end
 


end

