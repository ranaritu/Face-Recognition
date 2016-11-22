function [outputimage,name,age]=Recognition(T,m1, Eigenfaces, ProjectedImages, imageno);
 
MeanInputImage=[];
[fname pname]=uigetfile('*.jpg','Select the input face for recognition');
InputImage=imread(fname);
InputImage=rgb2gray(InputImage);
InputImage=imresize(InputImage,[200 180],'bilinear');
[m n]=size(InputImage);
imshow(InputImage);
Imagevector=reshape(InputImage',m*n,1);%to get elements along rows as we take InputImage'
MeanInputImage=double(Imagevector)-m1;
ProjectInputImage=Eigenfaces'*MeanInputImage;% here we get the weights of the input image with respect to our eigenfaces
% next we need to euclidean distance of our input image and compare it
% with our face space and check whether it matches the answer...we need
% to take the threshold value by trial and error methods
Euclideandistance=[];
for i=1:T
    temp=ProjectedImages(:,i)-ProjectInputImage;
    Euclideandistance=[Euclideandistance temp];
end
% the above statements will get you a matrix of Euclidean distance and you
% need to normalize it and then find the minimum Euclidean distance
tem=[];
for i=1:size(Euclideandistance,2)
    k=Euclideandistance(:,i);
    tem(i)=sqrt(sum(k.^2));
end
% We now set some threshold values to know whether the image is face or not
% and if it is a face then if it is known face or not
% The threshold values taken are done by trial and error methods
[MinEuclid, index]=min(tem);
if(MinEuclid<0.8e008)
if(MinEuclid<0.35e008)
    outputimage=(strcat(int2str(index),'.jpg'));
   
    switch index 
        case 1
            name = 'Jonathan Swift';
            age = '22';
        case 2
            name ='Eliyahu Goldratt';
            age= '25';
        case 3
            name = 'Anpage';
            age = '35';
        case 4
            name ='Rizwana';
            age = '30';
        case 5
            name ='Rihana';
            age = '48';
        case 6
            name = 'Seema';
            age = '19';
        case 7
            name ='Kasana';
            age = '27';
        case 8
            name ='Hanifa';
            age= '33';
        case 9
            name ='Alefiya';
            age= '22';
        case 10
            name ='Mamta';
            age = '50';
        case 11
            name ='Mayawati';
            age = '39';
        case 12
            name ='Elizabeth';
            age='87';
        case 13
             name ='Cecelia Ahern';
            age ='78';
        case 14
             name ='Shaista Khatun';
           age ='56';
        case 15
             name ='Rahisa Khatun';
            age ='45';
        case 16
             name ='Ruksana';
            age ='64';
        case 17
             name ='Parizad Zorabian';
            age ='38';
        case 18
             name ='Heena kundanani';
            age ='20';
        case 19
               name ='Setu Savani';
              age ='21';
         case 20
              name ='Mohd Zubair Saifi';
             age ='20';
        case 21 
            name='Rajesh Mishra';
            age ='38';
        case 22 
            name='Rajesh Mishra';
            age ='38';
        case 23 
            name='Rajesh Mishra';
            age ='38';
         case 24 
            name='Rajesh Mishra';
            age ='38';   
         case 25 
            name='Rajesh Mishra';
            age ='38';   
         case 26 
            name='Mark Savani';
            age ='30';
            
            
         otherwise
             name ='Image in database but name unknown';
    end

else
    name ='No matches found';
    age = 'Unavailable';
    outputimage=0;
end
else
    name ='Image is not a face';
    age ='N/A';
    outputimage=0;
end

end
