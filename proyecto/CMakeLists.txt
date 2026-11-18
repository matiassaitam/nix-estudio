cmake_minimum_required(VERSION 3.16)
project(nix_estudio VERSION 1.0.0 LANGUAGES C)

find_package(ZLIB REQUIRED)
add_executable(nix-estudio main.c)
target_compile_features(nix-estudio PRIVATE c_std_99)
target_link_libraries(nix-estudio PRIVATE ZLIB::ZLIB)
if(CMAKE_C_COMPILER_ID MATCHES "GNU|Clang")
  target_compile_options(nix-estudio PRIVATE -Wall -Wextra -Wpedantic)
endif()

install(TARGETS nix-estudio RUNTIME DESTINATION bin)

enable_testing()
add_test(NAME genera_html COMMAND nix-estudio)
set_tests_properties(genera_html PROPERTIES
  PASS_REGULAR_EXPRESSION "<!doctype html>")
add_test(NAME muestra_version COMMAND nix-estudio --version)
set_tests_properties(muestra_version PROPERTIES
  PASS_REGULAR_EXPRESSION "nix-estudio 1\\.0\\.0")
