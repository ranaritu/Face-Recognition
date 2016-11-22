 ORIGINAL_IMAGE=imread('keys.pnm');  
 %ORIGINAL_IMAGE =rgb2gray(ORIGINAL_IMAGE); % for pillsetc
 %ORIGINAL_IMAGE = medfilt2(ORIGINAL_IMAGE); %only for keys
 ORIGINAL_IMAGE=im2double(ORIGINAL_IMAGE);    
 [height,width]=size(ORIGINAL_IMAGE);         
 
 
%%Derivatives in x and y
 derivative_x=zeros(height,width);              
 derivative_y=zeros(height,width);    
%  

%%Gaussian kernel
max_hysteresis_thresh = 1.5;
min_hysteresis_thresh =0.05;
sigma =2;
kernelSize = 6*sigma+1;         
Y_GAUSSIAN=zeros(kernelSize,kernelSize);
X_GAUSSIAN=zeros(kernelSize,kernelSize);
 
%%Create gaussian kernels for both x and y directions based on the sigma
%%that was given.
 
for x=1:kernelSize
    for y=1:kernelSize
        Y_GAUSSIAN(x,y) = -( (x-((kernelSize-1)/2)-1)/( 2* pi * sigma^3 ) ) * exp ( - ( (x-((kernelSize-1)/2)-1)^2 + (y-((kernelSize-1)/2)-1)^2 )/ (2*sigma^2) )
    end
end
 
for x=1:kernelSize
    for y=1:kernelSize
        X_GAUSSIAN(x,y) = -( (y-((kernelSize-1)/2)-1)/( 2* pi * sigma^3 ) ) * exp ( - ( (x-((kernelSize-1)/2)-1)^2 + (y-((kernelSize-1)/2)-1)^2 )/ (2*sigma^2) )
    end
end
 
 
GRADIENT =  zeros(height,width);       

 
%%Image Derivatives:
 
for r=1+ceil(kernelSize/2):height-ceil(kernelSize/2)  
    for c=1+ceil(kernelSize/2):width-ceil(kernelSize/2)  
        reference_row=  r-ceil(kernelSize/2); 
        reference_colum=  c-ceil(kernelSize/2); 
        for yyy=1:kernelSize  
            for yyy_col=1:kernelSize  
                derivative_x(r,c) = derivative_x(r,c) + ORIGINAL_IMAGE(reference_row+yyy-1, reference_colum+yyy_col-1)*X_GAUSSIAN(yyy,yyy_col);
            end
        end
    end
end
 
 
for r=1+ceil(kernelSize/2):height-ceil(kernelSize/2)  
    for c=1+ceil(kernelSize/2):width-ceil(kernelSize/2) 
        reference_row=  r-ceil(kernelSize/2); 
        reference_colum=  c-ceil(kernelSize/2); 
        for yyy=1:kernelSize  
            for yyy_col=1:kernelSize 
                derivative_y(r,c) = derivative_y(r,c) + ORIGINAL_IMAGE(reference_row+yyy-1, reference_colum+yyy_col-1)*Y_GAUSSIAN(yyy,yyy_col);
            end
        end
    end
end
 
 
%%Compute the gradient magnitufde based on derivatives in x and y:
 
for r=1+ceil(kernelSize/2):height-ceil(kernelSize/2)  
    for c=1+ceil(kernelSize/2):width-ceil(kernelSize/2)  
        GRADIENT(r,c) = sqrt (derivative_x(r,c)^2 + derivative_y(r,c)^2 );
    end
end
 
%%Perform Non maximum suppression:
 
non_max = GRADIENT;
for r=1+ceil(kernelSize/2):height-ceil(kernelSize/2) 
    for c=1+ceil(kernelSize/2):width-ceil(kernelSize/2)  
       
        %%quantize:
        if (derivative_x(r,c) == 0) tangent = 5;       
        else tangent = (derivative_y(r,c)/derivative_x(r,c));   
        end
        if (-0.4142<tangent & tangent<=0.4142)
            if(GRADIENT(r,c)<GRADIENT(r,c+1) | GRADIENT(r,c)<GRADIENT(r,c-1))
                non_max(r,c)=0;
            end
        end
        if (0.4142<tangent & tangent<=2.4142)
            if(GRADIENT(r,c)<GRADIENT(r-1,c+1) | GRADIENT(r,c)<GRADIENT(r+1,c-1))
                non_max(r,c)=0;
            end
        end
        if ( abs(tangent) >2.4142)
            if(GRADIENT(r,c)<GRADIENT(r-1,c) | GRADIENT(r,c)<GRADIENT(r+1,c))
                non_max(r,c)=0;
            end
        end
        if (-2.4142<tangent & tangent<= -0.4142)
            if(GRADIENT(r,c)<GRADIENT(r-1,c-1) | GRADIENT(r,c)<GRADIENT(r+1,c+1))
                non_max(r,c)=0;
            end
        end
    end
end
 
 
 
 
post_hysteresis = non_max;
 
for r=1+ceil(kernelSize/2):height-ceil(kernelSize/2)  
    for c=1+ceil(kernelSize/2):width-ceil(kernelSize/2)  
        if(post_hysteresis(r,c)>=max_hysteresis_thresh) post_hysteresis(r,c)=1;
        end
        if(post_hysteresis(r,c)<max_hysteresis_thresh & post_hysteresis(r,c)>=min_hysteresis_thresh) post_hysteresis(r,c)=2;
        end
        if(post_hysteresis(r,c)<min_hysteresis_thresh) post_hysteresis(r,c)=0;
        end 
    end
end
 
 
 
vvvv = 1; 
 
while (vvvv == 1)
   
    vvvv = 0;
   
    for r=1+ceil(kernelSize/2):height-ceil(kernelSize/2)  
        for c=1+ceil(kernelSize/2):width-ceil(kernelSize/2)  
            if (post_hysteresis(r,c)>0)      
                if(post_hysteresis(r,c)==2) 
                   
                   
                    if( post_hysteresis(r-1,c-1)==1 | post_hysteresis(r-1,c)==1 | post_hysteresis(r-1,c+1)==1 | post_hysteresis(r,c-1)==1 |  post_hysteresis(r,c+1)==1 | post_hysteresis(r+1,c-1)==1 | post_hysteresis(r+1,c)==1 | post_hysteresis(r+1,c+1)==1 ) post_hysteresis(r,c)=1;
                        vvvv == 1;
                    end
                end
            end
        end
    end
   
end
 
 
 
for r=1+ceil(kernelSize/2):height-ceil(kernelSize/2) 
    for c=1+ceil(kernelSize/2):width-ceil(kernelSize/2)  
        if(post_hysteresis(r,c)==2) 
            post_hysteresis(r,c)==0;
        end   
    end
end
 
figure,  imshow(ORIGINAL_IMAGE), title('Original Image')
figure,  imshow(derivative_x),title('First derivative along x direction'),
figure,  imshow(derivative_y),title('second derivative along y direction'),
figure,  imshow(GRADIENT), title('Gradient'),
figure,  imshow(non_max),title('Image after non maxima suppression'),
figure, imshow(post_hysteresis), title('Final Image after hysterisis'),
         

