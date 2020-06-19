#include <iostream>
#include <vector>
#include <cstdlib>
#include <stdint.h>
#include <random>
#include <chrono>
#include <thread>
#include <unistd.h>
using namespace std;


void sleep(int sleepSeconds){
    this_thread::sleep_for (std::chrono::seconds(sleepSeconds));
    cout<<"Waking up " <<endl;
    return;
}

void printMatrix(vector<double>&matrix, int stride){
    for (int i = 0; i < matrix.size(); i++) {
        if (i %  stride== 0) {
            cout<<endl;
        }
        cout<<matrix[i];
    }
}

void mulitilicationHelper(vector<double> &matrix,int n){
    vector<double>temp = matrix;
    //cout<<"temp is :"<<temp[0]<<" "<<temp[1]<<endl;
    for(int i = 0; i < n; i++){
        for(int j = 0; j< n; j++){
            double sum = 0;
            #pragma simd
            for(int k = 0;k<n;k++){
                sum += temp[i * n + k] * temp[k * n + j];
            }
            matrix[i*n+j] = sum;
        }
    }
}

void multiplication(vector<double> &matrix, int sleepSeconds,int calcSeconds, int n){
    auto start = std::chrono::high_resolution_clock::now();
    int64_t calcSum = 0; // floating point calculation
    while(true){
        mulitilicationHelper(matrix, n);
        calcSum ++;
        // runing time is up, put to sleep
        if((std::chrono::high_resolution_clock::now()- start) >= std::chrono::seconds(calcSeconds)){
            //cout<<"Running time is up, " << "sleeping"<<endl;
            break;
        }
    }
    auto end = std::chrono::high_resolution_clock::now();
    cout<<"FLOPS: "<< 2.0*calcSum*n*n*n / calcSeconds <<endl;
}


int main(int argc, char*args[]){
    if(argc < 4){
        cout<<"Required <matrix size> <rough seconds to calculate> <sleep in seconds>"<<endl;
        cerr<<"Not enough arguments"<<endl;
        exit(0);
    }
    int n = atoi(args[1]);
    int calcSeconds = atoi(args[2]);
    int sleepSeconds = atoi(args[3]);
    vector<double> matrix(n * n,1);
    double timeCounter = 0;

    //generate random inital sleep time
    srand(time(NULL));
    int initSleepTime = (rand() % sleepSeconds)+1;
    sleep(sleepSeconds);
    cout<<"Initial sleep is over, begin multiplcation"<<endl;

    //working stage
    while(true){
        multiplication(matrix, sleepSeconds, calcSeconds, n);
        //printMatrix(matrix, n);
        sleep(sleepSeconds);
        for(auto elem : matrix) elem = 1;

    }

    return 0;
}