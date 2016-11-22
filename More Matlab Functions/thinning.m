function [ w ] = thinning( f1,f2,f3 )
if( f2>f1 && f2>f3)
    w =f2;
else 
    w= 0;
end
end