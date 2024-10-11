#include <iostream>
#include <string>

// The void things look a bit ugly, had to split the sum and printkey function since i have to call them in diffrent functions.

void usage() {
  std::cout << "Not right amount of parameters" << std::endl; 
  std::cout << "How the program works: ./<program_name> <arg_1> <arg_2>" << std::endl; 
}

void sum(int checksum) {
  std::cout << "The calculated sum: " << checksum << std::endl;
}

void printkey(int key, int Int_numb_arg_2) {
  std::cout << "The expected key: " << key << std::endl;
  std::cout << "The key input: " << Int_numb_arg_2 << std::endl;
}


int function(std::string arg_1) {
  auto checksum{0};
  for (int i=0; i>=0; i++) {
    checksum += arg_1[i];
    if (i >= static_cast<int>(arg_1.size())) {
      break;
      }
  }
    sum(checksum);
    return checksum;
}


int checkkey(char *arg_list[]) {
  std::string output_name{arg_list[0]};
  auto Caracter1_arg_1{*(arg_list[1])};
  auto Length_output_name{output_name.size()};
  std::string arg_1{arg_list[1]};
  int checksum = function(arg_1);
  int main(int arg_counter, char *arg_list[]);
  return (checksum^Caracter1_arg_1 * 3) <<  (Length_output_name & 0x1f);
}


int main(int arg_counter, char *arg_list[]) {
  if (arg_counter != 3) {
    usage();
    return 1;
    } 
    else {  
      auto Int_numb_arg_2{std::atoi(arg_list[2])};
      
      int key = checkkey(arg_list);
      printkey(key, Int_numb_arg_2);

      if (key == Int_numb_arg_2) {
        std::cout << "Correct!" << std::endl;
        } 
      else {
        std::cout << "Wrong!" << std::endl;
      } 
    
    }
  
}


  



