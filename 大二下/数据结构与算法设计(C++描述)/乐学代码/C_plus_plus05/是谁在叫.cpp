#include<iostream>
using namespace std;
class Felid {
    public:
        Felid() {
            cout << "Felid constructor" << endl;
        }
        virtual void sound() = 0;
        virtual ~Felid() {
            cout << "Felid destructor" << endl;
        }
};
class Cat:public Felid {
    public:
        Cat() {
            cout << "Cat constructor" << endl;
        }
        ~Cat() {
            cout << "Cat destructor" << endl;
        }
        void sound() {
            cout << "Miaow !" << endl;
        }
};
class Leopard :public Felid {
    public:
        Leopard() {
            cout << "Leopard constructor" << endl;
        }
        ~Leopard() {
            cout << "Leopard destructor" << endl;
        }
        void sound() {
            cout << "Howl !" << endl;
        }
};
int main() {
    Felid* pc = new Cat;
    pc->sound();
    delete pc;
    Felid* pl = new Leopard;
    pl->sound();
    delete pl;
    return 0;
}