#include<iostream>
using namespace std;
class ListNode {
public:
	ListNode();
	ListNode(const int d, ListNode* p);
	int data;
	ListNode* next;
};
ListNode::ListNode() {
	next = NULL;
}
ListNode::ListNode(const int d, ListNode* p) {
	data = d;
	ListNode* next = p;
}
class List {
public:
	List();
	ListNode* GetHead();
	ListNode* insert(int n, ListNode* p);
	int Find(int m);
private:
	ListNode* head;
	int length;
};
ListNode* List::GetHead() {
	return head;
}
List::List() {
	head = new ListNode;
	length = 0;
}
ListNode* List::insert(int n, ListNode* p) {
	ListNode* q = new ListNode(n, NULL);
	if (q == NULL) {
		return NULL;
	}
	p->next = q;
	return q;
}
int List::Find(int m) {
	ListNode* p = GetHead();
	if (p == NULL) {
		return false;
	}
	int i = 1;
	p = p->next;
	while (i < m) {
		p = p->next;
		i++;
	}
	return p->data;
}
int main() {
	int m, n, a, i;
	List l;
	cin >> m;
	if (m == 0) {
		cout << 0 << endl;
		return 0;
	}
	ListNode* p = l.GetHead();
	if (m % 2 == 0) {
		n = 1 + m / 2;
	}
	else {
		n = (m + 1) / 2;
	}
	for (i = 0; i <= n - 1; i++) {
		cin >> a;
		p = l.insert(a, p);
	}
	cout << l.Find(n) << endl;
	return 0;
}