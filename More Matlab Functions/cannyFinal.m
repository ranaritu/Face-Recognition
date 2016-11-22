 inputImage=imread('keys.pnm');  
 %inputImage =rgb2gray(inputImage); % for pillsetc
 %inputImage = medfilt2(inputImage); %only for keys
 inputImage=im2double(inputImage);    
 [height,width]=size(inputImage);         
 figure(1),  imshow(inputImage), title('Original Image')
 Xderivative=zeros(height,width);              
 Yderivative=zeros(height,width);  
 MaxThreshold = 1.5;
 MinThreshold =0.05;
 sigma =1;
 kernelSize = 7;         
 GaussianAlongY=zeros(kernelSize,kernelSize);
 GaussianAlongX=zeros(kernelSize,kernelSize);
 MagnitudeofGradient =  zeros(height,width);
 
%http://stackoverflow.com/questions/13193248/how-to-make-a-gaussian-filter-in-matlab
% gaussian filter

 
for x=1:kernelSize
    for y=1:kernelSize
        a1 = (x-((kernelSize-1)/2)-1)/( 2* pi * sigma^3 );
        a2 = (x-((kernelSize-1)/2)-1)^2;
        a3 = (y-((kernelSize-1)/2)-1)^2;
        a4 = (2*sigma^2);
        GaussianAlongY(x,y) = -( a1 ) * exp (-(a2+ a3)/ a4 );
    end
end
 
for x=1:kernelSize
    for y=1:kernelSize
        b1 = (y-((kernelSize-1)/2)-1)/( 2* pi * sigma^3 );
        b2 = (x-((kernelSize-1)/2)-1)^2;
        b3 = (y-((kernelSize-1)/2)-1)^2;
        b4 = (2*sigma^2);
        GaussianAlongX(x,y) = -( b1 ) * exp (-( b2 + b3 )/ b4  );
    end
end

%derivative(r,c)= GaussianDerivative( kernelSize, inputImage, height,width, GaussianAlongX(r,c),GaussianAlongY(r,c) )
 
       

 
%%caompute the x and y derivatives of the input image
u1 = 1+round(kernelSize/2);
u2 = height-round(kernelSize/2);
v1 = 1+round(kernelSize/2);
v2 = width-round(kernelSize/2);

 
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
 
figure(2),  imshow(Xderivative),title('First derivative along x direction'), 
figure(3),  imshow(Yderivative),title('Second derivative along y direction'),
figure(4),  imshow(MagnitudeofGradient), title('Gradient'),

%%Perform Non maximum suppression:
 
non_max = MagnitudeofGradient;

%non_max = suppression(derivative_y,derivative_x,kernelSize, width,height)
for r=1+round(kernelSize/2):height-round(kernelSize/2) 
    for c=1+round(kernelSize/2):width-round(kernelSize/2)  
      
            tangent = (Yderivative(r,c)/Xderivative(r,c))
            
        switch(tangent)
            
        case -0.4142<tangent, tangent<=0.4142;
             if(MagnitudeofGradient(r,c)<GRADIENT(r,c+1) | MagnitudeofGradient(r,c)<MagnitudeofGradient(r,c-1))
                non_max(r,c)=0;
            end
        
        case 0.4142<tangent, tangent<=2.4142;
            if(MagnitudeofGradient(r,c)<MagnitudeofGradient(r-1,c+1) | MagnitudeofGradient(r,c)<MagnitudeofGradient(r+1,c-1))
                non_max(r,c)=0;
            end
        
        case ( abs(tangent) >2.4142)
            if(MagnitudeofGradient(r,c)<MagnitudeofGradient(r-1,c) | MagnitudeofGradient(r,c)<MagnitudeofGradient(r+1,c))
                non_max(r,c)=0;
            end
        
        case (-2.4142<tangent & tangent<= -0.4142)
            if(MagnitudeofGradient(r,c)<MagnitudeofGradient(r-1,c-1) | MagnitudeofGradient(r,c)<MagnitudeofGradient(r+1,c+1))
                non_max(r,c)=0;
            end
        end
    end
end

 
 figure(5),  imshow(non_max),title('Image after non maxima suppression'),
 
 
FinalResult = non_max;
 
for r=1+round(kernelSize/2):height-round(kernelSize/2)  
    for c=1+round(kernelSize/2):width-round(kernelSize/2)  
       
        if(FinalResult(r,c)>=MaxThreshold)
            FinalResult(r,c)=1;
        
        elseif(FinalResult(r,c)<MaxThreshold & FinalResult(r,c)>=MinThreshold)
            FinalResult(r,c)=2;
        
        elseif(FinalResult(r,c)<MinThreshold) 
            FinalResult(r,c)=0;
        
        end 
     end
end
 
 
 
temp = 1; 
 
while (temp == 1)
   
    temp = 0;
   
    for r=1+round(kernelSize/2):height-round(kernelSize/2)  
        for c=1+round(kernelSize/2):width-round(kernelSize/2)  
            if (FinalResult(r,c)>0)      
                if(FinalResult(r,c)==2)                
                    if( FinalResult(r-1,c-1)==1 | FinalResult(r-1,c)==1 | FinalResult(r-1,c+1)==1 | FinalResult(r,c-1)==1 |  FinalResult(r,c+1)==1 | FinalResult(r+1,c-1)==1 | FinalResult(r+1,c)==1 | FinalResult(r+1,c+1)==1 )
                        FinalResult(r,c)=1;
                        temp = 1;
                    end
                   				
                end
            end
          if(FinalResult(r,c)==2) 
             FinalResult(r,c)=0;
         end    
            
          end
        end
    end
   

 
figure(6), imshow(FinalResult), title('Final Image after hysterisis'),
         







