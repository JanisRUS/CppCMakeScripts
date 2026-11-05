# Configure Apple compiler options
if(APPLE)

  # Apple liker should ignore duplicate libraries
  add_link_options(-Wl,-no_warn_duplicate_libraries)

endif()
