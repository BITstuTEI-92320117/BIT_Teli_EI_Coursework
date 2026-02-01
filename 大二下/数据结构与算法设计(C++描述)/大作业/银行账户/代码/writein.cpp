#include"Clients.h"
#include<fstream>
#include <sstream>
int Clients::writein()
{
	ifstream inFile("data.txt");
	if (!inFile.is_open()) {
		cout << "系统中没有账户，请客户先进行开户操作！" << endl;
		return 1;
	}
	string line;
	/*跳过表头*/
	getline(inFile, line);
	// 逐行读取文件内容
	while (getline(inFile, line)) {
		istringstream iss(line);
		int n;
		double _balance;
		string _name;
		string pass_word1;
		string id;
		string e_mail;
		string tele_phone;
		string id_card;
		string _account_number = "";
		iss >> n >> id >> _name >> tele_phone >> e_mail >> id_card >> _account_number >> _balance >> pass_word1;
		BankAccount* p = new BankAccount(id, pass_word1, _name, tele_phone, _account_number, e_mail, id_card, _balance);
		p->next = head->next;
		head->next = p;
		length++;
		number++;
	}
	return 0;
}