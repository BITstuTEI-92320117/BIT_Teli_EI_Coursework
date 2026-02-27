#include"Clients.h"
/*修改电话号码或电子邮箱*/
void Clients::modify(BankAccount* q) {
	system("cls");
	string new_phone;
	string new_email;
	cout << "请选择您要修改的信息：" << endl;
	cout << " 1.电话 " << " 2.电子邮箱 " << endl;
	int choice;
	cin >> choice;
	for (;;) {
		if (choice == 1) {
			cout << "请输入新的电话号码：" << endl;
			cin >> new_phone;
			q->telephone = new_phone;
			cout << "修改成功！" << endl;
			break;
		}
		else if (choice == 2) {
			cout << "请输入新的电子邮箱：" << endl;
			cin >> new_email;
			q->email = new_email;
			cout << "修改成功！" << endl;
			break;
		}
		else {
			cout << "请输入正确的选项：" << endl;
			cin >> choice;
		}
	}
}