#include<iostream>
#include<string>
using namespace std;
class People {
    public:
	    People(string n, string s, int a);
		void show();
    protected:
		string Name;
		string Sex;
		int Age;
};
class Student :virtual public People {
    public:
		Student(string n1, string s1, int a, string s2, int score);
		void show();
    private:
		string No;
		int Score;
};
class Teacher :virtual public People {
    public:
		Teacher(string n, string s, int a, string p, string d);
		void show();
		void disp();
    private:
		string Position;
		string Department;
};
class GradOnWork :public Student, public Teacher {
    public:
		GradOnWork(string n1, string s1, int a, string s2, int score, string p, string d1, string d2, string t);
		void show();
    private:
		string Direction;
		string Tutor;
};
People::People(string n, string s, int a) {
	Name = n;
	Sex = s;
	Age = a;
}
void People::show() {
	cout << "Name: " << Name << endl;
	cout << "Sex: " << Sex << endl;
	cout << "Age: " << Age << endl;
}
Student::Student(string n1, string s1, int a, string s2, int score) :People(n1, s1, a) {
	No = s2;
	Score = score;
}
void Student::show() {
	People::show();
	cout << "No.: " << No << endl;
	cout << "Score: " << Score << endl;
}
Teacher::Teacher(string n, string s, int a, string p, string d) :People(n, s, a) {
	Position = p;
	Department = d;
}
void Teacher::show() {
	People::show();
	cout << "Position: " << Position << endl;
	cout << "Department: " << Department << endl;
}
GradOnWork::GradOnWork(string n1, string s1, int a, string s2, int score, string p, string d1, string d2, string t) :People(n1, s1, a), Student(n1, s1, a, s2, score), Teacher(n1, s1, a, p, d1) {
	Direction = d2;
	Tutor = t;
}
void Teacher::disp() {
	cout << "Position: " << Position << endl;
	cout << "Department: " << Department << endl;
}
void GradOnWork::show() {
	cout << "People:" << endl;
	People::show();
	cout << endl;
	cout << "Student:" << endl;
	Student::show();
	cout << endl;
	cout << "Teacher:" << endl;
	Teacher::show();
	cout << endl;
	cout << "GardOnWork:" << endl;
	Student::show();
	Teacher::disp();
	cout << "Direction: " << Direction << endl;
	cout << "Tutor: " << Tutor << endl;
}
int main() {
	string n1, s1, s2, p, d1, d2, t;
	int a, score;
	cin >> n1 >> s1 >> a;
	cin >> s2 >> score;
	cin >> p >> d1;
	cin >> d2 >> t;
	GradOnWork g(n1, s1, a, s2, score, p, d1, d2, t);
	g.show();
	return 0;
}