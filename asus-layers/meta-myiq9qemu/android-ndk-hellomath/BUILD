# Import Yocto-built static library
cc_import(
    name = "mathlib_static",
    static_library = "libs/static/libmathlib.a",
    hdrs = ["src/main/cpp/mathlib.h"],
)

# Import Yocto-built shared library
cc_import(
    name = "mathlib_dynamic",
    shared_library = "libs/dynamic/libmathlib.so",
    hdrs = ["src/main/cpp/mathlib.h"],
)

# Simple test binary with static linking
cc_binary(
    name = "test_static",
    srcs = ["src/main/cpp/simple_test.cpp"],
    deps = [":mathlib_static"],
)

# Simple test binary with dynamic linking
cc_binary(
    name = "test_dynamic",
    srcs = ["src/main/cpp/simple_test.cpp"],
    deps = [":mathlib_dynamic"],
)

# Console application with static linking
cc_binary(
    name = "hellomath_static",
    srcs = ["src/main/cpp/hellomath.cpp"],
    deps = [":mathlib_static"],
    linkstatic = True,
)

# Console application with dynamic linking
cc_binary(
    name = "hellomath_dynamic",
    srcs = ["src/main/cpp/hellomath.cpp"],
    deps = [":mathlib_dynamic"],
)