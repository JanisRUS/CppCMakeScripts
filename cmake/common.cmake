# Compiler features

# Choose C++ standard
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_EXTENSIONS ON)

# Configure Clang compiler options
if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

  # Clang C++ compiler should use libc++
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")

endif()

# Configure Unix compiler options
if(UNIX)
  # Configure build in pthread library
  set(CMAKE_THREAD_LIBS_INIT "-lpthread")
  set(CMAKE_HAVE_THREADS_LIBRARY 1)
  set(CMAKE_USE_WIN32_THREADS_INIT 0)
  set(CMAKE_USE_PTHREADS_INIT 1)
  set(THREADS_PREFER_PTHREAD_FLAG ON)
endif()

# Compiler warnings

# Store origin compile flags
set(CMAKE_C_FLAGS_ORIGIN ${CMAKE_C_FLAGS})
set(CMAKE_CXX_FLAGS_ORIGIN ${CMAKE_CXX_FLAGS})

# Create custom compile flags
set(CMAKE_C_FLAGS_CUSTOM ${CMAKE_C_FLAGS})
set(CMAKE_CXX_FLAGS_CUSTOM ${CMAKE_CXX_FLAGS})

if(NOT MSVC)

  # Make all warnings into errors
  set(CMAKE_C_FLAGS_CUSTOM "${CMAKE_C_FLAGS_CUSTOM} -Wall -Werror")
  set(CMAKE_CXX_FLAGS_CUSTOM "${CMAKE_CXX_FLAGS_CUSTOM} -Wall -Werror")

  # Common compile flags
  if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(COMMON_COMPILE_FLAGS "-Wno-maybe-uninitialized -Wno-overflow -Wno-restrict -Wno-stringop-overflow")
  else()
    set(COMMON_COMPILE_FLAGS "")
  endif()

  # Pedantic compile flags
  set(PEDANTIC_COMPILE_FLAGS "${COMMON_COMPILE_FLAGS} -Wshadow -pedantic")

  # Update compile flags
  set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS_CUSTOM})
  set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS_CUSTOM})

endif()
