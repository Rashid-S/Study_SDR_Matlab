clear all;
M=[0:30];          
mu1=pi/6; mu2=pi/12;
theta1=zeros(1,length(M));
theta2=zeros(1,length(M)); 
for m=2:length(M)
    theta1(m)=theta1(m-1)+mu1;
    theta2(m)=theta2(m-1)+mu2;
end
subplot(2,1,1); 
plot(M,theta1/pi,'o-'); hold on; 
plot(M,theta2/pi,'s-'); grid on;
legend('\pi/6', '\pi/12','location','northwest');
ylabel('\theta [рад]'); xlabel('индекс выборки m');
subplot(2,1,2); 
plot(M,cos(theta1),'o-'); hold on; 
plot(M,cos(theta2),'s-'); grid on;
legend('\pi/6', '\pi/12','location','northwest');
ylabel('cos(\theta)'); xlabel('индекс выборки m');