clc;
clear all;
n=2^10;
s=zeros(1,4*n);
for i=n+1:2*n
    s(i)=254;
end
for i=2*n+1:3*n
    s(i)=253;
end
for i=3*n+1:4*n
    s(i)=255;
end
fild = fopen('test.txt','wt');
for i = 1:4*n
    fprintf(fild, '%s\n',dec2bin(s(i),8)); %数据写入
end
fprintf(fild, '%s','#END'); %结束
fclose(fild);