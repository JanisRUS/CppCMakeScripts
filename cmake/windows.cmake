# Check for MSYS2 building environment
get_filename_component(CMAKE_MAKE_NAME ${CMAKE_MAKE_PROGRAM} NAME_WE)
if (MINGW AND CMAKE_MAKE_NAME STREQUAL "make")
  set(MSYS 1)
endif()

# Configure MSYS2/MinGW-w64 compiler options
if(MINGW OR MSYS)

  # MinGW-w64 increases the number of sections that an object file can contain
  add_compile_options(-Wa,-mbig-obj)

  # MinGW-w64 use static link std library
  add_link_options(-static-libgcc -static-libstdc++)

endif()

# Configure Visual Studio compiler options
if(MSVC)

  # Increase the number of sections that an object file can contain
  add_compile_options(/bigobj)

  # Specifies both the source character set and the execution character set as UTF-8
  # https://docs.microsoft.com/en-us/cpp/build/reference/utf-8-set-source-and-executable-character-sets-to-utf-8
  add_compile_options(/utf-8)

  # Visual Studio should correctly reports __cplusplus
  # https://devblogs.microsoft.com/cppblog/msvc-now-correctly-reports-__cplusplus
  add_compile_options(/Zc:__cplusplus)

  # Compiler warnings

  # Set warnings level 4
  set(CMAKE_C_WARNING_LEVEL 4)
  set(CMAKE_CXX_WARNING_LEVEL 4)
  if(CMAKE_C_FLAGS_CUSTOM MATCHES "/W[0-4]")
    string(REGEX REPLACE "/W[0-4]" "/W4" CMAKE_C_FLAGS_CUSTOM ${CMAKE_C_FLAGS_CUSTOM})
  else()
    set(CMAKE_C_FLAGS_CUSTOM "${CMAKE_C_FLAGS_CUSTOM} /W4")
  endif()
  if(CMAKE_CXX_FLAGS_CUSTOM MATCHES "/W[0-4]")
    string(REGEX REPLACE "/W[0-4]" "/W4" CMAKE_CXX_FLAGS_CUSTOM ${CMAKE_CXX_FLAGS_CUSTOM})
  else()
    set(CMAKE_CXX_FLAGS_CUSTOM "${CMAKE_CXX_FLAGS_CUSTOM} /W4")
  endif()

  # Make all warnings into errors
  set(CMAKE_C_FLAGS_CUSTOM "${CMAKE_C_FLAGS_CUSTOM} /WX")
  set(CMAKE_CXX_FLAGS_CUSTOM "${CMAKE_CXX_FLAGS_CUSTOM} /WX")

  # Common compile flags
  # C4100: 'identifier' : unreferenced formal parameter
  # C4250: 'class1' : inherits 'class2::member' via dominance
  set(COMMON_COMPILE_FLAGS "/wd4100 /wd4250")

  # Pedantic compile flags
  set(PEDANTIC_COMPILE_FLAGS ${COMMON_COMPILE_FLAGS})

  # Update compile flags
  set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS_CUSTOM})
  set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS_CUSTOM})

endif()

# Platform features

if(CYGWIN)

  # Base Windows platform
  add_definitions(-DWIN32 -DWIN32_LEAN_AND_MEAN)

  # Windows 10
  add_definitions(-D_WIN32_WINNT=0x0A00)

elseif(WIN32)

  # Base Windows platform
  add_definitions(-DWIN32 -DWIN32_LEAN_AND_MEAN)

  # Disable CRT secure warnings
  add_definitions(-D_CRT_SECURE_NO_DEPRECATE)

  # Disable C++17 deprecation warnings
  add_definitions(-D_SILENCE_ALL_CXX17_DEPRECATION_WARNINGS)

  # Windows 10
  add_definitions(-D_WIN32_WINNT=0x0A00)

  # Windows SDK
  if(CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION AND NOT MINGW)
    string(REGEX REPLACE "^([0-9]+)\\.([0-9]+)\\.([0-9]+)\\.([0-9]+)$" "\\3" CMAKE_WIN32_SDK ${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION})
  else()
    string(REGEX REPLACE "^([0-9]+)\\.([0-9]+)\\.([0-9]+)$" "\\3" CMAKE_WIN32_SDK ${CMAKE_SYSTEM_VERSION})
  endif()
  add_definitions(-D_WIN32_SDK=${CMAKE_WIN32_SDK})

endif()
