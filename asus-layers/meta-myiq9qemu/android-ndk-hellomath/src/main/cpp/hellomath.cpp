#include <iostream>
#include <string>

// Include the Yocto-built mathlib header
extern "C" {
#include "mathlib.h"
}

int main() {
    std::cout << "=== Yocto MathLib Console Test ===" << std::endl;
    
    // Test the Yocto-built mathlib functions
    int a = 10, b = 5;
    int sum = add_numbers(a, b);
    int product = multiply_numbers(a, b);
    const char* version = get_library_version();
    
    std::cout << "Testing Yocto mathlib functions:" << std::endl;
    std::cout << a << " + " << b << " = " << sum << std::endl;
    std::cout << a << " * " << b << " = " << product << std::endl;
    std::cout << "Library version: " << version << std::endl;
    
    return 0;
}