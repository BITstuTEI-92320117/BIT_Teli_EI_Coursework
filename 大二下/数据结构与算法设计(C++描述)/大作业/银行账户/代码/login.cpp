#include"Clients.h"
#include"Manager.h"
BankAccount* Clients::login()
{
	system("cls");
	BankAccount* p = head;
	string account__number;
	string password0;
	for (;;){
		cout << "请输入您的银行卡号：" << endl;
		cin >> account__number;
		for (;;){
			if (p->account_number == account__number){
				cout << "请输入密码：" << endl;
				cin >> password0;
				for (;;){
					if (p->account_number == account__number){
						if (p->password == password0){
							return p;
						}
						else{
							cout << "密码错误，请选择接下来的操作：" << endl << "1.重新输入" << endl << "2.退出" << endl;
							int k = 0;
							for (;;){
								cin >> k;
								if (k < 1 || k>2){
									cout << "请输入正确的序号：" << endl;
									k = 0;
								}
								else if (k == 1){
									system("cls");
									break;
								}
								else{
									system("cls");
									return NULL;
								}
							}
							break;
						}
					}
					else{
						p = p->next;
					}
				}
			}
			else{
				p = p->next;
			}
			if (p == NULL)
			{
				cout << "该用户不存在，请选择接下来的操作：" << endl << "1.重新输入" << endl << "2.退出" << endl;
				int m = 0;
				for (;;)
				{
					cin >> m;
					if (m < 1 || m>2){
						cout << "请输入正确的序号：" << endl;
						m = 0;
					}
					else if (m == 1){
						system("cls");
						p = head;
						break;
					}
					else {
						system("cls");
						return NULL;
					}
				}
				break;
			}
		}
	}
}

//管理员登录
bool Manager::login() {
	system("cls");
	string password1;
	cout << "请输入密码：" << "\n";
	for (;;) {
		cin >> password1;
		if (password1 == password){
			return true;
		}
		else if (password1 != password){
			cout << "密码错误，请重新输入：" << endl; 
		}
		else { 
			return false; 
		}
	}
}