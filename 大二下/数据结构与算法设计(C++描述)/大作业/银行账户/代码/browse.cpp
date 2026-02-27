#include"Clients.h"
#include"Manager.h"
/*管理员浏览用户信息*/
void Manager::browse(BankAccount* pt,int number) {
	system("cls");
	int i = 0;
	BankAccount* p = pt;
	cout << "账户数量：" << number << endl;
	/*计算总存款数*/
	double  sum = 0;
	for (int j = 0; j < number; j++) {
		p = p->next;
		sum = sum + p->balance;
	}
	BankAccount* q = pt;
	cout << "总存款数：" << sum << endl;
	if (number > 0) {
		cout << "序号  ID        姓名        电话            电子邮箱            身份证号            银行卡号            账户余额" << endl;
		while (i < number) {
			q = q->next;
			display(q, i+1);
			i++;
		}
	}
	else
		cout << "系统中不存在账户！" << endl;
}