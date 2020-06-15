#include<iostream>
#include<vector>
#include<cstdlib>

using namespace std;

int main(int argc, char *argv[]){

    if(argc < 2){
        cerr<<"Not enough arguments"<<endl;
        exit(0);
    }
    vector<int>vect(1,0);
    int size = atoi(argv[1]);
    cout<<size<<endl;
    while(true){
        vect.push_back(size);
    }
    return 0;
}