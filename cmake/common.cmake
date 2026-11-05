# Compiler features

# Choose C++ standard
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_EXTENSIONS ON)

# Configure Clang compiler options
if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

  # Clang C++ compiler should use libc++
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")

endif()
