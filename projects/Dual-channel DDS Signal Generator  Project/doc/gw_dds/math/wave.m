clc; %清除命令行命令
clear all; %清除工作区变量,释放内存空间
F1=1; %信号频率
Fs=2^10; %采样频率
P1=0; %信号初始相位
N=2^10; %采样点数
t=[0:1/Fs:(N-1)/Fs]; %采样时刻
ADC=2^7 - 1; %直流分量
A=2^7; %信号幅度
%创建mif文件
fild = fopen('wave.txt','wt');
%写入mif文件头
fprintf(fild, '%s\n','#WIDTH=8;'); %位宽
fprintf(fild, '%s\n\n','#DEPTH=4096;'); %深度
%生成正弦信号
s=A*sin(2*pi*F1*t + pi*P1/180) + ADC;
plot(s); %绘制图形
%写入数据
for i = 1:N
s0(i) = round(s(i)); %对小数四舍五入以取整
if s0(i) <0 %负1强制置零
s0(i) = 0
end
fprintf(fild, '%s\n',dec2bin(s0(i),8)); %数据写入
end
s=A*square(2*pi*F1*t + pi*P1/180) + ADC;
plot(s); %绘制图形
%写入数据
for i = 1:N
s0(i) = round(s(i)); %对小数四舍五入以取整
if s0(i) <0 %负1强制置零
s0(i) = 0
end
fprintf(fild, '%s\n',dec2bin(s0(i),8)); %数据写入
end
s=A*sawtooth(2*pi*F1*t + pi*P1/180,0.5) + ADC;
plot(s); %绘制图形
%写入数据
for i = 1:N
s0(i) = round(s(i)); %对小数四舍五入以取整
if s0(i) <0 %负1强制置零
s0(i) = 0
end
fprintf(fild, '%s\n',dec2bin(s0(i),8)); %数据写入
end
s=A*sawtooth(2*pi*F1*t + pi*P1/180) + ADC;
plot(s); %绘制图形
%写入数据
for i = 1:N
s0(i) = round(s(i)); %对小数四舍五入以取整
if s0(i) <0 %负1强制置零
s0(i) = 0
end
fprintf(fild, '%s\n',dec2bin(s0(i),8)); %数据写入
end
fclose(fild);