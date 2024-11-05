#ifndef __MY_CLASS_H__
#define __MY_CLASS_H__

#include <TObject.h>
#include <cmath>  // For sqrt()


class my_class : public TObject {

    public:
        
        my_class(); 
        my_class(Int_t variable);  
        virtual ~my_class();  

        Float_t px, py, pz, p;

        Float_t magnitude(Float_t px, Float_t py, Float_t pz);


    private:

    // ROOT class definition macro
    ClassDef(my_class, 1); // Class version 1
        


};


#endif // __MY_CLASS_H__