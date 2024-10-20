cmake_minimum_required(VERSION 3.15)
project(bazel-like-cmake)

include(CC.cmake)

enable_testing()

cc_test(
    NAME gtest_test
    SOURCES gtest_test.cc
    DEPENDENCIES gtest gtest_main
)

cc_test(
    NAME boost_test
    SOURCES boost_test.cc
    DEPENDENCIES Boost::system,unit_test_framework
)
