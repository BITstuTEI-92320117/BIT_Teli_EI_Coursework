#include<iostream>
using namespace std;
class Shape {
    public:
        Shape() {
            cout << "Shape constructor" << endl;
        }
        virtual ~Shape() {
            cout << "Shape destructor" << endl;
        }
        virtual void calcArea() = 0;
        virtual void calcVolume() = 0;
        virtual void set_r(double r0) = 0;
        virtual void set_a(double a0) = 0;
        virtual void set_b(double b0) = 0;
        virtual void set_c(double c0) = 0;
        virtual void printValue() = 0;
};
class Circle: public Shape {
    public:
        Circle() :Shape() {
            cout << "Circle constructor" << endl;
        }
        ~Circle() {
            cout << "Circle destructor" << endl;
        }
        void calcVolume(){}
        void set_a(double a0){}
        void set_b(double b0){}
        void set_c(double c0){}
        void calcArea() {
            Area = 3.1415926 * r * r;
        }
        void set_r(double r0) {
            r = r0;
        }
        void printValue();
    private:
        double r;
        double Area;
};
class Rectangle : public Shape {
    public:
        Rectangle() :Shape() {
            cout << "Rectangle constructor" << endl;
        }
        ~Rectangle() {
            cout << "Rectangle destructor" << endl;
        }
        void calcVolume() {}
        void set_r(double r0) {}
        void set_c(double c0) {}
        void calcArea() {
            Area = a * b;
        }
        void set_a(double a0) {
            a = a0;
        }
        void set_b(double b0) {
            b = b0;
        }
        void printValue();
    private:
        double a;
        double b;
        double Area;
};
class Cuboid :public Shape {
    public:
        Cuboid() :Shape() {
            cout << "Cuboid constructor" << endl;
        }
        ~Cuboid() {
            cout << "Cuboid destructor" << endl;
        }
        void calcArea() {}
        void set_r(double r0) {}
        void calcVolume() {
            Volume = a * b * c;
        }
        void set_a(double a0) {
            a = a0;
        }
        void set_b(double b0) {
            b = b0;
        }
        void set_c(double c0) {
            c = c0;
        }
        void printValue();
    private:
        double a;
        double b;
        double c;
        double Volume;
};
void Circle::printValue(){
    cout << "Circle" << endl;
    cout << "r=" << r << endl;
    cout << "s=" << Area << endl;
}
void Rectangle::printValue() {
    cout << "Rectangle" << endl;
    cout << "a=" << a << endl;
    cout << "b=" << b << endl;
    cout << "s=" << Area << endl;
}void Cuboid::printValue() {
    cout << "Cuboid" << endl;
    cout << "a=" << a << endl;
    cout << "b=" << b << endl;
    cout << "c=" << c << endl;
    cout << "v=" << Volume << endl;
}
int main() {
    int flag;
    double r0, a0, b0, c0;
    cin >> flag;
    if (flag == 1) {
        cin >> r0;
        Shape* p = new Circle;
        p->set_r(r0);
        p->calcArea();
        p->printValue();
        delete p;
    }
    else if (flag == 2) {
        cin >> a0 >> b0;
        Shape* p = new Rectangle;
        p->set_a(a0);
        p->set_b(b0);
        p->calcArea();
        p->printValue();
        delete p;
    }
    else {
        cin >> a0 >> b0 >> c0;
        Shape* p = new Cuboid;
        p->set_a(a0);
        p->set_b(b0);
        p->set_c(c0);
        p->calcVolume();
        p->printValue();
        delete p;
    }
    return 0;
}