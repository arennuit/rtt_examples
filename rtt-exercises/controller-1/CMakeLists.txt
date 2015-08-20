cmake_minimum_required(VERSION 2.8.3)

project(controller-1)

find_package(catkin REQUIRED COMPONENTS rtt_ros)

catkin_package(
  CATKIN_DEPENDS rtt_ros 
)

add_definitions(-DRTT_COMPONENT)

add_subdirectory( components )

# Makes this an installable/usable package for other packages.
orocos_generate_package()