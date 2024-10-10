#include <iostream>
#include <string>

int main(int arg_counter, char *arg_list[]) {
  if (arg_counter== 3) {
    std::string output_name{arg_list[0]};
    auto Caracter1_arg_1{*(arg_list[1])};
    auto Length_output_name{output_name.size()};
    auto Int_numb_arg_2{std::atoi(arg_list[2])};
    auto var6{0};
    auto var7{0};
    std::string arg_1{arg_list[1]};
    while (true) {
      var6 += arg_1[var7++];
      if (var7 >= static_cast<int>(arg_1.size())) {
        break;
      }
    }
    if ((var6 ^ Caracter1_arg_1 * 3) <<  Length_output_name & 0x1f) == Int_numb_arg_2 ) {
      std::cout << "Correct!" << std::endl;
    } else {
      std::cout << "Wrong!" << std::endl;
    } 
  }
}
