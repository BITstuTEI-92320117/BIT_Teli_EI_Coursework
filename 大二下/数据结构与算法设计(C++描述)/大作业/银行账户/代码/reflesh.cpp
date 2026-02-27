#include"Clients.h"
#include"Manager.h"
#include <iomanip>
#include<fstream>
#include <sstream>
/*客户信息导出为文件（自动生成文件data.txt）*/
int Manager::reflesh(BankAccount* p) {
	/*创立并更新银行数据文件*/
	ofstream outFile("data.txt");
	/*检查文件是否成功打开*/
	if (!outFile.is_open()) {
		cout << "无法创建文件！" << endl;
		return 1;
	}
	/*数据写入*/
	outFile << "序号  ID        姓名        电话            电子邮箱            身份证号            银行卡号            账户余额           密码" << endl;
	BankAccount* qt = p;
	int i = 0;
	while (qt != NULL) {
		qt = qt->next;
		i++;
		if (i != 0) {
			outFile << left << setw(6) << i;
			outFile << left << setw(10) << qt->ID;
			outFile << left << setw(12) << qt->name;
			outFile << left << setw(16) << qt->telephone;
			outFile << left << setw(20) << qt->email;
			outFile << left << setw(20) << qt->IDcard;
			outFile << left << setw(20) << qt->account_number;
			outFile << left << setw(10) << qt->balance;
			outFile << left << setw(27) << qt->password << endl;
		}
	}
	outFile.close();
	return 0;
}