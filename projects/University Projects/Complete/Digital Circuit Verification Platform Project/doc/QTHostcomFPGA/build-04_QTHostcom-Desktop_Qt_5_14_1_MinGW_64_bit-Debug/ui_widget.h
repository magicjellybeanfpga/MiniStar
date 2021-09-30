/********************************************************************************
** Form generated from reading UI file 'widget.ui'
**
** Created by: Qt User Interface Compiler version 5.14.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_WIDGET_H
#define UI_WIDGET_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QTextBrowser>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_Widget
{
public:
    QPushButton *pushButtonP1;
    QPushButton *pushButtonP2;
    QTextBrowser *textCommd;
    QPushButton *pushButtonClear;
    QPushButton *pushButtonOPEN;
    QComboBox *comboBoxCOM;
    QComboBox *comboBoxBand;
    QPushButton *pushButtonOK;

    void setupUi(QWidget *Widget)
    {
        if (Widget->objectName().isEmpty())
            Widget->setObjectName(QString::fromUtf8("Widget"));
        Widget->resize(1028, 571);
        Widget->setMinimumSize(QSize(1028, 571));
        Widget->setMaximumSize(QSize(1550, 1000));
        Widget->setSizeIncrement(QSize(1370, 1030));
        pushButtonP1 = new QPushButton(Widget);
        pushButtonP1->setObjectName(QString::fromUtf8("pushButtonP1"));
        pushButtonP1->setGeometry(QRect(540, 360, 171, 28));
        pushButtonP2 = new QPushButton(Widget);
        pushButtonP2->setObjectName(QString::fromUtf8("pushButtonP2"));
        pushButtonP2->setGeometry(QRect(760, 360, 171, 28));
        textCommd = new QTextBrowser(Widget);
        textCommd->setObjectName(QString::fromUtf8("textCommd"));
        textCommd->setGeometry(QRect(30, 10, 961, 331));
        textCommd->setMaximumSize(QSize(16777215, 16777215));
        pushButtonClear = new QPushButton(Widget);
        pushButtonClear->setObjectName(QString::fromUtf8("pushButtonClear"));
        pushButtonClear->setGeometry(QRect(30, 410, 93, 28));
        pushButtonOPEN = new QPushButton(Widget);
        pushButtonOPEN->setObjectName(QString::fromUtf8("pushButtonOPEN"));
        pushButtonOPEN->setGeometry(QRect(150, 410, 93, 28));
        comboBoxCOM = new QComboBox(Widget);
        comboBoxCOM->setObjectName(QString::fromUtf8("comboBoxCOM"));
        comboBoxCOM->setGeometry(QRect(30, 360, 93, 28));
        comboBoxBand = new QComboBox(Widget);
        comboBoxBand->addItem(QString());
        comboBoxBand->addItem(QString());
        comboBoxBand->addItem(QString());
        comboBoxBand->setObjectName(QString::fromUtf8("comboBoxBand"));
        comboBoxBand->setGeometry(QRect(150, 360, 93, 28));
        pushButtonOK = new QPushButton(Widget);
        pushButtonOK->setObjectName(QString::fromUtf8("pushButtonOK"));
        pushButtonOK->setGeometry(QRect(540, 410, 93, 28));

        retranslateUi(Widget);

        QMetaObject::connectSlotsByName(Widget);
    } // setupUi

    void retranslateUi(QWidget *Widget)
    {
        Widget->setWindowTitle(QCoreApplication::translate("Widget", "Widget", nullptr));
        pushButtonP1->setText(QCoreApplication::translate("Widget", "\351\242\221\347\216\207\346\265\213\351\207\217", nullptr));
        pushButtonP2->setText(QCoreApplication::translate("Widget", "\346\225\260\347\240\201\347\256\241\351\235\231\346\200\201\346\230\276\347\244\272\346\265\213\350\257\225", nullptr));
        pushButtonClear->setText(QCoreApplication::translate("Widget", "\346\270\205\347\251\272", nullptr));
        pushButtonOPEN->setText(QCoreApplication::translate("Widget", "\346\211\223\345\274\200\344\270\262\345\217\243", nullptr));
        comboBoxBand->setItemText(0, QCoreApplication::translate("Widget", "9600", nullptr));
        comboBoxBand->setItemText(1, QCoreApplication::translate("Widget", "57600", nullptr));
        comboBoxBand->setItemText(2, QCoreApplication::translate("Widget", "115200", nullptr));

        pushButtonOK->setText(QCoreApplication::translate("Widget", "\347\241\256\345\256\232", nullptr));
    } // retranslateUi

};

namespace Ui {
    class Widget: public Ui_Widget {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_WIDGET_H
