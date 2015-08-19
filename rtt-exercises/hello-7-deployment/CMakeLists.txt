cmake_minimum_required(VERSION 2.8.3)

project(hello-7-deployment)

find_package(catkin REQUIRED COMPONENTS rtt_ros)

catkin_package(
  CATKIN_DEPENDS rtt_ros 
)

add_definitions(-DRTT_COMPONENT)
# Creates a component library libHello-<target>.so and installs in the directory lib/orocos/hello-7-deployment/
orocos_component(hello Hello.cpp) # ...you may add multiple source files
target_link_libraries(hello ${catkin_LIBRARIES})

orocos_component(world World.cpp) # ...you may add multiple source files
target_link_libraries(world ${catkin_LIBRARIES})

# Makes this an installable/usable package for other packages.
orocos_generate_package()
