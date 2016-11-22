
%READ AN 2D IMAGE
Img=imread('ct_scan.pnm');
Img = rgb2gray(Img);
figure,imshow(Img);title('Original');


A = imnoise(Img,'Gaussian',0.1,0.002);
%Image with noise
figure,imshow(A); title('With Gaussian Noise 0.7,0.002');


AA=zeros(size(A)+2); % modify noisy image
output=zeros(size(A)); % padd with zeros


        for m=1:size(A,1)
            for n=1:size(A,2)
                AA(m+1,n+1)=A(m,n);
            end
        end
     
       
for i= 1:size(AA,1)-2
    for j=1:size(AA,2)-2
        window=zeros(9,1);
        inc=1;
        for x=1:3
            for y=1:3
                window(inc)=AA(i+x-1,j+y-1);
                inc=inc+1;
            end
        end
       
        
        medianFilter=sort(window);
        
        output(i,j)=medianFilter(5);
       
    end
end
%convert the output matrix into 0-255 range image 
output=uint8(output);

figure,imshow(output); title('Image after median filtering');
