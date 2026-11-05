# Configure macOS compiler settings
function(platform_configure_compiler)
    set(_platform_compile_definitions ${PLATFORM_COMPILE_DEFINITIONS})
    set(_platform_compile_options     ${PLATFORM_COMPILE_OPTIONS})
    set(_platform_link_options        ${PLATFORM_LINK_OPTIONS})

    # Ignore duplicate libraries when linking with Apple Clang
    list(APPEND _platform_link_options -Wl,-no_warn_duplicate_libraries)

    set(PLATFORM_COMPILE_DEFINITIONS "${_platform_compile_definitions}" PARENT_SCOPE)
    set(PLATFORM_COMPILE_OPTIONS     "${_platform_compile_options}"     PARENT_SCOPE)
    set(PLATFORM_LINK_OPTIONS        "${_platform_link_options}"        PARENT_SCOPE)
endfunction()
