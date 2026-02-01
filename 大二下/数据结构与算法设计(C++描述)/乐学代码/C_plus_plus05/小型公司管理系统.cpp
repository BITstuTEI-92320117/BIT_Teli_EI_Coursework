#include<iostream>
using namespace std;
class Employee {
    public:
        Employee(int h, int i1, int i2);
        virtual void pay() = 0;
    protected:
        int hour;
        int income1;
        int income2;
};
class Manager:public Employee {
    public:
        Manager(int h, int i1, int i2) :Employee(h, i1, i2) {}
        void pay();
    private:
        int salary = 8000;
};
class Technician :public Employee {
    public:
        Technician(int h, int i1, int i2) :Employee(h, i1, i2) {}
        void pay();
    private:
        int salary;
};
class Sales :public Employee {
    public:
        Sales(int h, int i1, int i2) :Employee(h, i1, i2) {}
        void pay();
    private:
        int salary;
};
class Salesmanager :public Employee {
    public:
        Salesmanager(int h, int i1, int i2) :Employee(h, i1, i2) {}
        void pay();
    private:
        int salary;
};
Employee::Employee(int h,int i1,int i2) {
    hour = h;
    income1 = i1;
    income2 = i2;
}
void Manager::pay() {
    cout << "Tom本月工资" << salary << endl;
}
void Technician::pay() {
    salary = 100 * hour;
    cout << "John本月工资" << salary << endl;
}
void Salesmanager::pay() {
    salary = 0.005 * income1 + 5000;
    cout << "Antony本月工资" << salary << endl;
}
void Sales::pay() {
    salary = 0.04 * income2;
    cout << "Jane本月工资" << salary << endl;
}
int main() {
    int h, i1, i2;
    cin >> h >> i1 >> i2;
    Employee* p;
    Manager M(h, i1, i2);
    p = &M;
    p->pay();
    Technician T(h, i1, i2);
    p = &T;
    p->pay();
    Salesmanager S1(h, i1, i2);
    p = &S1;
    p->pay();
    Sales S2(h, i1, i2);
    p = &S2;
    p->pay();
    return 0;
}