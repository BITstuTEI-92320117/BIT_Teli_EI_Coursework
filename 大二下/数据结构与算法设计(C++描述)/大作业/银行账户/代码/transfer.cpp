#include"Clients.h"
#include"Manager.h"
/*客户转账*/
void Clients::transfer(BankAccount* q) {
	system("cls");
	string card1;
	string card2;
	double money;
	int flag = 0;
	BankAccount* pt = head;
	card1 = q->account_number;
	cout << "请输入转入方的银行卡号：" << endl;
	cin >> card2;
	/*遍历寻找转入方账户*/
	while (pt != NULL) {
		if (pt->account_number == card2) {
			flag = 1;
			break;
		}
		else {
			pt = pt->next;
		}
	}
	if (flag == 0) {
		cout << "该银行卡号对应的用户不存在！" << endl;
	}
	else {
		cout << "请输入要转账的金额：" << endl;
		cin >> money;
		/*计算转出方账户需要扣除的总额，即转出金额+手续费*/
		double fee;
		double handling_fee = 0.001;
		fee = money + money * handling_fee;
		if (q->balance < fee) 
			cout << "余额不足，转账失败！" << endl;
		else {
			pt->balance += money;
			q->balance -= fee;
			cout << "转账成功！" << endl;
			cout << "本次转账的手续费为：" << money * handling_fee << endl;
		}
	}
}

/*管理员转账*/
void Manager::transfer(BankAccount* p) {
	system("cls");
	string card1;
	string card2;
	double money;
	int flag1 = 0, flag2 = 0;
	cout << "请输入转出方的银行卡号：" << endl;
	BankAccount* pt = p;
	BankAccount* qt = p;
	cin >> card1;
	/*遍历寻找转出方账户*/
	while (qt != NULL) {
		if (qt->account_number == card1) {
			flag1 = 1;
			break;
		}
		else {
			qt = qt->next;
		}
	}
	if (flag1 == 0) {
		cout << "该银行号对应的用户不存在！" << endl;
	}
	else {
		cout << "请输入转入方的银行卡号：" << endl;
		cin >> card2;
		/*遍历寻找转入方账户*/
		while (pt != NULL) {
			if (pt->account_number == card2) {
				flag2 = 1;
				break;
			}
			else {
				pt = pt->next;
			}
		}
		if (flag2 == 0) {
			cout << "该银行卡号对应的用户不存在！" << endl;
		}
		else {
			cout << "请输入要转账的金额：" << endl;
			cin >> money;
			/*计算转出方账户需要扣除的总额，即转出金额+手续费*/
			double fee;
			double handling_fee = 0.001;
			fee = money + money * handling_fee;
			if (qt->balance < fee) cout << "余额不足，转账失败！" << endl;
			else {
				pt->balance += money;
				qt->balance -= fee;
				cout << "转账成功！" << "\n";
				cout << "本次转账的手续费为：" << money * handling_fee << endl;
			}
		}
	}
}