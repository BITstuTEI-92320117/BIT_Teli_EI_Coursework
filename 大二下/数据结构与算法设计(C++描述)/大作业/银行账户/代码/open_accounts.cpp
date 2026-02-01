#include"Clients.h"
#include <random>
//开户
void Clients::openaccounts()
{
	system("cls");
	string name0;
	string password01;
	string password02;
	string id0;
	string email0;
	string telephone0;
	string idcard0;
	string account_number = "";
	cout << "请输入您的姓名：" << endl;
	cin >> name0;
	for (;;){
		cout << "请输入您的密码：" << endl;
		cin >> password01;
		cout << "请再次输入您的密码：" << endl;
		cin >> password02;
		if (password01 != password02){
			cout << "两次输入密码不一致，请重新输入：" << endl;
		}
		else break;
	}
	cout << "请输入您的ID号码：" << endl;
	cin >> id0;
	while (find(id0)) {
		cout << "该ID号已被占用，请重新输入您的ID" << endl;
		id0.clear();
		cin >> id0;
	}
	cout << "请输入您的电子邮箱：" << endl;
	cin >> email0;
	cout << "请输入您的电话号码：" << endl;
	cin >> telephone0;
	cout << "请输入您的身份证号：" << endl;
	cin >> idcard0;
	random_device rd; // 随机设备产生种子
	mt19937 gen(rd()); // 梅森旋转引擎
	// 2. 均匀分布的整数
	uniform_int_distribution<> dist_int(0, 9);
	for (int i = 0; i < 16; i++){
		account_number += '0' + dist_int(gen);
	}
	cout << "您的银行卡号是：" << account_number << endl;
	/*创建新账户的结点*/
	BankAccount* p = new BankAccount(id0, password01, name0, telephone0, account_number, email0, idcard0, 0.0);
	p->next = head->next;
	head->next = p;
	length++;
	number++;
	cout << "开户成功！" << endl;
}
