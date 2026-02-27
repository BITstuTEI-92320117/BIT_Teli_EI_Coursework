#include<iostream>
using namespace std;
class Circle {
    public:
        Circle();
        void area();
    private:
        double radius;
        double pi = 3.14159;
};
class Rectangle {
    public:
        Rectangle();
        void area();
    private:
        double length;
        double width;
};
Circle::Circle() {
    cout << "请输入圆的半径" << endl;
    cin >> radius;
}
Rectangle::Rectangle() {
    cout << "请输入矩形的长和宽" << endl;
    cin >> length >> width;
}
void Circle::area(){
    double a;
    a = pi * radius * radius;
    cout << "area of circle = " << a << endl;
}
void Rectangle::area() {
    double a;
    a = length * width;
    cout << "area of rectangle = " << a << endl;
}
int main() {
    Circle circle1;
    circle1.area();
    Rectangle rectangle1;
    rectangle1.area();
    return 0;
}