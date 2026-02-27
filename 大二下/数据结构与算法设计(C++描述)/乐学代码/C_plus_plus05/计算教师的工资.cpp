#include<iostream>
#include<string>
using namespace std;
class Teacher {
    public:
        Teacher(string n, string s, string w, int c);
        void show();
        virtual void pay() = 0;
        int a;
        int coursenum;
        string name;
        string sex;
        string worknum;
};
class Professor:public Teacher {
    public:
        Professor(string n, string s, string w, int c);
        void pay();
    private:
        int pays;
        int subsidise;
};
class AProfessor :public Teacher {
    public:
        AProfessor(string n, string s, string w, int c);
        void pay();
    private:
        int pays;
        int subsidise;
};
class Tutors :public Teacher {
    public:
        Tutors(string n, string s, string w, int c);
        void pay();
    private:
        int pays;
        int subsidise;
};
Teacher::Teacher(string n, string s, string w, int c) {
    name = n;
    sex = s;
    worknum = w;
    coursenum = c;
}
void Teacher::show() {
    cout << "姓名：" << name << endl;
    cout << "性别：" << sex << endl;
    cout << "工号：" << worknum << endl;
    cout << "课时数：" << coursenum << endl;
}
Professor::Professor(string n, string s, string w , int c) :Teacher(n, s, w, c) {
    subsidise = 50;
}
void Professor::pay() {
    pays = 20000 + subsidise * coursenum;
    cout << "职称：教授" << endl;
    show();
    cout << "本月工资：" << pays << endl;
}
AProfessor::AProfessor(string n, string s, string w, int c) :Teacher(n, s, w, c) {
    subsidise = 30;
}
void AProfessor::pay() {
    pays = 15000 + subsidise * coursenum;
    cout << "职称：副教授" << endl;
    show();
    cout << "本月工资：" << pays << endl;
}
Tutors::Tutors(string n, string s, string w, int c):Teacher(n, s, w, c) {
    subsidise = 20;
}
void Tutors::pay() {
    pays = 10000 + subsidise * coursenum;
    cout << "职称：讲师" << endl;
    show();
    cout << "本月工资：" << pays << endl;
}
int main() {
    int i, c;
    string n, s, w;
    Teacher* pf;
    cin >> i >> n >> s >> w >> c;
    if (i == 1) {
        Professor P(n, s, w, c);
        pf = &P;
        pf->pay();
    }
    else if (i == 2) {
        AProfessor AP(n, s, w, c);
        pf = &AP;
        pf->pay();
    }
    else {
        Tutors T(n, s, w, c);
        pf = &T;
        pf->pay();
    }
    return 0;
}