#include <iostream>
#include <vector>
#include <cstdlib>
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

vector<double> mulitilicationHelper(vector<double> matrix,int stride){
    vector<double>temp = matrix;
    for(int i = 0; i<stride; i++){
        for(int j = 0; j<stride; j++){
            int sum = 0;
            for(int k = 0;k<stride;k++){
                sum += temp[i * stride + k] * temp[k * stride+j];
            }
            matrix[i*stride+j] = sum;
        }
    }
    return matrix;
}

vector<double> multiplication(vector<double> matrix, int sleepSeconds,int roughSeconds, int stride){
    auto start = std::chrono::high_resolution_clock::now();
    while(true){
        vector<double>res = mulitilicationHelper(matrix, stride);
        // running time is up, put to sleep
        if((std::chrono::steady_clock::now() - start) > std::chrono::seconds(roughSeconds)){
            cout<<"Running time is up, sleeping"<<endl;
            return res;
        }
    }
}


int main(int argc, char*args[]){
    if(argc < 4){
        cout<<"Required <matrix size> <rough seconds to calculate> <sleep in seconds>"<<endl;
        cerr<<"Not enough arguments"<<endl;
        exit(0);
    }
    int stride = atoi(args[1]);
    int roughSeconds = atoi(args[2]);
    int sleepSeconds = atoi(args[3]);
    //vector<double> matrix(stride * stride,1);
    vector<double> matrix;
    matrix.push_back(1);
    matrix.push_back(2);
    matrix.push_back(3);
    matrix.push_back(4);
    double timeCounter = 0;

    //generate random inital sleep time
    srand(time(NULL));
    int initSleepTime = (rand() % sleepSeconds)+1;
    sleep(sleepSeconds);
    cout<<"Initial sleep is over, begin multiplcation"<<endl;

    //working stage
    while(true){
        vector<double>res = multiplication(matrix, sleepSeconds, roughSeconds, stride);
        printMatrix(res, stride);
        sleep(sleepSeconds);

    }



    return 0;
}