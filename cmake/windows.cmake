# Configure Windows compiler settings
function(platform_configure_compiler)
    set(_platform_compile_definitions ${PLATFORM_COMPILE_DEFINITIONS})
    set(_platform_compile_options     ${PLATFORM_COMPILE_OPTIONS})
    set(_platform_link_options        ${PLATFORM_LINK_OPTIONS})

    # Configure MinGW-w64 compiler options
    if(MINGW)
        # Increase the number of sections that an object file can contain
        list(APPEND _platform_compile_options -Wa,-mbig-obj)

        # Link the GCC and C++ standard libraries statically
        list(APPEND _platform_link_options -static-libgcc -static-libstdc++)
    endif()

    # Configure Visual Studio compiler options
    if(MSVC)
        # Increase the number of sections that an object file can contain
        list(APPEND _platform_compile_options /bigobj)

        # Use UTF-8 for source and execution character sets
        list(APPEND _platform_compile_options /utf-8)

        # Report the correct value of __cplusplus
        list(APPEND _platform_compile_options /Zc:__cplusplus)

        # Configure compiler warnings
        list(APPEND _platform_compile_options /W4 /WX /wd4100 /wd4250)
    endif()

    # Configure Windows platform definitions
    if(CYGWIN)
        list(APPEND _platform_compile_definitions
            WIN32
            WIN32_LEAN_AND_MEAN
            _WIN32_WINNT=0x0A00
        )
    elseif(WIN32)
        list(APPEND _platform_compile_definitions
            WIN32
            WIN32_LEAN_AND_MEAN
            _CRT_SECURE_NO_DEPRECATE
            _SILENCE_ALL_CXX17_DEPRECATION_WARNINGS
            _WIN32_WINNT=0x0A00
        )

        # Determine the Windows SDK version
        if(CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION AND NOT MINGW)
            string(REGEX REPLACE
                "^([0-9]+)\\.([0-9]+)\\.([0-9]+)\\.([0-9]+)$"
                "\\3"
                _windows_sdk_version
                "${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION}"
            )
        else()
            string(REGEX REPLACE
                "^([0-9]+)\\.([0-9]+)\\.([0-9]+)$"
                "\\3"
                _windows_sdk_version
                "${CMAKE_SYSTEM_VERSION}"
            )
        endif()

        if(_windows_sdk_version)
            list(APPEND _platform_compile_definitions
                _WIN32_SDK=${_windows_sdk_version}
            )
        endif()
    endif()

    set(PLATFORM_COMPILE_DEFINITIONS "${_platform_compile_definitions}" PARENT_SCOPE)
    set(PLATFORM_COMPILE_OPTIONS     "${_platform_compile_options}"     PARENT_SCOPE)
    set(PLATFORM_LINK_OPTIONS        "${_platform_link_options}"        PARENT_SCOPE)
endfunction()
