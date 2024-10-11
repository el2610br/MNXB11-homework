#include <iostream>
#include <string>


int function(std::string arg_1) {
  auto checksum{0};
  for (int i=0; i>=0; i++) {
    checksum += arg_1[i];
    if (i >= static_cast<int>(arg_1.size())) {
      break;
      }
  }
    return checksum;
}

int checkkey(char *arg_list[]) {
  std::string output_name{arg_list[0]};
  auto Caracter1_arg_1{*(arg_list[1])};
  auto Length_output_name{output_name.size()};
  std::string arg_1{arg_list[1]};
  int checksum = function(arg_1);

  return (checksum ^ Caracter1_arg_1 * 3) <<  (Length_output_name & 0x1f);
}


int main(int arg_counter, char *arg_list[]) {
  if (arg_counter== 3) {
    auto Int_numb_arg_2{std::atoi(arg_list[2])};
    
    int key = checkkey(arg_list);

    if (key == Int_numb_arg_2) {
      std::cout << "Correct!" << std::endl;
    } else {
      std::cout << "Wrong!" << std::endl;
    } 
  }
}


