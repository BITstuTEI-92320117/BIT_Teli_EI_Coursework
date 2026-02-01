#include<iostream>
#include<string>
using namespace std;
class Book{
    public:
		Book(int n, string b1, string b2, double p1);
		void show();
    private:
	    int Num;
	    string BookName;
	    string BookConcern;
	    double Price;
};
class Author {
    public:
		Author(string a1, int a2, int p[3]);
		void show();
    private:
		string AuthorName;
		int AuthorAge;
		int PrintTime[3];
};
class Card :public Book, public Author {
    public:
		Card(int n, string b1, string b2, double p1, string a1, int a2, int p[3], string b);
		void show();
    private:
		string SysName;
};
Book::Book(int n, string b1, string b2, double p1) {
	Num = n;
	BookName = b1;
	BookConcern = b2;
	Price = p1;
}
Author::Author(string a1, int a2, int p[3]) {
	AuthorName = a1;
	AuthorAge = a2;
	int i;
	for (i = 0; i <= 2; i++) {
		PrintTime[i] = p[i];
	}
}
Card::Card(int n, string b1, string b2, double p1, string a1, int a2, int p[3], string b) :Book(n, b1, b2, p1), Author(a1, a2, p) {
	SysName = b;
}
void Book::show() {
	cout << "Num:" << Num << endl;
	cout << "BookName:" << BookName << endl;
	cout << "BookConcern:" << BookConcern << endl;
	cout << "Price:" << Price << endl;
}
void Author::show() {
	cout << "AuthorName:" << AuthorName << endl;
	cout << "AuthorAge:" << AuthorAge << endl;
	cout << "PrintTime:" << PrintTime[0] << "-" << PrintTime[1] << "-" << PrintTime[2] << endl;
}
void Card::show() {
	cout << "SysName:" << SysName << endl;
	Book::show();
	Author::show();
}
int main() {
	string s1, s2, s3, s4;
	int a1, a2, a3[3];
	double b;
	cin >> s1 >> a1 >> s2 >> s3 >> b >> s4 >> a2 >> a3[0] >> a3[1] >> a3[2];
	Card C(a1, s2, s3, b, s4, a2, a3, s1);
	C.show();
	return 0;
}