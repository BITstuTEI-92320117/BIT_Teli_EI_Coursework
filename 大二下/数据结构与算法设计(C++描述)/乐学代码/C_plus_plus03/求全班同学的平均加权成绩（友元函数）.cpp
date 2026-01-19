#include<iostream>
#include<string>
using namespace std;
class Students {
private:
    string name;
    double grade[100];
    int score[100];
    friend double average(Students S[100]);
    friend int input(Students S[100]);
};
int input(Students S[100]) {
    string name;
    double grade;
    int i = 0;
    int j = 0;
    cin >> name;
    while (name!="no") {
        j = 0;
        S[i].name = name;
        cin >> grade;
        while (grade != -1) {
            S[i].grade[j] = grade;
            cin >> S[i].score[j];
            cin >> grade;
            j++;
        }
        S[i].grade[j] = grade;
        cin >> name;
        i++;
    }
    S[i].name = "no";
    return 0;
}
double average(Students S[100]) {
    double sum1 = 0;
    double sum2 = 0;
    int i = 0;
    int j = 0;
    while (S[i].name != "no") {
        j = 0;
        while (S[i].grade[j] != -1) {
            sum1 = sum1 + S[i].grade[j] * S[i].score[j];
            sum2 = sum2 + S[i].grade[j];
            j++;
        }
        i++;
    }
    return sum1 * 1.0 / sum2;
}
int main() {
    Students students[100];
    input(students);
    cout << average(students)<<endl;
    return 0;
}