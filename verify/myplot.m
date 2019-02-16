x_ = (1:1:20)';
load("verify_kobe.mat")
y1_ = psnr_s;
load("verify_park.mat")
y2_ = psnr_s;
load("verify_traffic.mat")
y3_ = psnr_s;
figure(3)
hold on
plot(x_,y1_,'-r',x_,y2_,'-g',x_,y3_,'-b'); %���ԣ���ɫ�����
legend('kobe','park','traffic')
set(gca,'XTick',0:2:20)
box on
grid on
xlabel('Top-i (%)')  %x����������
ylabel('PSNR (dB)') %y����������