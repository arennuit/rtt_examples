cmake_minimum_required(VERSION 2.8.3)

project(hello-2-properties)

find_package(catkin REQUIRED COMPONENTS rtt_ros)

catkin_package(
  CATKIN_DEPENDS rtt_ros 
)

add_definitions(-DRTT_COMPONENT)
# Creates an orocos component HelloWorld
orocos_component(${PROJECT_NAME} HelloWorld.cpp) # ...you may add multiple source files
target_link_libraries(
	${PROJECT_NAME}
	${catkin_LIBRARIES}
	${OROCOS-RTT_RTT-MARSHALLING_LIBRARY} 
	${USE_OROCOS_LIBRARIES}
	)

# Makes this an installable/usable package for other packages.
orocos_generate_package()
