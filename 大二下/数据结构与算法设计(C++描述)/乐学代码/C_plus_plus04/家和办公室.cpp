#include<iostream>
using namespace std;
class Building {
    public:
        Building(int f, int r, double a);
        void show();
    private:
        int floor;
        int room;
        double area;
};
class House :public Building {
    public:
        House(int f, int r, double a, int b1, int b2);
        void show();
    private:
        int Bedrooms;
        int Bathrooms;
};
class Office :public Building {
    public:
        Office(int f, int r, double a, int t, int p);
        void show();
    private:
        int tables;
        int Phones;
};
Building::Building(int f, int r, double a) {
    floor = f;
    room = r;
    area = a;
}
House::House(int f, int r, double a, int b1, int b2) :Building(f, r, a) {
    Bedrooms = b1;
    Bathrooms = b2;
}
Office::Office(int f, int r, double a, int t, int p) :Building(f, r, a) {
    tables = t;
    Phones = p;
}
void Building::show() {
    cout << "floor:" << floor << endl;
    cout << "room:" << room << endl;
    cout << "area:" << area << endl;
}
void House::show() {
    cout << "house_information" << endl;
    Building::show();
    cout << "Bedrooms:" << Bedrooms << endl;
    cout << "Bathrooms:" << Bathrooms << endl;
}
void Office::show() {
    cout << "office_information" << endl;
    Building::show();
    cout << "tables:" << tables << endl;
    cout << "Phones:" << Phones << endl;
}
int main() {
    int f1, r1, a1, b1, b2;
    cin >> f1 >> r1 >> a1 >> b1 >> b2;
    House H(f1, r1, a1, b1, b2);
    int f2, r2, a2, t, p;
    cin >> f2 >> r2 >> a2 >> t >> p;
    Office O(f2, r2, a2, t, p);
    H.show();
    O.show();
    return 0;
}