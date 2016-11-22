function varargout = simple_gui(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simple_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @simple_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before simple_gui is made visible.
function simple_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simple_gui (see VARARGIN)

% Choose default command line output for simple_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simple_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simple_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)



 imageno =10;


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
    [m n]=size(imagg)
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
      subplot(ceil(sqrt(T)),ceil(sqrt(T)),i)
     imshow(ima);
end


ProjectedImages=[];
for i = 1 : T
    temp = Eigenfaces'*a1(:,i); % Projection of centered images into facespace
    ProjectedImages = [ProjectedImages temp]; 
end


save Eigenface.mat;





guidata(hObject,handles);




function pushbutton2_Callback(hObject, eventdata, handles)

load Eigenface.mat;



MeanInputImage=[];
[fname pname]=uigetfile('*.jpg','Select the input image for recognition');
InputImage=imread(fname);
InputImage=rgb2gray(InputImage);
InputImage=imresize(InputImage,[200 180],'bilinear');%resizing of input image. This is a part of preprocessing techniques of images
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
            age = 22;
        case 2
            name ='Eliyahu Goldratt';
            age= 25;
        case 3
            name = 'Anpage';
            age = 35;
        case 4
            name ='Rizwana';
            age = 30;
        case 5
            name ='Rihana';
            age = 48;
        case 6
            name = 'Seema';
            age = 19;
        case 7
            name ='Kasana';
            age = 27;
        case 8
            name ='Hanifa';
            age= 33;
        case 9
            name ='Alefiya';
            age= 22;
        case 10
            name ='Mamta';
            age = 50;
        case 11
            name ='Mayawati';
            age = 39;
        case 12
            disp('Elizabeth');
            disp('Age=87');
        case 13
            disp('Cecelia Ahern');
            disp('Age=78');
        case 14
            disp('Shaista Khatun');
            disp('Age=56');
        case 15
            disp('Rahisa Khatun');
            disp('Age=45');
        case 16
            disp('Ruksana');
            disp('Age=64');
        case 17
            disp('Parizad Zorabian');
            disp('Age=38');
        case 18
            disp('Heena kundanani');
            disp('Age=20');
        case 19
              disp('Setu Savani');
              disp('Age=21');
         case 20
             disp('Mohd Zubair Saifi');
             disp('Age=20');
         otherwise
            disp('Image in database but name unknown')
    end
% disp(name)
% disp(age)
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
save test2.mat 



set(handles.edit1,'string',name);
set(handles.edit2,'string',age);
save Eigenface.mat;


axes(handles.axes1)
imshow(outputimage);
guidata(hObject,handles);


function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete Eigenface.mat;
delete test2.mat;



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
quit;



% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)

[fname pname]=uigetfile('*.jpg','Image Database');
InputImage=imread(fname);




% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)

h1 = figure(simple_gui);
figure(1);
figure(2);
figure(3);
figure(4);
figure(5);
figure(6);
figure(7);
figure(8);

set(h1, 'HandleVisibility', 'off');

%uiwait(msgbox('Click OK to close all the figures'));

close all;

% set(h2, 'HandleVisibility', 'on');
% set(h1, 'HandleVisibility', 'on');


















function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

