function [ non_max ] = suppression( derivative_y,derivative_x,kernelSize, width,height )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for r=1+round(kernelSize/2):height-round(kernelSize/2) 
    for c=1+round(kernelSize/2):width-round(kernelSize/2)  
      
            tangent = (derivative_y(r,c)/derivative_x(r,c));
            
        switch(tangent)
            
        case -0.4142<tangent, tangent<=0.4142;
             if(MagnitudeofGradient(r,c)<GRADIENT(r,c+1) || MagnitudeofGradient(r,c)<MagnitudeofGradient(r,c-1))
                non_max(r,c)=0;
            end
        
        case 0.4142<tangent, tangent<=2.4142;
            if(MagnitudeofGradient(r,c)<MagnitudeofGradient(r-1,c+1) || MagnitudeofGradient(r,c)<MagnitudeofGradient(r+1,c-1))
                non_max(r,c)=0;
            end
        
        case ( abs(tangent) >2.4142)
            if(MagnitudeofGradient(r,c)<MagnitudeofGradient(r-1,c) || MagnitudeofGradient(r,c)<MagnitudeofGradient(r+1,c))
                non_max(r,c)=0;
            end
        
        case (-2.4142<tangent & tangent<= -0.4142)
            if(MagnitudeofGradient(r,c)<MagnitudeofGradient(r-1,c-1) || MagnitudeofGradient(r,c)<MagnitudeofGradient(r+1,c+1))
                non_max(r,c)=0;
            end
        end
    end
end

end

