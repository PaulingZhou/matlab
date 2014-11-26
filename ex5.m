%%%%%%%%%2014年11月14日%%%%%%%%%%
% -------学习BP神经网络-------- %
%两层BP算法的第一阶段  学习期
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
    %计算隐层各神经元输出
    NETi        = Wij*X;
    for j       = 1:N
        for i   = 1:q
        Oi(i,j) = 2/(1+exp(-NETi(i,j)))-1; 
        end
    end
    %计算输出层个神经元输出
    NETk        = Wki*Oi;
    for i       = 1:N
        for k   = 1:L
        Ok(k,i) = 2/(1+exp(-NETk(k,i)))-1; 
        end
    end
%   Oi          = tansig(Wij*X,b1);
%   Ok          = purelin(Wki*Oi,b2);
    %计算误差函数
    E           = ((T-Ok)'*(T-Ok))/2;
%   deltak      = deltalin(Ok,E);
%   deltai      = deltatan(Oi,deltak,Wki);
    deltak      = Ok.*(1-Ok).*(T-Ok);
    deltai      = Oi.*(1-Oi).*(deltak'*Wki)';
    w           = Wki;
%   [dWki,db2]  = learnbp(Oi,deltak,lr);
    %调整输出层加权系数
    dWki        = lr*deltak*Oi'+a*(Wki-Wki0);
    Wki         = Wki +dWki;
    wki0        = w;
    w           = Wij;
%   [dWij,db1]  = learnbp(X,deltai,lr);
    %调整隐含层加权系数
    dWij        = lr*deltai*X'+a*(Wij-Wij0);
    Wij         = Wij +dWij;
    if (E < err_goal)
        break;
    end
end
%显示计算次数
epoch
%BP算法的第二阶段  工作期
X1              = X;
% Oi            = tansig(Wij*X1,b1);
% Ok            = purelin(Wki*Oi,b2);
%计算隐层各神经元输出
NETi            = Wij*X1;
for j           = 1:N
    for i       = 1:q
    Oi(i,j)     = 2/(1+exp(-NETi(i,j)))-1; 
    end
end
%计算输出层各神经元输出
NETi            = Wki*Oi;
for i           = 1:N
    for k       = 1:L
    Oi(k,i)     = 2/(1+exp(-NETk(k,i)))-1; 
    end
end
%显示输出层的输出    
Ok
