#include"Clients.h"
/*销户*/
void Clients::cancelaccount(BankAccount* q) {
	system("cls");
	BankAccount* pt = head;
	if (q->balance != 0)
		cout << "余额不为零，无法办理销户！" << endl;
	/*删除用户q所在结点*/
	else {
		while (pt->next != q && pt != NULL) {
			pt = pt->next;
		}
		if (pt == NULL) {
			cout << "系统错误！" << endl;
		}
		if (pt->next == q) {
			pt->next = q->next;
			delete q;
			cout << "销户成功！" << "\n";
		}
	}
	length--;
	number--;
}