#include"Clients.h"
#include"Manager.h"
//用户查看
void Clients::search(BankAccount* q)
{
	system("cls");
	int m = 0;
	cout << "请选择您要查看的信息：" << endl << "1.姓名" << endl << "2.身份标识号（ID）" << endl << "3.电话号码" << endl << "4.银行卡号" << endl << "5.电子邮箱" << endl << "6.身份证号" << endl << "7.账户余额" << endl << "8.查看所有信息" << endl;
	cin >> m;
	system("cls");
	if (m < 1 || m>8)
	{
		cout << "请输入正确的选项" << endl;
		m = 0;
		cout << "请选择您要查看的信息：" << endl << "1.姓名" << endl << "2.身份标识号（ID）" << endl << "3.电话号码" << endl << "4.银行卡号" << endl << "5.电子邮箱" << endl << "6.身份证号" << endl << "7.账户余额" << endl << "8.查看所有信息" << endl;
		cin >> m;
	}
	system("cls");
	if (m == 1) {
		cout << "姓名：" << q->name << endl;
	}
	else if (m == 2) {
		cout << "身份标识号（ID）：" << q->ID << endl;
	}
	else if (m == 3) {
		cout << "电话号码：" << q->telephone << endl;
	}
	else if (m == 4) {
		cout << "银行卡号：" << q->account_number << endl;
	}
	else if (m == 5) {
		cout << "电子邮箱：" << q->email << endl;
	}
	else if (m == 6) {
		cout << "身份证号：" << q->IDcard << endl;
	}
	else if (m == 7) {
		cout << "账户余额：" << q->balance << endl;
	}
	else {
		cout << "姓名：" << q->name << endl;
		cout << "身份标识号(ID)：" << q->ID << endl;
		cout << "电话号码：" << q->telephone << endl;
		cout << "银行卡号：" << q->account_number << endl;
		cout << "电子邮箱：" << q->email << endl;
		cout << "身份证号：" << q->IDcard << endl;
		cout << "账户余额：" << q->balance << endl;
	}
}

//管理员查看
void Manager::search(BankAccount* pt,int number) {
	system("cls");
	/*type用于标注以何种方式查找进而确定调用的函数*/
	/*flag1作为是否查找到符合条件用户方式的标志*/
	int min = 0, max = 0, type = 0, i = 0, flag1 = 0, flag2 = 0, j = 1;
	int m = 0;
	string input;
	bool SuccessfullyInput = false;
	bool btype = true;
	while (!SuccessfullyInput) {
		cout << endl << "请输入需要查找的条件：" << "\n";
		cout << "1.ID" << endl << "2.姓名" << endl << "3.电话" << endl << "4.电子邮箱" << endl << "5.身份证号" << endl << "6.银行卡号" << endl << "7.账户余额范围" << endl << "8.取消" << endl;
		cin >> m;
		system("cls");
		if (m < 1 || m > 8)
		{
			flag2 = 1;
			cout << "请输入正确的序号：" << endl;
			m = 0;
		}
		if (m == 1) {
			cout << "请输入要查找的ID：" << endl;
			cin >> input;
			type = 1;
			SuccessfullyInput = true;
			break;
		}
		else if (m == 2) {
			cout << "请输入要查询的姓名：" << endl;
			cin >> input;
			type = 1;
			SuccessfullyInput = true;
			break;
		}
		else if (m == 3) {
			cout << "请输入要查询的电话：" << endl;
			cin >> input;
			type = 1;
			SuccessfullyInput = true;
			break;
		}
		else if (m == 4) {
			cout << "请输入要查询的电子邮箱：" << endl;
			cin >> input;
			type = 1;
			SuccessfullyInput = true;
			break;
		}
		else if (m == 5) {
			cout << "请输入要查询的身份证号：" << endl;
			cin >> input;
			type = 1;
			SuccessfullyInput = true;
			break;
		}
		else if (m == 6) {
			cout << "请输入要查询的银行卡号：" << endl;
			cin >> input;
			type = 1;
			SuccessfullyInput = true;
			break;
		}
		else if (m == 7) {
			cout << "请输入要查询的余额下限：" << "\n";
			for (;;) {
				cin >> min;
				if (min < 0) {
					cout << "请输入正确余额：" << "\n";
				}
				else
					break;
			}
			cout << "请输入要查询的余额上限：" << "\n";
			for (;;) {
				cin >> max;
				if (max < 0 || max <= min) {
					cout << "请输入正确余额：" << "\n";
				}
				else
					break;
			}
			SuccessfullyInput = true; 
			break;
		}
		else {
			return;
			}
	}
		while (i < number) {
			pt = pt->next;
			if (type == 1) {
				btype = types1(pt, m, input);
			}
			else {
				btype = types2(pt, min, max);
			}
			if (btype) {
				if (flag1 == 0) {
					cout << "序号  ID        姓名        电话            电子邮箱            身份证号            银行卡号            账户余额" << endl;
					flag1 = 1;
				}
				display(pt, j);
				j++;
			}
			i++;
		}
		if (flag1 == 0 && flag2 == 0) {
			cout << "未查找到符合查询条件的账户" << endl;
		}
	}
