orocos_use_package(ocl-taskbrowser)
orocos_component(usecase-modeswitch ModeSwitch.cpp )
target_link_libraries(
	usecase-modeswitch
	${catkin_LIBRARIES}
	${OROCOS-RTT_RTT-SCRIPTING_LIBRARY} 
	${USE_OROCOS_LIBRARIES}
	)