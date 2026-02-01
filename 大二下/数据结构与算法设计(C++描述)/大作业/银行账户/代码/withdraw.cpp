#include"Clients.h"
/*取款*/
void Clients::withdraw(BankAccount* q) {
	system("cls");
	double wmoney;
	int i = 0;
	cout << "请输入取款金额：" << endl;
	for (;;) {
		if (cin >> wmoney) {
			if (wmoney <= 0) {
				cout << "请输入有效的取款金额！" << endl;
			}
			else if (q->balance < wmoney) {
				cout << "余额不足,请选择接下来的操作：" << endl << "1.重新输入" << endl << "2.退出" << endl;
				for (;;) {
					cin >> i;
					if (i < 1 || i>2) {
						cout << "请输入正确的序号：" << endl;
					}
					else
						break;
				}
				if (i == 1) {
					cout << "请输入取款金额：" << endl;
					continue;
				}
				else {
					return;
				}
			}
			else {
				q->balance -= wmoney;
				cout << "成功取出人民币" << wmoney << "元！" << endl;
				break;
			}
		}
		else {
			cout << "请输入有效的取款金额！" << endl;;
		}
	}
	return;
}