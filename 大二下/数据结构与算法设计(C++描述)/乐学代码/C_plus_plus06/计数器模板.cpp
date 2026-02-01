#include <iostream> 
#include <string> 
using namespace std; 
 
template <class T> 
int count(T* arr, T& target,int n) { 
    int cnt = 0; 
    for (int i=0;i<n;i++) { 
        if (arr[i] == target) 
            cnt++; 
    } 
    return cnt; 
} 
 
int main() { 
    int dataType; 
    cin >> dataType; 
 
    int n; 
    cin >> n; 
 
    if (dataType == 1) { 
        int* arr=new int[n]; 
        for(int i=0;i<n;i++){ 
          cin >>arr[i]; 
        } 
        int target; 
        cin >> target; 
        cout << count(arr, target,n) << endl; 
    } 
    else if (dataType == 2) { 
        float* arr=new float[n]; 
         for(int i=0;i<n;i++){ 
                    cin >>arr[i]; 
                } 
        float target; 
        cin >> target; 
        cout << count(arr, target,n) <<endl; 
    } 
    else if (dataType == 3) {  
        double* arr=new double[n]; 
        for(int i=0;i<n;i++){ 
             cin >>arr[i]; 
            } 
        double target; 
        cin >> target; 
        cout << count(arr, target,n) << endl; 
    } 
    else if (dataType == 4) { // string 
        string *arr=new string[n]; 
        for(int i=0;i<n;i++){ 
              cin >>arr[i]; 
            } 
        string target; 
        cin >> target; 
        cout << count(arr, target,n) << endl; 
    } 
 
    return 0; 
}  