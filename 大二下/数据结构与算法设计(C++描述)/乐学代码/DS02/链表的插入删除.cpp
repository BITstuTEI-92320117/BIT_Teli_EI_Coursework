#include<iostream>
#include<string>
using namespace std;
class list;
class ListNode {
public:
	ListNode();
	ListNode(int d, ListNode* q);
	friend class list;
private:
	int data;
	ListNode* next;
};
ListNode::ListNode() {
	next = NULL;
}
ListNode::ListNode(int d, ListNode* q) {
	data = d;
	next = q;
}
class list {
public:
	list();
	ListNode* GetHead();
	bool insert(int x, int y);
	int remove(int x);
	ListNode* find(int x);
	void display();
private:
	ListNode* head;
	int length;
};
list::list() {
	length = 0;
	head = new ListNode;
}
ListNode* list::GetHead() {
	return head;
}
ListNode* list::find(int x) {
	ListNode* q = GetHead();
	ListNode* p = GetHead();
	if (p == NULL || length==0) {
		return NULL;
	}
	p = p->next;
	int i=1;
	while (i <= length && p->data != x) {
		q = p;
		p = p->next;
		i++;
	}
	return q;
}
bool list::insert(int x, int y) {
	ListNode* q = find(x);
	ListNode* qt;
	if (q == NULL) {
		qt=NULL;
		q = GetHead();
	}
	else {
		qt = q->next;
	}
	ListNode* pt = new ListNode(y, qt);
	if (pt == NULL) {
		return false;
	}
		q->next = pt;
	length++;
	return true;
}
int list::remove(int x) {
	ListNode* p = find(x);
	if (p == NULL) {
		return false;
	}
	ListNode* q = p->next;
	p->next = q->next;
	int value = q->data;
	delete q;
	length--;
	return value;
}
void list::display() {
	if (length == 0) {
		cout << "NULL" << endl;
		return;
	}
	ListNode* p = GetHead();
	p = p->next;
	if (p == NULL || p->next == NULL) {
		return;
	}
	while (p != NULL) {
		cout << p->data << " ";
		p = p->next;
	}
	cout << endl;
	return;
}
int main() {
	int n, a1, a2, i;
	string s;
	cin >> n;
	list l;
	for (i = 0; i <= n - 1; i++) {
		cin >> s;
		if (s == "delete") {
			cin >> a1;
			l.remove(a1);
		}
		else {
			cin >> a1 >> a2;
			l.insert(a1, a2);
		}
	}
	l.display();
}