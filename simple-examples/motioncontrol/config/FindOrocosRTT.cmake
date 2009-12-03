# Lookup the Orocos::RTT compile and link flags and uses 
# LINK_DIRECTORIES, INCLUDE_DIRECTORIES and ADD_DEFINITIONS to export them.
# It depends on FindPkgConfig.cmake.

#This module requires OROCOS_INSTALL to be set in order to know
# where it can/should be found.

# Sets the following variables (example: target = lxrt)
#
# For rtt <= 1.2:
# OS_LXRT (defined)
# OROCOS_RTT OROCOS_RTT_INCLUDE_DIRS OROCOS_RTT_DEFINES OROCOS_RTT_LINK_DIRS  OROCOS_RTT_LIBS
#
# For rtt >= 1.4:
# OS_LXRT (defined)
# FLAVOR  = orocos-rtt-lxrt
# FLAVOR_TARGET = lxrt
# FLAVOR_TARGET_CAP = LXRT
# OROCOS_RTT OROCOS_RTT_INCLUDE_DIRS OROCOS_RTT_DEFINES OROCOS_RTT_LINK_DIRS  OROCOS_RTT_LIBS
#
# Check OROCOS_RTT_X.Y for the API version ('X.Y' = 1.2 or 1.4)
# For example, if OROCOS_RTT_1.4 is defined, then OROCOS_RTT_1.2 and OROCOS_RTT will also be defined.

INCLUDE (${PROJ_SOURCE_DIR}/config/FindPkgConfig.cmake)

IF ( CMAKE_PKGCONFIG_EXECUTABLE AND NOT SKIP_BUILD)

    MESSAGE( STATUS "Detecting RTT" )
    SET(OROCOS_TARGET "gnulinux" CACHE STRING "")
    SET(ENV{PKG_CONFIG_PATH} "${OROCOS_INSTALL}/lib/pkgconfig:${OROCOS_INSTALL}/packages/install/lib/pkgconfig/")
    #MESSAGE( "Setting environment of PKG_CONFIG_PATH to: $ENV{PKG_CONFIG_PATH}")
    MESSAGE( "Searching RTT in ${OROCOS_INSTALL}:" )

    FILE(GLOB OROCOS_RTT_FLAVORS RELATIVE "${OROCOS_INSTALL}/lib/pkgconfig/" "${OROCOS_INSTALL}/lib/pkgconfig/orocos-rtt-*.pc" )
    IF ( OROCOS_RTT_FLAVORS ) 
      # OROCOS 1.4 and later
      MESSAGE( "Found flavors: ${OROCOS_RTT_FLAVORS} ")
      FOREACH(FLAVOR ${OROCOS_RTT_FLAVORS})
       STRING(REGEX REPLACE ".pc" "" FLAVOR ${FLAVOR})
       STRING(REGEX REPLACE "orocos-rtt-" "" FLAVOR_TARGET ${FLAVOR})
       STRING(TOUPPER ${FLAVOR_TARGET} FLAVOR_TARGET_CAP)
       PKGCONFIG("${FLAVOR} >= 1.3.0" OROCOS_RTT_${FLAVOR_TARGET_CAP}_1.4 OROCOS_RTT_${FLAVOR_TARGET_CAP}_INCLUDE_DIRS_1.4 OROCOS_RTT_${FLAVOR_TARGET_CAP}_DEFINES_1.4 OROCOS_RTT_${FLAVOR_TARGET_CAP}_LINK_DIRS_1.4 OROCOS_RTT_${FLAVOR_TARGET_CAP}_LIBS_1.4 )

       IF ( OROCOS_TARGET STREQUAL "${FLAVOR_TARGET}")
       MESSAGE(" Using: ${FLAVOR_TARGET} . Set OROCOS_TARGET variable to another one to change the compile target.")
	 # also enable 1.2/1.4 plain.
	 SET(OROCOS_RTT_1.4 OROCOS_RTT_${FLAVOR_TARGET_CAP}_1.4)
	 SET(OROCOS_RTT_1.2 OROCOS_RTT_${FLAVOR_TARGET_CAP}_1.4)
	 # set paths
	 PKGCONFIG( "orocos-rtt-${FLAVOR_TARGET} >= 1.0.0" OROCOS_RTT OROCOS_RTT_INCLUDE_DIRS OROCOS_RTT_DEFINES OROCOS_RTT_LINK_DIRS OROCOS_RTT_LIBS )
        MESSAGE("   Includes in: ${OROCOS_RTT_INCLUDE_DIRS}")
        MESSAGE("   Libraries in: ${OROCOS_RTT_LINK_DIRS}")
        MESSAGE("   Libraries: ${OROCOS_RTT_LIBS}")
        MESSAGE("   Defines: ${OROCOS_RTT_DEFINES}")

	INCLUDE_DIRECTORIES( ${OROCOS_RTT_INCLUDE_DIRS} )
        LINK_DIRECTORIES( ${OROCOS_RTT_LINK_DIRS} )
	ADD_DEFINITIONS( ${OROCOS_RTT_DEFINES} )

	SET(OS_${FLAVOR_TARGET_CAP} 1)

	FIND_FILE( CORBA_ENABLED rtt/corba/ControlTaskProxy.hpp ${OROCOS_RTT_INCLUDE_DIRS} )
	IF (CORBA_ENABLED)
	  MESSAGE( "Detected CORBA build of RTT: ${CORBA_ENABLED}" )
	ELSE(CORBA_ENABLED)
	  MESSAGE( "CORBA not detected." )
	ENDIF (CORBA_ENABLED)

       ENDIF ( OROCOS_TARGET STREQUAL "${FLAVOR_TARGET}")
      ENDFOREACH(FLAVOR ${OROCOS_RTT_FLAVORS})

      IF( NOT OROCOS_RTT )
	MESSAGE(FATAL_ERROR "Please set OROCOS_TARGET variable (now: ${OROCOS_TARGET}) to one of the detected targets above.")
      ENDIF( NOT OROCOS_RTT )

    ELSE ( OROCOS_RTT_FLAVORS ) 

      # if OROCOS_RTT_1.2, enable SHARED libraries (see component_rules).
      PKGCONFIG( "orocos-rtt >= 1.1.0" OROCOS_RTT_1.2 OROCOS_RTT_INCLUDE_DIRS_1.2 OROCOS_RTT_DEFINES_1.2 OROCOS_RTT_LINK_DIRS_1.2 OROCOS_RTT_LIBS_1.2 )
      PKGCONFIG( "orocos-rtt >= 1.0.0" OROCOS_RTT OROCOS_RTT_INCLUDE_DIRS OROCOS_RTT_DEFINES OROCOS_RTT_LINK_DIRS OROCOS_RTT_LIBS )

      # 1.2 and older
      IF( OROCOS_RTT )
        MESSAGE("   Includes in: ${OROCOS_RTT_INCLUDE_DIRS}")
        MESSAGE("   Libraries in: ${OROCOS_RTT_LINK_DIRS}")
        MESSAGE("   Libraries: ${OROCOS_RTT_LIBS}")
        MESSAGE("   Defines: ${OROCOS_RTT_DEFINES}")

	INCLUDE_DIRECTORIES( ${OROCOS_RTT_INCLUDE_DIRS} )
        LINK_DIRECTORIES( ${OROCOS_RTT_LINK_DIRS} )
	ADD_DEFINITIONS( ${OROCOS_RTT_DEFINES} )

	# Detect OS:
	# FIND_XXX has a special treatment if the variable's value is XXX-NOTFOUND
	# This 'value' will trigger a new search in the next cmake run.
	SET(OS_GNULINUX OS_GNULINUX-NOTFOUND)
	SET(OS_XENOMAI OS_XENOMAI-NOTFOUND)
	SET(OS_LXRT OS_LXRT-NOTFOUND)
	#SET( OS_GNULINUX 1 CACHE INTERNAL "")
	#CHECK_INCLUDE_FILE( rtt/os/gnulinux.h OS_GNULINUX ${OROCOS_RTT_INCLUDE_DIRS})
	FIND_FILE( OS_GNULINUX rtt/os/gnulinux.h ${OROCOS_RTT_INCLUDE_DIRS})
	FIND_FILE( OS_GNULINUX rtt/os/gnulinux/fosi.h ${OROCOS_RTT_INCLUDE_DIRS})
        IF(OS_GNULINUX )
          MESSAGE( "Detected GNU/Linux installation: ${OS_GNULINUX}" )
        ENDIF(OS_GNULINUX)

        SET( CMAKE_REQUIRED_INCLUDES ${OROCOS_RTT_INCLUDE_DIRS})
	FIND_FILE( OS_XENOMAI rtt/os/xenomai.h ${OROCOS_RTT_INCLUDE_DIRS})
	FIND_FILE( OS_XENOMAI rtt/os/xenomai/fosi.h ${OROCOS_RTT_INCLUDE_DIRS})
        IF(OS_XENOMAI)
          MESSAGE( "Detected Xenomai installation: ${OS_XENOMAI}" )
	ENDIF(OS_XENOMAI)

	SET( CMAKE_REQUIRED_INCLUDES ${OROCOS_RTT_INCLUDE_DIRS})
 	FIND_FILE( OS_LXRT rtt/os/lxrt.h ${OROCOS_RTT_INCLUDE_DIRS})
 	FIND_FILE( OS_LXRT rtt/os/lxrt/fosi.h ${OROCOS_RTT_INCLUDE_DIRS})
        IF(OS_LXRT)
          MESSAGE( "Detected LXRT installation: ${OS_LXRT}" )
        ENDIF(OS_LXRT)

	IF ( NOT OS_LXRT AND NOT OS_GNULINUX AND NOT OS_XENOMAI )
	  MESSAGE( FATAL_ERROR "Could not detect target OS!" )
	ENDIF ( NOT OS_LXRT AND NOT OS_GNULINUX AND NOT OS_XENOMAI )

	FIND_FILE( CORBA_ENABLED rtt/corba/ControlTaskProxy.hpp ${OROCOS_RTT_INCLUDE_DIRS} )
	IF (CORBA_ENABLED)
	  MESSAGE( "Detected CORBA build of RTT: ${CORBA_ENABLED}" )
	  # Work around RTT 1.2.0 bug when rtt/corba libs are not in ldconfig/standard paths.
	  #SET(OROCOS_RTT_LIBS "${OROCOS_RTT_LIBS} -lorocos-rtt-corba")
	ELSE(CORBA_ENABLED)
	  MESSAGE( "CORBA not detected." )
	ENDIF (CORBA_ENABLED)

      ELSE  ( OROCOS_RTT )
        MESSAGE( FATAL_ERROR "Can't find Orocos Real-Time Toolkit (orocos-rtt.pc)")
      ENDIF ( OROCOS_RTT )
    ENDIF ( OROCOS_RTT_FLAVORS ) 

ELSE  ( CMAKE_PKGCONFIG_EXECUTABLE  AND NOT SKIP_BUILD)

    IF (NOT CMAKE_PKGCONFIG_EXECUTABLE)
    # Can't find pkg-config -- have to search manually
    MESSAGE( FATAL_ERROR "Can't find pkg-config ")
    ENDIF (NOT CMAKE_PKGCONFIG_EXECUTABLE)

ENDIF ( CMAKE_PKGCONFIG_EXECUTABLE  AND NOT SKIP_BUILD)
