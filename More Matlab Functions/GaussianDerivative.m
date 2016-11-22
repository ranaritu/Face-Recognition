function [ Xderivative,Yderivative,MagnitudeofGradient ] = GaussianDerivative( kernelSize, inputImage, height,width, GaussianAlongX,GaussianAlongY )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Xderivative=zeros(height,width);              
 Yderivative=zeros(height,width); 
for r=1+round(kernelSize/2):height-round(kernelSize/2)  
    for c=1+round(kernelSize/2):width-round(kernelSize/2)  
        temp1=  r-round(kernelSize/2); 
        temp2=  c-round(kernelSize/2); 
        for row=1:kernelSize  
            for column=1:kernelSize  
                Xderivative(r,c) = Xderivative(r,c) + inputImage(temp1+row-1, temp2+column-1)*GaussianAlongX(row,column);
                Yderivative(r,c) = Yderivative(r,c) + inputImage(temp1+row-1, temp2+column-1)*GaussianAlongY(row,column);
            end
          MagnitudeofGradient(r,c) = sqrt (Xderivative(r,c)^2 + Yderivative(r,c)^2 );  
        end
    end
end

end

