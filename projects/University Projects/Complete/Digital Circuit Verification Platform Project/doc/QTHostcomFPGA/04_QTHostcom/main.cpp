#include "widget.h"

#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    Widget w;
    w.setWindowTitle("数字电路实验测试上位机");
    w.show();
    return a.exec();
}
