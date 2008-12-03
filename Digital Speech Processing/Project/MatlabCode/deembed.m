function [bit] =  deembed(data,seed,R,IndexSize,N,K1,K2,M)
    
%x : the signal
%M: threshold

if(nargin == 1)
    M=0.3;
    seed=123;
    R=12;
    N=4410;
    IndexSize=50;
    K1=500;
    K2=1000;
end;    

IZero=genPseudoVector(IndexSize*2,seed,K1,K2);
IOne=genPseudoVector(IndexSize*2,seed+1,K1,K2);

bitOne=0;
bitZero=0;


for Rind=1:R
    F=DCT(data((Rind-1)*N+1:Rind*N));
    %Calculus for IZero
    for j=1:IndexSize
        aZero(j)=F(IZero(j));
        bZero(j)=F(IZero(j+IndexSize));
    end;
    aZeroMean=mean(aZero);
    bZeroMean=mean(bZero);
    sum=0;
    for j=1:IndexSize
        sum=sum+(aZero(j)-aZeroMean)^2+(bZero(j)-bZeroMean)^2;
    end;
    SZero=(sum/(IndexSize*(IndexSize-1)))^(1/2)
    TZeroSquare=((aZeroMean-bZeroMean)^2)/SZero^2;
    
    %Calculus for IOne
    for j=1:IndexSize
        aOne(j)=F(IOne(j));
        bOne(j)=F(IOne(j+IndexSize));
    end;
    aOneMean=mean(aOne);
    bOneMean=mean(bOne);
    sum=0;
    for j=1:IndexSize
        sum=sum+(aOne(j)-aOneMean)^2+(bOne(j)-bOneMean)^2;
    end;
    SOne=(sum/(IndexSize*(IndexSize-1)))^(1/2)
    TOneSquare=((aOneMean-bOneMean)^2)/SOne^2;
    
    
    TOneSquare
    TZeroSquare
    
    if(TOneSquare > TZeroSquare)
        if(TOneSquare > M)
            bitOne=bitOne+1;
        end;
    end;
    if(TOneSquare < TZeroSquare)
        if(TZeroSquare > M)
            bitZero=bitZero+1;
        end;
    end;
end;

bitZero
bitOne
if(bitZero > bitOne)
    bit=0;
end;
if(bitZero < bitOne)
    bit=1;
end;
if(bitZero == 0 && bitOne == 0)
    bit=-1;
end;

 
    
