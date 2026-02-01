#include<iostream>
using namespace std;
class List;
class ListNode {
public:
	ListNode();
	ListNode(int d, ListNode* p);
	int data;
	ListNode* next;
	friend class List;
private:
};
ListNode::ListNode() {
	next = NULL;
}
ListNode::ListNode(int d, ListNode* p) {
	data = d;
	next = p;
}
class List {
public:
	List();
	ListNode* GetHead();
	ListNode* insert(int n, ListNode* p);
	void input();
	void output();
private:
	ListNode* head;
	int length;
};
List::List() {
	head = new ListNode;
	length = 0;
}
ListNode* List::GetHead() {
	return head;
}
ListNode* List::insert(int n, ListNode* p) {
	if (p == NULL) {
		return p;
	}
	ListNode* q = new ListNode(n, NULL);
	if (q == NULL) {
		return p;
	}
	p->next = q;
	length++;
	return q;
}
void List::input() {
	int n;
	ListNode* p = GetHead();
	while (cin >> n) {
		p = insert(n, p);
		if (cin.get() == '\n') 
			break;
	}
}
void List::output() {
	ListNode* p = GetHead();
	if (p == NULL || length == 0) {
		cout << "没有交集" <<endl;
		exit(1);
	}
	p = p->next;
	while (p != NULL) {
		cout << p->data << " ";
		p = p->next;
	}
	cout << endl;
}
int main() {
	List la, lb, lc;
	la.input();
	lb.input();
	ListNode* pt = la.GetHead();
	ListNode* qt = lb.GetHead();
	ListNode* rt = lc.GetHead();
	if (pt->next == NULL || qt->next == NULL) {
		lc.output();
	}
	pt = pt->next;
	qt = qt->next;
	while (pt != NULL) {
		while (pt->data > qt->data && qt->next != NULL) {
			qt = qt->next;
		}
		if (pt->data == qt->data) {
			if (pt->data > rt->data) {
				rt = lc.insert(pt->data, rt);
			}
			pt = pt->next;
		}
		else if (pt->data < qt->data && pt->next != NULL) {
			pt = pt->next;
		}
		else if (pt->data < qt->data && pt->next == NULL)
			break;
		else if (qt->next == NULL)
			break;
	}
	lc.output();
	return 0;
}