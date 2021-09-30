%picture to gowin rom initial file (.mi)

%原始图片路径
SOURCE_IMAGE_PATH    = '.\9.bmp';
%保存的mi文件名和路径
SAVED_MEM_FILE_PATH = '9.mi';
%图片宽度
SOURCE_IMG_WIDTH = 48;
%图片高度
SOURCE_IMG_HIGHT = 48;
%输出位宽
OUT_RADIX  =  1;

src_img =  imread(SOURCE_IMAGE_PATH);
img_data = fopen(SAVED_MEM_FILE_PATH,'w');


fprintf(img_data,'%s\r\n','#File_format=Bin');
fprintf(img_data,'%s%s\r\n','#Address_depth=',num2str(SOURCE_IMG_WIDTH*SOURCE_IMG_HIGHT));
fprintf(img_data,'%s%s\r\n','#Data_width=',num2str(OUT_RADIX));

for i = 1:SOURCE_IMG_HIGHT
    for j = 1:SOURCE_IMG_WIDTH
        fprintf(img_data,'%s\r\n',num2str(src_img(i,j)));
    end
end
    