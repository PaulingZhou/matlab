%%%%%%%%%2014��11��14��%%%%%%%%%%
% -------ѧϰBP������-------- %
%����BP�㷨�ĵ�һ�׶�  ѧϰ��
%initialization
lr              = 0.05  ;
err_goal        = 0.00001 ;
max_epoch       = 10000;
X               = [1 2;-1 1;1 3];
T               = [1 1;1 1];
a               = 1;
%initialization Wki Wij
[M,N]           = size(X);
q               = 10;
[L,N]           = size(T);
Wij             = rand(q,M);
Wki             = rand(L,q);
Wij0            = zeros(size(Wij));
Wki0            = zeros(size(Wki));

for epoch       = 1:max_epoch
    %�����������Ԫ���
    NETi        = Wij*X;
    for j       = 1:N
        for i   = 1:q
        Oi(i,j) = 2/(1+exp(-NETi(i,j)))-1; 
        end
    end
    %������������Ԫ���
    NETk        = Wki*Oi;
    for i       = 1:N
        for k   = 1:L
        Ok(k,i) = 2/(1+exp(-NETk(k,i)))-1; 
        end
    end
%   Oi          = tansig(Wij*X,b1);
%   Ok          = purelin(Wki*Oi,b2);
    %��������
    E           = ((T-Ok)'*(T-Ok))/2;
%   deltak      = deltalin(Ok,E);
%   deltai      = deltatan(Oi,deltak,Wki);
    deltak      = Ok.*(1-Ok).*(T-Ok);
    deltai      = Oi.*(1-Oi).*(deltak'*Wki)';
    w           = Wki;
%   [dWki,db2]  = learnbp(Oi,deltak,lr);
    %����������Ȩϵ��
    dWki        = lr*deltak*Oi'+a*(Wki-Wki0);
    Wki         = Wki +dWki;
    wki0        = w;
    w           = Wij;
%   [dWij,db1]  = learnbp(X,deltai,lr);
    %�����������Ȩϵ��
    dWij        = lr*deltai*X'+a*(Wij-Wij0);
    Wij         = Wij +dWij;
    if (E < err_goal)
        break;
    end
end
%��ʾ�������
epoch
%BP�㷨�ĵڶ��׶�  ������
X1              = X;
% Oi            = tansig(Wij*X1,b1);
% Ok            = purelin(Wki*Oi,b2);
%�����������Ԫ���
NETi            = Wij*X1;
for j           = 1:N
    for i       = 1:q
    Oi(i,j)     = 2/(1+exp(-NETi(i,j)))-1; 
    end
end
%������������Ԫ���
NETi            = Wki*Oi;
for i           = 1:N
    for k       = 1:L
    Oi(k,i)     = 2/(1+exp(-NETk(k,i)))-1; 
    end
end
%��ʾ���������    
Ok
