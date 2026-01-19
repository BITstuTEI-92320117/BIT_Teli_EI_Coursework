#include<iostream>
using namespace std;
class Shape {
    public:
        virtual double Area() = 0;
        virtual double Volume() = 0;
        double pi = 3.14;
};
class Cube :public Shape{
    public:
        Cube(double a0);
        double Area();
        double Volume();
    private:
        double a;
};
class Sphere :public Shape {
    public:
        Sphere(double r);
        double Area();
        double Volume();
    private:
        double r;
};
class Cylinder :public Shape {
    public:
        Cylinder(double r0,double h0);
        double Area();
        double Volume();
    private:
        double r;
        double h;
};
Cube::Cube(double a0) {
    a = a0;
}
double Cube::Area() {
    return a * a * 6;
}
double Cube::Volume() {
    return a * a * a;
}
Sphere::Sphere(double a0) {
    r = a0;
}
double Sphere::Area() {
    return 4 * pi * r * r;
}
double Sphere::Volume() {
    return 4 * pi * r * r * r / 3;
}
Cylinder::Cylinder(double r0, double h0) {
    r = r0;
    h = h0;
}
double Cylinder::Area() {
    return 2 * pi * r * h + 2 * pi * r * r;
}
double Cylinder::Volume() {
    return pi * r * r * h;
}
int main() {
    int a, b, c, d;
    cin >> a >> b >> c >> d;
    Shape* p;
    Cube C(a);
    p = &C;
    cout << "Shape：正方体" << endl;
    cout << " 面积、体积：" << p->Area() << " " << p->Volume() << endl;
    Sphere S(b);
    p = &S;
    cout << "Shape：球体" << endl;
    cout << " 面积、体积：" << p->Area() << " " << p->Volume() << endl;
    Cylinder C1(c,d);
    p = &C1;
    cout << "Shape：圆柱体" << endl;
    cout << " 面积、体积：" << p->Area() << " " << p->Volume() << endl;
}