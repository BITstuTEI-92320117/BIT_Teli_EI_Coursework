#include<iostream>
using namespace std;
class ListNode {
public:
	ListNode();
	ListNode(int d, ListNode* n, ListNode* l);
	int data;
	ListNode* next;
	ListNode* last;
};
ListNode::ListNode() {
	next = NULL;
	last = NULL;
}
ListNode::ListNode(int d, ListNode* p, ListNode* l) {
	data = d;
	next = p;
	last = l;
}
class List {
public:
	List();
	ListNode* GetHead();
	int GetLength();
	ListNode* insert(int n, ListNode* p);
private:
	ListNode* head;
	int length;
};
ListNode* List::GetHead() {
	return head;
}
int  List::GetLength() {
	return length;
}
List::List() {
	head = new ListNode;
	length = 0;
}
ListNode* List::insert(int n, ListNode* p) {
	ListNode* q = new ListNode(n, NULL, p);
	if (q == NULL) {
		return NULL;
	}
	p->next = q;
	length++;
	return q;
}
int main() {
	int n, i, flag = 0;
	List l;
	ListNode* p = l.GetHead();
	while (cin >> n) {
		p = l.insert(n, p);
		if (cin.get() == '\n')
			break;
	}
	ListNode* q = l.GetHead();
	q = q->next;
	for (i = 0; i <= l.GetLength() - 1; i++) {
		if (p->data != q->data) {
			flag = 1;
			break;
		}
		p = p->last;
		q = q->next;
	}
	if (flag == 0) {
		cout << 1 << endl;
	}
	else {
		cout << 0 << endl;
	}
	return 0;
}