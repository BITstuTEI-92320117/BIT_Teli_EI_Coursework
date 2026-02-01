#include<iostream>
#include<string>
using namespace std;
class Person {
    public:
        Person(string n, int a, int s);
        void show(); 
    private:
        string name;
        int age;
        int sex;
};
class Employee :public Person {
    public:
        Employee(string n, int a, int s, int b, int l);
        void show();
    private:
        int basicSalary;
        int leavedays;
};
Person::Person(string n, int a, int s) {
    name = n;
    age = a;
    sex = s;
}
Employee::Employee(string n, int a, int s, int b, int l) :Person(n, a, s) {
    basicSalary = b;
    leavedays = l;
}
void Person::show() {
    cout << "name:" << name << endl;
    cout << "age:" << age << endl;
    if (sex == 1) {
        cout << "sex:ÄÐ" << endl;
    }
    else {
        cout << "sex:Å®" << endl;
    }
}
void Employee::show() {
    Person::show();
    cout << "basicSalary:" << basicSalary << endl;
    cout << "leavedays:" << leavedays << endl;
}
int main() {
    string n;
    int a, s, b, l;
    cin >> n >> s >> a >> b >> l;
    Employee E(n, a, s, b, l);
    E.show();
    return 0;
}