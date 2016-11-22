function non_maxima = non_max(image)

kernelSize = 6*sigma+1; 
for r=1+ceil(kernelSize/2):height-ceil(kernelSize/2) 
    for c=1+ceil(kernelSize/2):width-ceil(kernelSize/2)  
       
        %%quantize:
        if (derivative_x(r,c) == 0) tangent = 5;       
        else tangent = (derivative_y(r,c)/derivative_x(r,c));   
        end
        if (-0.4142<tangent & tangent<=0.4142)
            if(GRADIENT(r,c)<GRADIENT(r,c+1) || GRADIENT(r,c)<GRADIENT(r,c-1))
                non_max(r,c)=0;
            end
        end
        if (0.4142<tangent & tangent<=2.4142)
            if(GRADIENT(r,c)<GRADIENT(r-1,c+1) || GRADIENT(r,c)<GRADIENT(r+1,c-1))
                non_max(r,c)=0;
            end
        end
        if ( abs(tangent) >2.4142)
            if(GRADIENT(r,c)<GRADIENT(r-1,c) | GRADIENT(r,c)<GRADIENT(r+1,c))
                non_max(r,c)=0;
            end
        end
        if (-2.4142<tangent & tangent<= -0.4142)
            if(GRADIENT(r,c)<GRADIENT(r-1,c-1) || GRADIENT(r,c)<GRADIENT(r+1,c+1))
                non_max(r,c)=0;
            end
        end
    end
end
 
 end 