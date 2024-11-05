#include "TFile.h"
#include "TH1.h"
#include "TH2.h"
#include "TProfile.h"
#include "TRandom.h"
#include "TTree.h"
#include "my_class.h"

void write(Int_t nEvents){

    my_class* p_object = new my_class();

    TFile file("tree_file.root", "RECREATE");
    TTree tree("Tree","An example of ROOT tree with a few branches");

    tree.Branch("px",&p_object, "px/F");
    tree.Branch("py",&p_object, "px/F");
    tree.Branch("pz",&p_object, "px/F");


    //Int_t nEvents = 1000;

    Float_t px,py,pz;

    for (Int_t i{0}; i<nEvents; i++){ 

        px = gRandom->Gaus(0,.02);
        py = gRandom->Gaus(0,.02);
        pz = gRandom->Gaus(0,.02);

        tree.Fill();
        
    }


tree.Write();
file.Close();

delete p_object;

}

