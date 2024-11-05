#include "my_class.h"
#include <cmath> 
ClassImp(my_class)


Float_t my_class::magnitude(Float_t px, Float_t py, Float_t pz)
{
    Float_t p =std::sqrt(px * px + py * py + pz * pz); 
    return 1;
}

my_class::my_class() {

}

my_class::my_class(Int_t variable) {

}


my_class::~my_class() {
    
}

