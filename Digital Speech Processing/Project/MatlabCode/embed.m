function [x] =  embed(bit,C, N, K1, K2 , R, file, seed, IndexSize)
%bit: Bit to write
%C : parameters to calculate the new sample
%N : Size of the DCT
%K1 - K2 : Limit of the Index function
%R : number of frame in which the data will be added
%file : name of the speech file
%Key : key of the speech file

if(nargin == 0)
    bit=1;
    file='sp1.wav';
    C=120;
    N=4410;
    K1=500;
    K2=1000;
    R=12;
    seed=123;
    IndexSize=50;
end;

[x,fs]=wavread(file);
I=genPseudoVector(IndexSize*2,seed+bit,K1,K2);

for Rind=1:R
    F=DCT(x((Rind-1)*N+1:Rind*N));
    a(1:IndexSize)=0;
    b(1:IndexSize)=0;
    for j=1:IndexSize
        a(j)=F(I(j));
        b(j)=F(I(j+IndexSize));
    end;
    aMean=mean(a);
    bMean=mean(b);
    sum=0;
    for j=1:IndexSize
        sum=sum+(a(j)-aMean)^2+(b(j)-bMean)^2;
    end;
    S=(sum/(IndexSize*(IndexSize-1)))^(1/2);
    for j=1:IndexSize
        a(j)=a(j)+sign(aMean-b(j))*(C^(1/2))*S/2;
        b(j)=b(j)+sign(bMean-a(j))*(C^(1/2))*S/2;
    end;
    for j=1:IndexSize
        F(I(j))=a(j);
        F(I(j+IndexSize))=b(j);
    end;
    x((Rind-1)*N+1:Rind*N)=idct(F);
end;


    