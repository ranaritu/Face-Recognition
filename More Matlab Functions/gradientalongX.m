function [ derivative_x ] = gradientalongX( height,width,kernelSize, X_direction )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
for r=1+ceil(kernelSize/2):height-ceil(kernelSize/2)  
    for c=1+ceil(kernelSize/2):width-ceil(kernelSize/2)  
        reference_row=  r-ceil(kernelSize/2); 
        reference_colum=  c-ceil(kernelSize/2); 
        for yyy=1:kernelSize  
            for yyy_col=1:kernelSize  
                derivative_x = derivative_x+ im(reference_row+yyy-1, reference_colum+yyy_col-1)*X_direction(yyy,yyy_col);
                
            end
        end
    end
end

end

