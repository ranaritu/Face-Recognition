function [T,m1, Eigenfaces, ProjectedImages, imageno]=Eigenface_calculation(imageno);


T=21;
n=1;
aftermean=[];
I=[];


% to call all the images
for i=1:T
    imagee=strcat(int2str(i),'.jpg');
    eval('imagg=imread(imagee);');
    imagg=rgb2gray(imagg);
    
    %rescale the image
    imagg=imresize(imagg,[200,180],'bilinear');
    [m n]=size(imagg);
    temp=reshape(imagg',m*n,1);%to get elements along rows we take imagg'
    I=[I temp];
end

% get the mean of the image
m1=mean(I,2);
 ima=reshape(m1',n,m);
     ima=ima';
   

% Subtract the mean from the image
for i=1:T
    temp=double(I(:,i));
    I1(:,i)=(temp-m1);
end


a1=[];
for i=1:T
    te=double(I1(:,i));
    a1=[a1,te];
end

% get the covariance matrix
a=a1';
covv=a*a';


%get the eigen vector and eigen value from co-variance matrix
[eigenvec eigenvalue]=eig(covv);
d=eig(covv);
sorteigen=[];
eigval=[];
for i=1:size(eigenvec,2);  
    if(d(i)>(0.5e+008))
        
        sorteigen=[sorteigen, eigenvec(:,i)];
        eigval=[eigval, eigenvalue(i,i)];
    end;
end;


Eigenfaces=[];
Eigenfaces=a1*sorteigen;

for i=1:size(sorteigen,2)
    k=sorteigen(:,i);
    tem=sqrt(sum(k.^2));
    sorteigen(:,i)=sorteigen(:,i)./tem;
end
Eigenfaces=a1*sorteigen; 



ProjectedImages=[];
for i = 1 : T
    temp = Eigenfaces'*a1(:,i); 
    ProjectedImages = [ProjectedImages temp]; 
    end
end