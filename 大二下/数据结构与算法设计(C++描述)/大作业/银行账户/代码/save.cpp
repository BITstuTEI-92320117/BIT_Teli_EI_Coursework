#include"Clients.h"
/*存款*/
void Clients::save(BankAccount* q) {
	system("cls");
	double smoney;
	cout << "请输入存款金额：" << endl;
	for (;;) {
		if (cin >> smoney) {
			q->balance += smoney;
			cout << "成功存入人民币" << smoney << "元！" << endl;
			return;
		}
		else {
			cout << "输入存款金额错误，请重新输入！" << endl;
		}
	}
}