#include"Clients.h"
#include"Manager.h"
int main()
{
	int identity;
	BankAccount* p = NULL;
	Clients client;
	Manager manager;
	client.writein();
	for (;;) {
		cout << "\n******************************" << endl;
		cout << "- 欢迎使用**银行账户管理系统 -" << endl;
		cout << "-                            -" << endl;
		cout << "-     1.   客户登录          -" << endl;
		cout << "-                            -" << endl;
		cout << "-     2.   管理员登录        -" << endl;
		cout << "-                            -" << endl;
		cout << "-     3.   退出系统          -" << endl;
		cout << "-                            -" << endl;
		cout << "******************************\n" << endl;
		cout << "请选择您的操作：" << endl;
		cin >> identity;
		int k = 1;
		/*客户*/
		while (identity < 1 || identity>3) {
			cout << "请输入正确的序号：" << endl;
			identity = 0;
			cin >> identity;
		}
		system("cls");
		if (identity == 1) {
			string id;
			string password1;
			int option = 0;
			int flag = 0;
			cout << "请选择您需要的服务：" << endl << "1.登录" << endl << "2.开户" << endl;
			cin >> option;
			while (option < 1 || option > 2) {
				cout << "请输入正确的序号：" << endl;
				option = 0;
				cin >> option;
			}
			while (k == 1) {
				/*开户*/
				if (option == 2) {
					client.openaccounts();
					flag = 1;
				}
				/*登录*/
				else {
					p = client.login();
					system("cls");
					cout << "登录成功！" << endl << "\n-------------------\n" << endl;
					if (p == NULL)
						break;
					gp1:while (1) {
						option = 0;
						cout << "请选择您要办理的业务：" << endl << "1.查询" << endl << "2.修改" << endl << "3.存款" << endl << "4.取款" << endl << "5.转账" << endl << "6.销户" << endl << "7.退出" << endl;
						cin >> option;
						while (option < 1 || option > 7) {
							cout << "请输入正确的序号：" << endl;
							option = 0;
							cin >> option;
						}
						/*客户办理不同业务*/
						if (option == 1) {
							client.search(p);
						}
						else if (option == 2) {
							client.modify(p);
						}
						else if (option == 3) {
							client.save(p);
						}
						else if (option == 4) {
							client.withdraw(p);
						}
						else if (option == 5) {
							client.transfer(p);
						}
						else if (option == 6) {
							client.cancelaccount(p);
						}
						else {
							system("cls");
							cout << "感谢您的使用，期待您下次光临！" << endl;
							manager.reflesh(client.head);
							exit(0);
						}
						flag = 0;
						break;
						/*退出系统*/
				    }
			    }
				if (flag == 1) {
					cout << "\n-------------------\n" << endl;
					cout << "请选择您接下来的操作：" << endl << "1.返回桌面" << endl << "2.退出" << endl;
					cin >> k;
					while (k > 2 && k < 1) {
						cout << "请输入正确的序号：" << endl;
						cin >> k;
					}
					if (k == 1) {
						system("cls");
						break;
					}
					else {
						system("cls");
						cout << "感谢您的使用，期待您下次光临！" << endl;
						manager.reflesh(client.head);
						exit(0);
					}
				}
				else {
					cout << "\n-------------------\n" << endl;
					cout << "请选择您接下来的操作：" << endl << "1.继续办理其他业务" << endl << "2.返回桌面" << endl << "3.退出" << endl;
					cin >> k;
					while (k > 3 && k < 1) {
						cout << "请输入正确的序号：" << endl;
						cin >> k;
					}
					if (k == 1) {
						system("cls");
						goto gp1;
					}
					else if (k == 2) {
						system("cls");
						break;
					}
					else {
						system("cls");
						cout << "感谢您的使用，期待您下次光临！" << endl;
						manager.reflesh(client.head);
						exit(0);
					}
				}
			}
			
		}
		/*管理员*/
		else if (identity == 2) {
			int choice = 0;
			int Login = manager.login();
			system("cls");
			cout << "登录成功！" << endl << "\n-------------------\n" << endl;
			if (Login) {
				gp2:while (1) {
					cout << "请选择您接下来的操作：" << endl << "1.浏览" << endl << "2.查找" << endl << "3.转账" << endl << "4.退出" << endl;
					cin >> choice;
					while (choice < 1 || choice > 4) {
						cout << "请输入正确的序号：" << endl;
						choice = 0;
						cin >> choice;
					}
					/*管理员实现不同功能*/
					if (choice == 1) {
						manager.browse(client.head, client.number);
					}
					else if (choice == 2) {
						manager.search(client.head,client.number);
					}
					else if (choice == 3) {
						manager.transfer(client.head);
					}
					else {
						cout << "已退出管理员模式,感谢您的使用，期待您下次光临！" << endl;
						manager.reflesh(client.head);
						exit(0);
					}


					cout << "\n-------------------\n" << endl;
					cout << "请选择您接下来的操作：" << endl << "1.继续办理其他业务" << endl << "2.返回桌面" << endl << "3.退出" << endl;
					cin >> k;
					while (k > 3 && k < 1) {
						cout << "请输入正确的序号：" << endl;
						cin >> k;
					}
					if (k == 1) {
						system("cls");
						goto gp2;
					}
					else if (k == 2) {
						system("cls");
						break;
					}
					else {
						system("cls");
						cout << "感谢您的使用，期待您下次光临！" << endl;
						manager.reflesh(client.head);
						exit(0);
					}



				}
			}


			else {
				cout << "已退出管理员模式！" << endl;
			}
		}
		/*退出系统*/
		else
		{
			system("cls");
			cout << "已退出本系统，感谢您的使用，欢迎下次光临！" << endl;
			manager.reflesh(client.head);
			exit(0);
		}
	}
	manager.reflesh(client.head);
	return 0;
}