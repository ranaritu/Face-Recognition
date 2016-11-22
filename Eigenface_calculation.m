function [T,m1, Eigenfaces, ProjectedImages, imageno]=Eigenface_calculation(imageno)

% Number of images in training set
T=imageno;
n=1;
aftermean=[];
I=[];
figure(1);

% to call all the images
for i=1:T
    imagee=strcat(int2str(i),'.jpg');

    eval('imagg=imread(imagee);');
    subplot(ceil(sqrt(T)),ceil(sqrt(T)),i)% plot them as matrix
    imagg=rgb2gray(imagg);
    
    %rescale the image
    imagg=imresize(imagg,[200,180],'bilinear');
    [m n]=size(imagg);
    imshow(imagg)
    temp=reshape(imagg',m*n,1);%to get elements along rows we take imagg'
    I=[I temp];
end

% get the mean of the image
m1=mean(I,2);
 ima=reshape(m1',n,m);
     ima=ima';
     figure(2),imshow(ima);

% Subtract the mean from the image
for i=1:T
    temp=double(I(:,i));
    I1(:,i)=(temp-m1);
end

% display the image after subtracing the mean
for i=1:T
    subplot(ceil(sqrt(T)),ceil(sqrt(T)),i);
    imagg1=reshape(I1(:,i),n,m);
    imagg1=imagg1';
    [m n]=size(imagg1);
    imshow(imagg1);
end


a1=[];
for i=1:T% to change the format of values to double
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
for i=1:size(eigenvec,2);  %takes no of col of eigenvec
    if(d(i)>(0.5e+008))% we can take any value to suit our algorithm
        % this values generally are taken by trial and error
        sorteigen=[sorteigen, eigenvec(:,i)];
        eigval=[eigval, eigenvalue(i,i)];
    end;
end;


Eigenfaces=[];
Eigenfaces=a1*sorteigen;% got matrix of principal Eigenfaces

for i=1:size(sorteigen,2)
    k=sorteigen(:,i);
    tem=sqrt(sum(k.^2));
    sorteigen(:,i)=sorteigen(:,i)./tem;
end
Eigenfaces=a1*sorteigen; 
figure(3);


% display the eigen face
for i=1:size(Eigenfaces,2)
    ima=reshape(Eigenfaces(:,i)',n,m);
    ima=ima';
    %ima=histeq(ima,255);
      subplot(ceil(sqrt(T)),ceil(sqrt(T)),i)
     imshow(ima);
end


ProjectedImages=[];
for i = 1 : T
    temp = Eigenfaces'*a1(:,i); % Projection of centered images into facespace
    ProjectedImages = [ProjectedImages temp]; 
end
    
end

