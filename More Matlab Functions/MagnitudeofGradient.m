function [ G ] = MagnitudeofGradient( height,width,derivative_x,derivative_y, kernelSize )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

for r=1+ceil(kernelSize/2):height-ceil(kernelSize/2)  
    for c=1+ceil(kernelSize/2):width-ceil(kernelSize/2)  
        G = sqrt (derivative_x^2 + derivative_y^2 );
    end
end
end

