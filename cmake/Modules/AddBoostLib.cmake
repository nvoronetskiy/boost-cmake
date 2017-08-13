function(_add_boost_lib)
  set(options )
  set(oneValueArgs NAME)
  set(multiValueArgs SOURCES LINK DEFINE DEFINE_PRIVATE CXXFLAGS_PRIVATE INCLUDE_PRIVATE)
  cmake_parse_arguments(BOOSTLIB "${options}" "${oneValueArgs}"
                        "${multiValueArgs}" ${ARGN})
  add_library(Boost_${BOOSTLIB_NAME} STATIC ${BOOSTLIB_SOURCES})
  add_library(Boost::${BOOSTLIB_NAME} ALIAS Boost_${BOOSTLIB_NAME})
  set_target_properties(Boost_${BOOSTLIB_NAME} PROPERTIES
    OUTPUT_NAME "boost_${BOOSTLIB_NAME}"
    FOLDER "Boost"
  )

  IF(DEFINED INTERMEDIATE_ENV_DIR)
    set(RESULT_DIR ${INTERMEDIATE_ENV_DIR})
  ELSE()
    set(RESULT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../_obj-lib-etc/libs")
  ENDIF()

  set_target_properties(Boost_${BOOSTLIB_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${RESULT_DIR}")

  if(NOT BOOST_STANDALONE)
    #set_target_properties(Boost_${BOOSTLIB_NAME} PROPERTIES EXCLUDE_FROM_ALL 1)
  endif()
  target_link_libraries(Boost_${BOOSTLIB_NAME} PUBLIC Boost::boost)
  if(MSVC)
    target_compile_options(Boost_${BOOSTLIB_NAME} PRIVATE /W0)
  else()
    target_compile_options(Boost_${BOOSTLIB_NAME} PRIVATE -w)
  endif()
  if(BOOSTLIB_LINK)
    target_link_libraries(Boost_${BOOSTLIB_NAME} PUBLIC ${BOOSTLIB_LINK})
  endif()
  if(BOOSTLIB_DEFINE)
    target_compile_definitions(Boost_${BOOSTLIB_NAME} PUBLIC ${BOOSTLIB_DEFINE})
  endif()
  if(BOOSTLIB_DEFINE_PRIVATE)
    target_compile_definitions(Boost_${BOOSTLIB_NAME} PRIVATE ${BOOSTLIB_DEFINE_PRIVATE})
  endif()
  if(BOOSTLIB_CXXFLAGS_PRIVATE)
    target_compile_options(Boost_${BOOSTLIB_NAME} PRIVATE ${BOOSTLIB_CXXFLAGS_PRIVATE})
  endif()
  if(BOOSTLIB_INCLUDE_PRIVATE)
    target_include_directories(Boost_${BOOSTLIB_NAME} PRIVATE ${BOOSTLIB_INCLUDE_PRIVATE})
  endif()
endfunction()
