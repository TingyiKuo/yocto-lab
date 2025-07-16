#include <iostream>
#include "mathlib.h"

int main() {
    std::cout << "Hello, world from Yocto!" << std::endl;
    std::cout << get_library_version() << std::endl;
    
    int a = 15, b = 25;
    std::cout << "Testing library functions:" << std::endl;
    std::cout << a << " + " << b << " = " << add_numbers(a, b) << std::endl;
    std::cout << a << " * " << b << " = " << multiply_numbers(a, b) << std::endl;
    
    return 0;
}