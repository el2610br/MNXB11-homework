void read(){

    // initialize your object
    my_class* p_object = new my_class();

    // open your file
    auto file = TFile::Open("tree_file.root");

    // get your tree
    TTree tree_px(static_cast<TTree*>(file->Get("px")));
    TTree tree_py(static_cast<TTree*>(file->Get("py")));
    TTree tree_pz(static_cast<TTree*>(file->Get("pz")));


    // remember to set the branch address

    for (Int_t i{0}; i<N; i++){ // loop over the whole tree
        tree->GetEntry(i);
        // do something
    }
}
