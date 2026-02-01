#include"Manager.h"
/*管理员选择通过ID、姓名、电话、电子邮箱、身份证号或银行卡号来查找用户信息*/
bool Manager::types1(BankAccount* pt0, int n, string s) {
	if (n == 1) {
		if (pt0->ID == s)
			return true;
		else
			return false;
	}
	else if (n == 2) {
		if (pt0->name == s)
			return true;
		else
			return false;
	}
	else if (n == 3) {
		if (pt0->telephone == s)
			return true;
		else
			return false;
	}
	else if (n == 4) {
		if (pt0->email == s)
			return true;
		else
			return false;
	}
	else if (n == 5) {
		if (pt0->IDcard == s)
			return true;
		else
			return false;
	}
	else if (n == 6) {
		if (pt0->account_number == s)
			return true;
		else
			return false;
	}
	else {
		return false;
	}
}
/*管理员选择通过账户余额范围来查找用户信息*/
bool Manager::types2(BankAccount* pt2, int min, int max) {
	if (min <= pt2->balance && pt2->balance <= max) 
		return true;
	else 
		return false;
}