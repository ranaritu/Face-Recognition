% http://www.mathworks.com/help/images/ref/hough.html?refresh=true
% http://www.mathworks.com/help/images/ref/houghlines.html


I = imread('Pillsetc.pnm');
I  = rgb2gray(I); % use thi for pillsetc.pnm
I = medfilt2(I);
BW = edge(I,'canny');
imshow(BW);

[H,theta,rho] = hough(BW);
figure
imshow(imadjust(mat2gray(H)),[],...
       'XData',theta,...
       'YData',rho,...
       'InitialMagnification','fit');
xlabel('\theta (degrees)')
ylabel('\rho')
axis on
axis normal
hold on
colormap(hot)


% Find the peaks in the Hough transform matrix, H, using the houghpeaks function.

P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = theta(P(:,2));
y = rho(P(:,1));
plot(x,y,'s','color','black');


lines = houghlines(BW,theta,rho,P,'FillGap',5,'MinLength',7);
figure, imshow(I), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');






% %% backward projection
% 
% 
% if nargin < 4
%    nhood = size(H)/50;
%    % Make sure the neighborhood size is odd.
%    nhood = max(2*ceil(nhood/2) + 1, 1);
% end
% if nargin < 3
%    threshold = 0.5 * max(H(:));
% end
% if nargin < 2
%    numpeaks = 1;
% end
% 
% done = false;
% hnew = H; r = []; c = [];
% while ~done
%    [p, q] = find(hnew == max(hnew(:)));
%    p = p(1); q = q(1);
%    if hnew(p, q) >= threshold
%       r(end + 1) = p; c(end + 1) = q;
% 
%       % Suppress this maximum and its close neighbors.
%       p1 = p - (nhood(1) - 1)/2; p2 = p + (nhood(1) - 1)/2;
%       q1 = q - (nhood(2) - 1)/2; q2 = q + (nhood(2) - 1)/2;
%       [pp, qq] = ndgrid(p1:p2,q1:q2);
%       pp = pp(:); qq = qq(:);
% 
%       % Throw away neighbor coordinates that are out of bounds in
%       % the rho direction.
%       badrho = find((pp < 1) | (pp > size(H, 1)));
%       pp(badrho) = []; qq(badrho) = [];
% 
%       % For coordinates that are out of bounds in the theta
%       % direction, we want to consider that H is antisymmetric
%       % along the rho axis for theta = +/- 90 degrees.
%       theta_too_low = find(qq < 1);
%       qq(theta_too_low) = size(H, 2) + qq(theta_too_low);
%       pp(theta_too_low) = size(H, 1) - pp(theta_too_low) + 1;
%       theta_too_high = find(qq > size(H, 2));
%       qq(theta_too_high) = qq(theta_too_high) - size(H, 2);
%       pp(theta_too_high) = size(H, 1) - pp(theta_too_high) + 1;
% 
%       % Convert to linear indices to zero out all the values.
%       hnew(sub2ind(size(hnew), pp, qq)) = 0;
% 
%       done = length(r) == numpeaks;
%    else
%       done = true;
%    end
% end