#include "widget.h"
#include "ui_widget.h"
#include <QPainter>
#include <QString>
#include <QMessageBox>
#include <QDebug>

Widget::Widget(QWidget *parent)
    : QWidget(parent)
    , ui(new Ui::Widget)
{
    ui->setupUi(this);

    //resize(1500+300, 730+200); // 窗体大小 宽度1000 高度730
//    m_image = QImage(1490, 710, QImage::Format_RGB32);  // 画布的初始化大小设为，使用32位颜色
//    QColor backColor = qRgb(255, 255, 255);    // 画布初始化背景色使用白色
//    m_image.fill(backColor); // 对画布进行填充

//    m_painter = new QPainter(&m_image);
//    m_painter->setRenderHint(QPainter::Antialiasing, true); // 设置反锯齿模式

//    Paint();
//    update();
    //drawpoint(mea,2);
    //Painttest();
    serialinfo = new QSerialPortInfo();
    serialport = new QSerialPort();

    connect(serialport,&QSerialPort::readyRead,this,&Widget::readyread);
    sendbyte = 0;
    revbyte = 0;
    ui->pushButtonP1->setEnabled(false);
    ui->pushButtonP2->setEnabled(false);
    ui->pushButtonClear->setEnabled(true);


    ui->comboBoxCOM->clear();
    foreach( *serialinfo,QSerialPortInfo::availablePorts())
    {
        ui->comboBoxCOM->addItem(serialinfo->portName());
    }
    ui->pushButtonOPEN->setEnabled(true);
    ui->pushButtonOK->setEnabled(true);

    ui->textCommd->setText("Init OK");

    HeadByte[0] = 0xEC;
    HeadByte[1] = 0x01;
    HeadByte[2] = 0x00;
    HeadByte[3] = 0x00;
    HeadByte[4] = 0x00;
    HeadByte[5] = 0x00;
    HeadByte[6] = 0x00;
    HeadByte[7] = 0xa5;

    //on_pushButtonP1_clicked();
    //on_pushButtonP2_clicked();
}

void Widget::readyread()
{
    buffer = serialport->readAll();
    unsigned int bytenum[16];
    //QString Hi_data;
    unsigned int Hi_data = 0;
    unsigned int Lo_data = 0;
    int rxlength = buffer.length();
    for(int idx=0;idx <rxlength;idx++){
        bytenum[idx] = (buffer.at(idx)) & 0xff;
        qDebug("bytenum[%d] = %x,n",idx,bytenum[idx]);
    }
    if(flag_state == 1 & bytenum[0] == 0x5A){
        Hi_data = bytenum[5] + bytenum[6]*256 + bytenum[7]*65536 + bytenum[8]*16777216 ;
        Lo_data = bytenum[1] + bytenum[2]*256 + bytenum[3]*65536 + bytenum[4]*16777216 ;
        double Freq = 0;
        Freq = (50000.0*Lo_data)/(Hi_data*1.0);
        qDebug("head = %x,Hi_data = %d,Lo_data = %d,Freq = %fKHz\n",bytenum[0],Hi_data,Lo_data,Freq);

        QString str_rev = QString().setNum(Freq,'g',6);
        //PasteData.append(buffer);
        ui->textCommd->append("Frequence measure is : " + str_rev + "KHz");
        ui->textCommd->append("------------------------------------------------------------------");
        ui->pushButtonP1->setEnabled(true);
        ui->pushButtonP2->setEnabled(true);
    }
    else if(flag_state == 2 & bytenum[0] == 0x5A){
        unsigned int digitalnum[4];
        unsigned int errflag[4];
        char Setnum[4] ;
        int correct = 0;
        digitalnum[0] = bytenum[1] & 0x0f;
        digitalnum[1] = ((bytenum[1] & 0xf0) >> 4);
        digitalnum[2] = bytenum[2] & 0x0f;
        digitalnum[3] = ((bytenum[2] & 0xf0) >> 4);
        for(int idx = 0;idx < 4;idx++){
            if(DigitalTube[digitalnum[idx]] == bytenum[idx+5]){
                correct ++;
            }
            else {
                errflag[idx] = digitalnum[idx];
            }
            //qDebug("++%x\n",DigitalTube[digitalnum[idx]]);
        }
        sprintf(Setnum,"%x%x",bytenum[2],bytenum[1]);
        ui->textCommd->append("DigitalTube set is : 0x" + QString(Setnum));

        if(correct == 4){
            ui->textCommd->append("DigitalTube measure is : 0x" + QString(Setnum));
            ui->textCommd->append("DigitalTube test check done!");


        }
        else {

            ui->textCommd->append("DigitalTube test check failed!");
            ui->textCommd->append("please check you design!");
            ui->textCommd->append("The following errors are:!");
            //ui->textCommd->append(":!");

        }
        ui->textCommd->append("------------------------------------------------------------------");
        ui->pushButtonP1->setEnabled(true);
        ui->pushButtonP2->setEnabled(true);



    }
    else {
        ui->textCommd->append("Recv_data error!");
    }

    ui->pushButtonClear->setEnabled(true);
    ui->pushButtonOK->setEnabled(true);

}

void Widget::Painttest(){
    QPen penPointY1;

    penPointY1.setColor(Qt::blue);
    penPointY1.setWidth(3);
    ui->pushButtonP1->setEnabled(false);
    for (int i = 0; i < POINTSNUM1; ++i){
            double dXStart = pointx + kx * (xData[i] - minScaleX);
            m_painter->setPen(penPointY1); // 蓝色的笔，用于标记Y1各个点
            m_painter->drawPoint(dXStart, pointy-(testdata[i]*5-minScaleY)*ky1);
            //qDebug() << "draw "<<dXStart<<",";

    }
    //ui->pushButtonP1->setEnabled(true);
    update();

}


void Widget::drawpoint(double data[],int ff){



    qDebug() << "in" <<endl;
    if(ff == 1){
        QPen penPointY1;

        penPointY1.setColor(Qt::blue);
        penPointY1.setWidth(3);
        ui->pushButtonP1->setEnabled(false);
        for (int i = 0; i < POINTSNUM1; ++i){
                double dXStart = pointx + kx * (xData[i] - minScaleX);
                m_painter->setPen(penPointY1); // 蓝色的笔，用于标记Y1各个点
                m_painter->drawPoint(dXStart, pointy-(data[i]*5-minScaleY)*ky1);
                //qDebug() << "draw "<<dXStart<<",";

        }
        ui->pushButtonP1->setEnabled(true);
        update();
    }
    else if(ff == 2){
        QPen penPointY2;


        penPointY2.setColor(Qt::red);
        penPointY2.setWidth(3);
        ui->pushButtonP1->setEnabled(false);
        for (int i = 0; i < POINTSNUM2; ++i){
                double dXStart = pointx + kx * (x2Data[i] - minScaleX);
                m_painter->setPen(penPointY2); // 蓝色的笔，用于标记Y1各个点
                m_painter->drawPoint(dXStart, pointy-(data[i]*5-minScaleY)*ky1);
                //qDebug() << "draw "<<dXStart<<",";

        }
        ui->pushButtonP1->setEnabled(true);
        update();

    }
    else{
        QPen penPointY3;


        penPointY3.setColor(Qt::white);
        penPointY3.setWidth(4);
        for (int i = 0; i < POINTSNUM1; ++i){
                double dXStart = pointx + kx * (xData[i] - minScaleX);
                m_painter->setPen(penPointY3); // 蓝色的笔，用于标记Y1各个点
                m_painter->drawPoint(dXStart, pointy-(measure_data1[i]*5-minScaleY)*ky1);


        }
        for (int i = 0; i < POINTSNUM1; ++i){
                double dXStart = pointx + kx * (xData[i] - minScaleX);
                m_painter->setPen(penPointY3); // 蓝色的笔，用于标记Y1各个点
                m_painter->drawPoint(dXStart, pointy-(measure_data2[i]*5-minScaleY)*ky1);


        }
        for (int i = 0; i < POINTSNUM1; ++i){
                double dXStart = pointx + kx * (xData[i] - minScaleX);
                m_painter->setPen(penPointY3); // 蓝色的笔，用于标记Y1各个点
                m_painter->drawPoint(dXStart, pointy-(measure_data3[i]*5-minScaleY)*ky1);

        }
        for (int i = 0; i < POINTSNUM2; ++i){
                double dXStart = pointx + kx * (x2Data[i] - minScaleX);
                m_painter->setPen(penPointY3); // 蓝色的笔，用于标记Y1各个点
                m_painter->drawPoint(dXStart, pointy-(mea[i]*5-minScaleY)*ky1);


        }

        update();

    }

}


void Widget::Paint()
{
    // 确定坐标轴起点坐标
    pointx = 80;
    pointy = 650;

    // 确定坐标轴宽度和高度，上文已定义画布大小，宽高依此而定。
    width = 1480 - pointx - 70;  // 宽度 = 画布宽度 - 坐标起点x - 右端间隙
    height = 700 - 2 * 50;      // 高度 = 画布高度 - 上下端的间隙高度

    // 绘制视图区域
    // 即外围的矩形（由左上角与右下角的两个点确定一个矩形）
    m_painter->drawRect(20, 30, 1480 - 10, 700 - 20);

    QPen labelpen;
    labelpen.setColor(Qt::black);
    labelpen.setWidth(3);
    m_painter->setPen(labelpen);

    // 绘制X、Y1、Y2轴
    QPointF xStartPoint(pointx, pointy);
    QPointF xEndPoint(width + pointx, pointy);
    m_painter->drawLine(xStartPoint, xEndPoint); // 坐标轴x宽度为width

    QPointF y1StartPoint(pointx, pointy - height);
    QPointF y1EndPoint(pointx, pointy);
    m_painter->drawLine(y1StartPoint, y1EndPoint); // 坐标轴y1高度为height

    kx = (double)(width / scaleRangeX); // x轴的系数
    ky1 = (double)(height / scaleRangeY);  // y1方向的比例系数


    // （4） 绘制刻度线
    QPen penDegree;
    penDegree.setColor(Qt::black);
    penDegree.setWidth(2);
    m_painter->setPen(penDegree);

    // x轴刻度线和值
    // x轴 第一个刻度值
    m_painter->drawText(pointx + 3, pointy + 12, QString::number(minScaleX, 'f', 3));
    for (int i = 0; i < POINTSNUM - 1; ++i) // 分成10份
    {
//        // 选取合适的坐标，绘制一段长度为4的直线，用于表示刻度
//        m_painter->drawLine(pointx + (i + 1) * width/10, pointy,
//                         pointx + (i+1)*width/10, pointy + 4);

        m_painter->drawText(pointx + (i+0.9) * width / POINTSNUM, pointy + 12, // 值的位置信息
                         QString::number(minScaleX + (i+1) * (scaleRangeX/POINTSNUM), 'f', 3));
    }
    // x轴 最后一个刻度值
    m_painter->drawText(pointx + (POINTSNUM - 1 + 0.8) * width / POINTSNUM, pointy + 12,
                     QString::number(maxScaleX, 'f', 3));

    xStartPoint.setX(pointx);
    xStartPoint.setY(pointy + 20);
    xEndPoint.setX(pointx + width);
    xEndPoint.setY(pointy + 20);
    m_painter->drawLine(xStartPoint, xEndPoint);

    m_painter->drawText(pointx + width/2, pointy + 35, QString("Voltage"));
    m_painter->drawText(pointx + 3*width/4, pointy + 35, QString("\\V"));

    // y1轴刻度线和值
    // y1轴 第一个刻度值
    m_painter->drawText(pointx - 25, pointy - 3, QString::number(minScaleY, 'f', 3));
    for (int i = 0; i < POINTSNUM - 1; ++i)
    {
        // 代码较长，但是掌握基本原理即可。
        // 主要就是确定一个位置，然后画一条短短的直线表示刻度。

//        m_painter->drawLine(pointx, pointy-(i+1)*height/10,
//                         pointx-4, pointy-(i+1)*height/10);

        m_painter->drawText(pointx - 25, pointy - (i+0.85) * height/POINTSNUM,
                         QString::number(minScaleY + (i+1) * (scaleRangeY/POINTSNUM), 'f', 3));
    }
    // y1轴 最后一个刻度值
    m_painter->drawText(pointx - 25, pointy - (POINTSNUM - 1 + 0.85) * height/POINTSNUM,
                     QString::number(maxScaleY, 'f', 3));

    y1StartPoint.setX(pointx - 35);
    y1StartPoint.setY(pointy - height);

    y1EndPoint.setX(pointx - 35);
    y1EndPoint.setY(pointy);
    m_painter->drawLine(y1StartPoint, y1EndPoint);

    m_painter->drawText(pointx - 55, pointy - height/2, QString("Id"));
    m_painter->drawText(pointx - 55, pointy - 3*height/4, QString("\\A"));

    // （5）绘制网格
    QPen penDotLine;
    penDotLine.setStyle(Qt::DotLine);
    m_painter->setPen(penDotLine);
    for (int i = 0; i < POINTSNUM; ++i)
    {
        // 垂直线
        m_painter->drawLine(pointx + (i+1)* width/POINTSNUM, pointy,
                         pointx + (i+1)* width/POINTSNUM, pointy - height);
        // 水平线
        m_painter->drawLine(pointx, pointy-(i+1)*height/POINTSNUM,
                         pointx + width, pointy-(i+1)*height/POINTSNUM);
    }
}


Widget::~Widget()
{
    delete ui;
    delete  m_painter;
}


void Widget::on_pushButtonP1_clicked()
{

    HeadByte[1] = 0x01;

    //serialport->write(HeadByte);

    QByteArray tmp;
    tmp.resize(1);
    for(int idx = 0;idx < 8;idx++){
        tmp[0] = HeadByte.at(idx);
        serialport->write(tmp);
        Sleep(10);
    }


    ui->pushButtonP1->setEnabled(false);
    ui->pushButtonP2->setEnabled(false);
    flag_state = 1;
    ui->textCommd->append("Frequence measure cmd has sended!\n");

}

void Widget::on_pushButtonP2_clicked()
{
    //drawpoint(mea,2);
   HeadByte[1] = 0x02;

    QByteArray tmp;
    tmp.resize(1);
    for(int idx = 0;idx < 8;idx++){
        tmp[0] = HeadByte.at(idx);
        serialport->write(tmp);
        Sleep(10);
    }

    ui->pushButtonP1->setEnabled(false);
    ui->pushButtonP2->setEnabled(false);

    flag_state = 2;
    ui->textCommd->append("Digital Tube test cmd has sended!(only for )\n");
}

void Widget::on_pushButtonClear_clicked()
{
    //double tet[130];
    //update();
    //m_painter->end();
//    drawpoint(tet,3);
//    Paint();
    //ui->textCommd->append("Clear all data!\n");
    ui->textCommd->clear();
}

void Widget::on_pushButtonOPEN_clicked()
{
    if(ui->pushButtonOPEN->text() == QString("打开串口"))
    {
        serialport->setPortName((ui->comboBoxCOM->currentText()));
        serialport->setBaudRate(ui->comboBoxBand->currentText().toLong());

        serialport->setDataBits(QSerialPort::Data8);

        serialport->setParity(QSerialPort::NoParity);

        serialport->setStopBits(QSerialPort::OneStop);

        serialport->setFlowControl(QSerialPort::NoFlowControl);

        if(!serialport->open(QIODevice::ReadWrite))
        {
             QMessageBox::about(NULL,"错误","无法打开串口");
             return;
        }


        ui->comboBoxCOM->setEnabled(false);
        ui->comboBoxBand->setEnabled(false);

        ui->pushButtonOPEN->setText(QString("关闭串口"));
        ui->textCommd->append("\nOpen Serial ok!\n");
        ui->textCommd->append("The Serial port is:");
        ui->textCommd->append(ui->comboBoxCOM->currentText() + "\n");
        ui->textCommd->append("The Serial bondrate is:");
        ui->textCommd->append(ui->comboBoxBand->currentText() + "\n");

        ui->pushButtonP1->setEnabled(true);
        ui->pushButtonP2->setEnabled(true);
    }
    else
    {
        serialport->close();

        ui->comboBoxCOM->setEnabled(true);
        ui->comboBoxBand->setEnabled(true);
        ui->textCommd->append("Close Serial\n");

        ui->pushButtonOPEN->setText(QString("打开串口"));

        ui->pushButtonP1->setEnabled(false);
        ui->pushButtonP2->setEnabled(false);

    }
}

void Widget::paintEvent(QPaintEvent *)
{
    QPainter painter(this);
    painter.drawImage(0, 0, m_image);

}

void Widget::on_pushButtonOK_clicked()
{

    ui->pushButtonP1->setEnabled(true);
    ui->pushButtonP2->setEnabled(true);
    ui->textCommd->append("Data has receiving!");

}


void Widget::Sleep(int msec)
{
    QTime dieTime = QTime::currentTime().addMSecs(msec);
    while( QTime::currentTime() < dieTime )
        QCoreApplication::processEvents(QEventLoop::AllEvents, 100);
}
