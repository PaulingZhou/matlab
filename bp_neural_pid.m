%%--  Bp Based PID Control  --%%
clear all;
close all;

xite = 0.25;
alfa = 0.05;

S = 1;          %Singal Type

IN = 4;
H  = 5;
OUT= 3;
if S == 1
    wi = 0.5*rands(H,IN);
    wi_1 = wi;
    wi_2 = wi;
    wi_3 = wi;
    wo = 0.5*rands(OUT,H);
    wo_1 = wo;
    wo_2 = wo;
    wo_3 = wo;
end

if S == 2
    wi = 0.5*rands(H,IN);
    wi_1 = wi;
    wi_2 = wi;
    wi_3 = wi;
    wo = 0.5*rands(OUT,H);
    wo_1 = wo;
    wo_2 = wo;
    wo_3 = wo;
end

x = [0 0 0];
u_1 = 0;
u_2 = 0;
u_3 = 0;
u_4 = 0;
u_5 = 0;

y_1 = 0;
y_2 = 0;
y_3 = 0;

Oh = zeros(H,1);
l = Oh;
error_2 = 0;
error_1 = 0;

ts = 0.001;
for k = 1:6000
    time(k) = k*ts;
    if S == 1       %Step Signal
        rin(k) = 1.0;
    elseif S == 2       %Trigonometric Signal
        rin(k) = sin(1*2*pi*k*ts);
    end
    % Unlinear Model
    a(k) = 1.2*(1-0.8*exp(-0.1*k));
    yout(k) = a(k)*y_1/(1+y_1^2)+u_1;
    error(k) = rin(k) - yout(k);
    
    xi = [rin(k) yout(k) error(k) 1];
    x(1) = error(k)-error_1;
    x(2) = error(k);
    x(3) = error(k)-2*error_1+error_2;
    
    epid = [x(1);x(2);x(3)];
    I= xi*wi';
    for j= 1:H
        Oh(j) = (exp(I(j))-exp(-I(j)))/(exp(I(j))+exp(-I(j))); %Middle Layer
    end
    K = wo*Oh;
    for l = 1;OUT
        K(k) = exp(K(l))/(exp(K(l))+exp(-K(l))); %Getting kp,ki,kd;
    end
    kp(k) = K(1);
    ki(k) = K(2);
    kd(k) = K(3);
    Kpid = [kp(k) ki(k) kd(k)];
    du(k)= Kpid * epid;
    u(k) = u_1 + du(k);
    if u(k) < -10
        u(k) = -10;
    end
    if u(k) > 10
        u(k) = 10;
    end
    dyu(k) = sign((yout(k)-y_1)/(u(k)-u_1+0.0000001));
    
    %Output Layer
    for j = 1:OUT
        dK(j) = 2/(exp(K(j))+exp(-K(j)))^2;
    end
    for l = 1:OUT
        delta3(l) = error(k)*dyu(k)*epid(l)*dK(l);
    end
    
    for l = 1:OUT
        for i = 1:H
            d_wo = xite*delta3(l)*Oh(i)+alfa*(wo_1-wo_2);
        end
    end
    
    wo = wo_1+d_wo+alfa*(wo_1-wo_2);
    %Hidden Layer
    for i = 1:H
        dO(i) = 4/(exp(I(i))+exp(-I(i)))^2;
    end
    sigma = delta3*wo;
    for i = 1:H
        delta2(i) = dO(i)*sigma(i);
    end
    
    d_wi = xite * delta2' * xi;
    wi = wi_1 + d_wi + alfa * (wi_1-wi_2);
    
    %Prarmeters Update
    u_5 = u_4;
    u_4 = u_3;
    u_3 = u_2;
    u_2 = u_1;
    u_1 = u(k);
    
    y_2 = y_1;
    y_1 = yout(k);
    
    wo_3 = wo_2;
    wo_2 = wo_1;
    wo_1 = wo;
    
    wi_3 = wi_2;
    wi_2 = wi_1;
    wi_1 = wi;
    
    error_2 = error_1;
    error_1 = error(k);
end

figure(1);
plot(time,rin,'r',time,yout,'b');

figure(2);
plot(time,error,'r');

figure(3);
plot(time,u,'r');

figure(4);
subplot(311);
plot(time,kp,'r');
subplot(312);
plot(time,ki,'g');
subplot(313);
plot(time,kd,'b');
