function [vectorIndex] = genPseudoVector(size, seed , minValue, maxValue)

%load md5 function first
%personnal pseudo random generation function.
%size : size of the pseudo vector to Generate
%seed : seed of the pseudo vector

%initialization of the vector
if(nargin == 0)
    size=12;
    seed=38;
    minValue=2340;
    maxValue=12000;
end;


vectorIndex(1:size)=0;

md=double(md5(seed));
for i=1:size
    
    if(mod(md(mod(i,32)+1),2)==0)
        %We will incresea the value
        last=1;
        j=0;
        firstval=md(mod(i,32)+1);
        while(firstval<minValue)
            j=j+1;
            firstval=firstval+md(mod(j,32)+1);            
        end;
    end;
    if(mod(md(mod(i,32)+1),2)==1)
        last=-1;
        %We will decrease the value
        firstval=md(mod(i,32)+1);
        j=32;
        while(firstval<minValue)
            j=j-1;
            firstval=firstval+md(mod(j,32)+1);
        end;
    end;
    count=0;
    iti=0;
    maxC=md(mod(j+i,32)+1)*md(mod(firstval,32)+1);
    while(count < maxC)
        iti=iti+1;
        if(last==-1)
            firstval=firstval-mod(md(mod(iti,32)+1),maxValue-minValue);
        end;
        if(last==1)
            firstval=firstval+mod(md(mod(iti,32)+1),maxValue-minValue);
        end;
        if(firstval < minValue)
            last=1;
        end;
        if(firstval > maxValue)
            last=-1;
        end;
        if(firstval > minValue && firstval <maxValue)
            count=count+1;
        end;
    end;
    vectorIndex(i)=firstval;    
end;