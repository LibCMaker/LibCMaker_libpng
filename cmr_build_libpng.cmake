# ****************************************************************************
#  Project:  LibCMaker_libpng
#  Purpose:  A CMake build script for libpng library
#  Author:   NikitaFeodonit, nfeodonit@yandex.com
# ****************************************************************************
#    Copyright (c) 2017-2019 NikitaFeodonit
#
#    This file is part of the LibCMaker_libpng project.
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published
#    by the Free Software Foundation, either version 3 of the License,
#    or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program. If not, see <http://www.gnu.org/licenses/>.
# ****************************************************************************

#-----------------------------------------------------------------------
# The file is an example of the convenient script for the library build.
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Lib's name, version, paths
#-----------------------------------------------------------------------

set(LIBPNG_lib_NAME "libpng")
set(LIBPNG_lib_VERSION "1.6.37" CACHE STRING "LIBPNG_lib_VERSION")
set(LIBPNG_lib_DIR "${CMAKE_CURRENT_LIST_DIR}" CACHE PATH "LIBPNG_lib_DIR")

# To use our Find<LibName>.cmake.
list(APPEND CMAKE_MODULE_PATH "${LIBPNG_lib_DIR}/cmake/modules")


#-----------------------------------------------------------------------
# LibCMaker_<LibName> specific vars and options
#-----------------------------------------------------------------------

option(COPY_LIBPNG_CMAKE_BUILD_SCRIPTS "COPY_LIBPNG_CMAKE_BUILD_SCRIPTS" ON)


#-----------------------------------------------------------------------
# Library specific vars and options
#-----------------------------------------------------------------------

# Allow users to specify location of Zlib.
# Useful if zlib is being built alongside this as a sub-project.
option(PNG_BUILD_ZLIB "Custom zlib Location, else find_package is used" OFF)

# COMMAND LINE OPTIONS
if(BUILD_SHARED_LIBS)
  option(PNG_SHARED "Build shared lib" ON)
  option(PNG_STATIC "Build static lib" OFF)
else()
  option(PNG_SHARED "Build shared lib" OFF)
  option(PNG_STATIC "Build static lib" ON)
endif()
option(PNG_TESTS  "Build libpng tests" OFF)
option(PNG_TOOLS  "Build libpng tools" OFF)

# Many more configuration options could be added here
option(PNG_FRAMEWORK "Build OS X framework" OFF)
option(PNG_DEBUG "Build with debug output" OFF)
option(PNG_HARDWARE_OPTIMIZATIONS "Enable hardware optimizations" ON)

set(PNG_PREFIX "" CACHE STRING "Prefix to add to the API function names")
set(DFA_XTRA "" CACHE FILEPATH "File containing extra configuration settings")

if(PNG_HARDWARE_OPTIMIZATIONS)
  # set definitions and sources for arm
  if(CMAKE_SYSTEM_PROCESSOR MATCHES "^arm" OR
    CMAKE_SYSTEM_PROCESSOR MATCHES "^aarch64")
    set(PNG_ARM_NEON "check" CACHE STRING "Enable ARM NEON optimizations:
       check: (default) use internal checking code;
       off: disable the optimizations;
       on: turn on unconditionally.")
  endif()

  # set definitions and sources for powerpc
  if(CMAKE_SYSTEM_PROCESSOR MATCHES "^powerpc*" OR
     CMAKE_SYSTEM_PROCESSOR MATCHES "^ppc64*")
    set(PNG_POWERPC_VSX "on" CACHE STRING "Enable POWERPC VSX optimizations:
       off: disable the optimizations.")
  endif()

  # set definitions and sources for intel
  if(CMAKE_SYSTEM_PROCESSOR MATCHES "^i?86" OR
     CMAKE_SYSTEM_PROCESSOR MATCHES "^x86_64*")
    set(PNG_INTEL_SSE "on" CACHE STRING "Enable INTEL_SSE optimizations:
       off: disable the optimizations")
  endif()

  # set definitions and sources for MIPS
  if(CMAKE_SYSTEM_PROCESSOR MATCHES "mipsel*" OR
     CMAKE_SYSTEM_PROCESSOR MATCHES "mips64el*")
    set(PNG_MIPS_MSA "on" CACHE STRING "Enable MIPS_MSA optimizations:
       off: disable the optimizations")
  endif()
endif(PNG_HARDWARE_OPTIMIZATIONS)

option(ld-version-script "Enable linker version script" ON)

option(SKIP_INSTALL_ALL "SKIP_INSTALL_ALL" OFF)
option(SKIP_INSTALL_HEADERS "SKIP_INSTALL_HEADERS" OFF)
option(SKIP_INSTALL_FILES "SKIP_INSTALL_FILES" OFF)
option(SKIP_INSTALL_EXECUTABLES "SKIP_INSTALL_EXECUTABLES" OFF)
option(SKIP_INSTALL_PROGRAMS "SKIP_INSTALL_PROGRAMS" OFF)
option(SKIP_INSTALL_EXPORT "SKIP_INSTALL_EXPORT" OFF)


#-----------------------------------------------------------------------
# Build, install and find the library
#-----------------------------------------------------------------------

# Used in 'cmr_build_rules_libpng.cmake'.
set(LIBCMAKER_ZLIB_SRC_DIR ${ZLIB_lib_DIR} CACHE PATH "LIBCMAKER_ZLIB_SRC_DIR")

cmr_find_package(
  LibCMaker_DIR   ${LibCMaker_DIR}
  NAME            ${LIBPNG_lib_NAME}
  VERSION         ${LIBPNG_lib_VERSION}
  LIB_DIR         ${LIBPNG_lib_DIR}
  REQUIRED
  FIND_MODULE_NAME PNG
)
