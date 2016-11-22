function [ Y ] = GaussianKernelalongX( kernelSize, sigma )
for x=1:kernelSize
    for y=1:kernelSize
        Y = -( (x-((kernelSize-1)/2)-1)/( 2* pi * sigma^3 ) ) * exp ( - ( (x-((kernelSize-1)/2)-1)^2 + (y-((kernelSize-1)/2)-1)^2 )/ (2*sigma^2) );
    end
end
 
% for x=1:kernelSize
%     for y=1:kernelSize
%         X = -( (y-((kernelSize-1)/2)-1)/( 2* pi * sigma^3 ) ) * exp ( - ( (x-((kernelSize-1)/2)-1)^2 + (y-((kernelSize-1)/2)-1)^2 )/ (2*sigma^2) );
%     end
% end

end

