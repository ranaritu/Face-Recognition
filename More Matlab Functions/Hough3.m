% http://www.mathworks.com/help/images/ref/hough.html?refresh=true


inputImage=imread('cannyPillsetc.pnm');
figure, imshow(inputImage)
SampleFreq=1/3000;

[y,x]=find(inputImage) %returns a vector containing the linear indices of each nonzero element in array
    theImage=inputImage;
    %Set up the Hough variables and define the hough space
    %theImage = flipud(theImage); % returns theImage with its rows flipped
    %in the up-down direction% makes difference in the final output
    [width,height] = size(theImage);
    limitRho = norm([width height]) % returns the Euclidean norm of width and height
   
    rho = (-limitRho:1:limitRho)          
    theta = (0:SampleFreq:pi)

    ThetaNumber = numel(theta); % to get the number of elements
    houghSpace = zeros(numel(rho),ThetaNumber); % initialize the hough space

    %Find the "edge" pixels
    [Xindex,Yindex] = find(theImage);   
    EdgePixelNumber = numel(Xindex);
    Accumulator = zeros(EdgePixelNumber,ThetaNumber);

% Ref: http://stackoverflow.com/questions/9916253/hough-transform-in-matlab-without-using-hough-function
    
    costheta = (0:width-1)'*cos(theta); 
    sintheta = (0:height-1)'*sin(theta); 

    % define the accumulator space
    Accumulator((1:EdgePixelNumber),:) = costheta(Xindex,:) + sintheta(Yindex,:);

     
    for i = (1:ThetaNumber)
        houghSpace(:,i) = hist(Accumulator(:,i),rho);
    end

    pcolor(theta,rho,houghSpace)
    shading flat;
    title('Hough Transform')
    xlabel('Theta (radians)')
    ylabel('Rho (pixels)')
    axis on
    axis normal
    hold on
    colormap(hot)

    
   %http://www.mathworks.com/help/images/ref/houghlines.html 
    
% peaks in hough transform
u = [];
v = [];
[Column, Row] = max(houghSpace);
[rows, cols] = size(theImage);
difference = 45;
threshold = max(max(houghSpace)) - difference;
for i = 1:size(Column, 2)
   if Column(i) > threshold
       v(end + 1) = i;
       u(end + 1) = Row(i);
   end
end

% plot all the detected peaks on  image
hold on;
plot(theta(v), rho(u),'s','color','white');
%plot(x,y,'s','color','white');
hold on;




% Equation of line is given by y = mx+b, where m = -cos(theta)/sin(theta)
% while x is the value of every element in the colums of the image

% http://dsp.stackexchange.com/questions/1958/help-understanding-hough-transform


figure, imshow(inputImage)
%colormap(hot);
hold on;
max_len = 0;
p = 1:size(v,2); % ie length of lines

% define the parameters of line
for i = p
    theta2 = theta(v(i));
    rho2 = rho(u(i));
    m = -(cos(theta2)/sin(theta2))
    b = rho2/sin(theta2)
    x = 1:cols;
    y = m*x+b;
plot(x,y, 'LineWidth',1.5,'Color','green');

% % Plot beginnings and ends of lines
    %plot(x,y(1,1),x,y(1,2),'x','LineWidth',2,'Color','yellow');
   % plot(x,y(2,1),x,y(2,2),'x','LineWidth',2,'Color','red');
%  
%    % Determine the endpoints of the longest line segment
%    len = norm(p.point1 - p.point2);
%    if ( len > max_len)
%    if ( len > max_len)
%       max_len = len;
%       xy_long = xy;
%    end
        hold on;
%    end  
end
