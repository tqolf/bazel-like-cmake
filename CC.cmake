cmake_minimum_required(VERSION 3.15 FATAL_ERROR)

# CSI escape sequences
if(NOT WIN32)
  # cmake-format: off
  string(ASCII 27 Esc)
  set(CSI_Reset       "${Esc}[m")
  set(CSI_Bold        "${Esc}[1m")
  set(CSI_Red         "${Esc}[31m")
  set(CSI_Green       "${Esc}[32m")
  set(CSI_Yellow      "${Esc}[33m")
  set(CSI_Blue        "${Esc}[34m")
  set(CSI_Magenta     "${Esc}[35m")
  set(CSI_Cyan        "${Esc}[36m")
  set(CSI_White       "${Esc}[37m")
  set(CSI_BoldRed     "${Esc}[1;31m")
  set(CSI_BoldGreen   "${Esc}[1;32m")
  set(CSI_BoldYellow  "${Esc}[1;33m")
  set(CSI_BoldBlue    "${Esc}[1;34m")
  set(CSI_BoldMagenta "${Esc}[1;35m")
  set(CSI_BoldCyan    "${Esc}[1;36m")
  set(CSI_BoldWhite   "${Esc}[1;37m")
  # cmake-format: on

  # Replaces ANSI CSI sequences in a string or list with placeholders.
  # This avoids issues when processing text with CSI sequences, such as
  # when iterating over lists in CMake.
  macro(csi_replace text)
    string(REPLACE "${CSI_Reset}" "_CSI_Reset_" ${text} "${${text}}")
    string(REPLACE "${CSI_Bold}" "_CSI_Bold_" ${text} "${${text}}")
    string(REPLACE "${CSI_Red}" "_CSI_Red_" ${text} "${${text}}")
    string(REPLACE "${CSI_Green}" "_CSI_Green_" ${text} "${${text}}")
    string(REPLACE "${CSI_Yellow}" "_CSI_Yellow_" ${text} "${${text}}")
    string(REPLACE "${CSI_Blue}" "_CSI_Blue_" ${text} "${${text}}")
    string(REPLACE "${CSI_Magenta}" "_CSI_Magenta_" ${text} "${${text}}")
    string(REPLACE "${CSI_Cyan}" "_CSI_Cyan_" ${text} "${${text}}")
    string(REPLACE "${CSI_White}" "_CSI_White_" ${text} "${${text}}")
    string(REPLACE "${CSI_BoldRed}" "_CSI_BoldRed_" ${text} "${${text}}")
    string(REPLACE "${CSI_BoldGreen}" "_CSI_BoldGreen_" ${text} "${${text}}")
    string(REPLACE "${CSI_BoldYellow}" "_CSI_BoldYellow_" ${text} "${${text}}")
    string(REPLACE "${CSI_BoldBlue}" "_CSI_BoldBlue_" ${text} "${${text}}")
    string(REPLACE "${CSI_BoldMagenta}" "_CSI_BoldMagenta_" ${text} "${${text}}")
    string(REPLACE "${CSI_BoldCyan}" "_CSI_BoldCyan_" ${text} "${${text}}")
    string(REPLACE "${CSI_BoldWhite}" "_CSI_BoldWhite_" ${text} "${${text}}")
  endmacro()

  # Restores ANSI CSI sequences from placeholders in a string or list.
  # Reverses the changes made by csi_replace.
  macro(csi_restore text)
    string(REPLACE "_CSI_Reset_" "${CSI_Reset}" ${text} "${${text}}")
    string(REPLACE "_CSI_Bold_" "${CSI_Bold}" ${text} "${${text}}")
    string(REPLACE "_CSI_Red_" "${CSI_Red}" ${text} "${${text}}")
    string(REPLACE "_CSI_Green_" "${CSI_Green}" ${text} "${${text}}")
    string(REPLACE "_CSI_Yellow_" "${CSI_Yellow}" ${text} "${${text}}")
    string(REPLACE "_CSI_Blue_" "${CSI_Blue}" ${text} "${${text}}")
    string(REPLACE "_CSI_Magenta_" "${CSI_Magenta}" ${text} "${${text}}")
    string(REPLACE "_CSI_Cyan_" "${CSI_Cyan}" ${text} "${${text}}")
    string(REPLACE "_CSI_White_" "${CSI_White}" ${text} "${${text}}")
    string(REPLACE "_CSI_BoldRed_" "${CSI_BoldRed}" ${text} "${${text}}")
    string(REPLACE "_CSI_BoldGreen_" "${CSI_BoldGreen}" ${text} "${${text}}")
    string(REPLACE "_CSI_BoldYellow_" "${CSI_BoldYellow}" ${text} "${${text}}")
    string(REPLACE "_CSI_BoldBlue_" "${CSI_BoldBlue}" ${text} "${${text}}")
    string(REPLACE "_CSI_BoldMagenta_" "${CSI_BoldMagenta}" ${text} "${${text}}")
    string(REPLACE "_CSI_BoldCyan_" "${CSI_BoldCyan}" ${text} "${${text}}")
    string(REPLACE "_CSI_BoldWhite_" "${CSI_BoldWhite}" ${text} "${${text}}")
  endmacro()
endif()

# cmake-format: off
macro(cc_set_policies)
  # the policy allows us to change options without caching
  cmake_policy(SET CMP0077 NEW)
  set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)

  # the policy allows us to change set(CACHE) without caching
  if(POLICY CMP0126)
    cmake_policy(SET CMP0126 NEW)
    set(CMAKE_POLICY_DEFAULT_CMP0126 NEW)
  endif()

  # the policy uses the download time for timestamp, instead of the timestamp in the archive. This allows for proper
  # rebuilds when a projects url changes
  if(POLICY CMP0135)
    cmake_policy(SET CMP0135 NEW)
    set(CMAKE_POLICY_DEFAULT_CMP0135 NEW)
  endif()

  # treat relative git repository paths as being relative to the parent project's remote
  if(POLICY CMP0150)
    cmake_policy(SET CMP0150 NEW)
    set(CMAKE_POLICY_DEFAULT_CMP0150 NEW)
  endif()

  # the policy convert relative paths to absolute according to above rules
  cmake_policy(SET CMP0076 NEW)
  set(CMAKE_POLICY_DEFAULT_CMP0076 NEW)

  # the policy does not dereference variables or interpret keywords that have been quoted or bracketed.
  cmake_policy(SET CMP0054 NEW)
  set(CMAKE_POLICY_DEFAULT_CMP0054 NEW)

  # keep relying on CMake FindBoost module instead of the one shipping with Boost itself.
  # Required by our "hack" to support a mix of shared and static boost components.
  if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.30.0)
    cmake_policy(SET CMP0167 OLD)
    set(CMAKE_POLICY_DEFAULT_CMP0167 OLD)
  endif()

  if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.28.0)
    cmake_policy(SET CMP0169 OLD)
    set(CMAKE_POLICY_DEFAULT_CMP0169 OLD)
  endif()

  # no up-to-date messages on installation
  if(NOT DEFINED CMAKE_INSTALL_MESSAGE)
    set(CMAKE_INSTALL_MESSAGE "LAZY")
  endif()

  set(CMAKE_WARN_DEPRECATED OFF CACHE BOOL "Disable deprecated warnings" FORCE)
endmacro()
cc_set_policies()

if(NOT CC_MESSAGE_MAX_LENGTH)
  set(CC_MESSAGE_MAX_LENGTH 360 CACHE INTERNAL "Max length of one line message")
endif()

if(NOT DEFINED CC_IMPORTED_PACKAGES)
  set(CC_IMPORTED_PACKAGES "" CACHE INTERNAL "All imported packages")
endif()

if(NOT DEFINED CC_IMPORT_LINK_DIRECTORIES)
  set(CC_IMPORT_LINK_DIRECTORIES "" CACHE INTERNAL "All link directories of imported packages")
endif()

if(NOT DEFINED CC_IMPORT_INCLUDE_DIRECTORIES)
  set(CC_IMPORT_INCLUDE_DIRECTORIES "" CACHE INTERNAL "All include directories of imported packages")
endif()

if(DEFINED ENV{CC_SOURCE_CACHE})
  set(CC_SOURCE_CACHE_DEFAULT $ENV{CC_SOURCE_CACHE})
else()
  set(CC_SOURCE_CACHE_DEFAULT ${CMAKE_BINARY_DIR}/_deps)
endif()
set(CC_SOURCE_CACHE ${CC_SOURCE_CACHE_DEFAULT} CACHE PATH "Directory to download CC dependencies")

# Namespace
macro(cc_get_parent_namespace variable)
  get_directory_property(__PARENT_DIR__ PARENT_DIRECTORY)
  get_property(${variable} DIRECTORY ${__PARENT_DIR__} PROPERTY __CURRENT_NAMESPACE__)
  if(${variable} STREQUAL "")
    message(FATAL_ERROR "Can not get namespace for ${CMAKE_CURRENT_SOURCE_DIR}")
  endif()
endmacro()

macro(cc_get_current_namespace variable)
  get_property(${variable} DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" PROPERTY __CURRENT_NAMESPACE__)
endmacro()

function(cc_set_namespace)
  cmake_parse_arguments(CC_ARGS "ROOT" "" "" ${ARGV})

  # Get the unparsed arguments as the namespace name
  set(namespace "${CC_ARGS_UNPARSED_ARGUMENTS}")

  if(CC_ARGS_ROOT)
    # If 'ROOT' option is used, ensure a namespace is provided
    if(NOT namespace)
      message(FATAL_ERROR "${CSI_BoldRed}When using the ROOT option, you must provide a root namespace.${CSI_Reset}")
    endif()
    # Set the root namespace for the current directory
    set_property(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" PROPERTY __CURRENT_NAMESPACE__ "${namespace}")
  else()
    cc_get_parent_namespace(__PARENT_NAMESPACE__)

    if(namespace)
      # Use the provided namespace
      set(current_namespace "${namespace}")
    else()
      # If no namespace is provided, use the current directory name
      get_filename_component(current_namespace "${CMAKE_CURRENT_SOURCE_DIR}" NAME)
    endif()

    if(__PARENT_NAMESPACE__)
      # Combine the parent namespace and current namespace
      set(full_namespace "${__PARENT_NAMESPACE__}::${current_namespace}")
    else()
      # Use the current namespace as the full namespace
      set(full_namespace "${current_namespace}")
    endif()

    # Set the namespace property for the current directory
    set_property(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" PROPERTY __CURRENT_NAMESPACE__ "${full_namespace}")
  endif()
endfunction()

# logs
function(prompt_once type message_text)
  get_property(existing_messages GLOBAL PROPERTY PROMPTED_MESSAGES)
  string(FIND ";${existing_messages};" ";${type}:${message_text};" index)
  if(index EQUAL -1)
    message(${type} "${message_text}")
    set_property(GLOBAL APPEND PROPERTY PROMPTED_MESSAGES "${type}:${message_text}")
  endif()
endfunction()

function(cc_truncate_list OUTPUT REMOVE_SOURCE_PREFIX)
  set(items ${ARGN})
  if(REMOVE_SOURCE_PREFIX)
    set(processed_items)
    foreach(item IN LISTS items)
      string(REGEX REPLACE "^${CMAKE_SOURCE_DIR}/?" "" item "${item}")
      list(APPEND processed_items "${item}")
    endforeach()
    set(items "${processed_items}")
  endif()

  set(final_items)
  set(current_length 0)
  foreach(elem IN LISTS items)
    string(LENGTH ${elem} len)
    if(final_items STREQUAL "")
      math(EXPR new_length "${current_length} + ${len}")
    else()
      math(EXPR new_length "${current_length} + ${len} + 1")
    endif()

    # message(STATUS "[DEBUG] new_length='${new_length}' CC_MESSAGE_MAX_LENGTH='${CC_MESSAGE_MAX_LENGTH}'")

    if(DEFINED CC_MESSAGE_MAX_LENGTH AND new_length GREATER CC_MESSAGE_MAX_LENGTH)
      list(APPEND final_items "...")
      break()
    else()
      list(APPEND final_items "${elem}")
      set(current_length "${new_length}")
    endif()
  endforeach()

  set(${OUTPUT} ${final_items} PARENT_SCOPE)
endfunction()

function(cc_log_get_id target_name output_variable)
  get_property(logid_value TARGET ${target_name} PROPERTY LOGID)
  set(${output_variable} "${logid_value}" PARENT_SCOPE)
endfunction()

function(cc_log_set_id logid)
  set(all_targets ${ARGN})
  foreach(target_name IN LISTS all_targets)
    set_property(TARGET ${target_name} PROPERTY LOGID ${logid})
  endforeach()
endfunction()

function(cc_log_append target_or_logid logmessage)
  if(TARGET target_or_logid)
    cc_log_get_id(${target_or_logid} logid)
  elseif(target_or_logid STREQUAL "")
    return()
  else()
    set(logid ${target_or_logid})
  endif()
  set(global_logid "CC_LOG_${logid}")
  string(REPLACE ";" ", " logmessage "${logmessage}")
  set_property(GLOBAL APPEND PROPERTY ${global_logid} "${logmessage}")
endfunction()

function(cc_log_flush logid)
  if(logid STREQUAL "")
    return()
  endif()

  set(global_logid "CC_LOG_${logid}")
  get_property(all_logs GLOBAL PROPERTY ${global_logid})

  if(NOT DEFINED all_logs OR all_logs STREQUAL "")
    message(STATUS "No logs for ${logid}")
    return()
  endif()

  csi_replace(all_logs)
  message(STATUS "${logid}:")
  list(TRANSFORM all_logs PREPEND "  + ")
  foreach(restored_log IN LISTS all_logs)
    csi_restore(restored_log)
    message(STATUS "${restored_log}")
  endforeach()
  set_property(GLOBAL PROPERTY ${global_logid} "")
endfunction()

# glob
function(cc_execlude_incompatible files output_files delete_files)
  set(PLATFORM)
  if(WIN32)
    set(PLATFORM "windows")
  elseif(APPLE)
    set(PLATFORM "macos")
  elseif(UNIX)
    set(PLATFORM "linux")
  endif()

  set(FILTERED_FILES)
  set(EXCLUDED_FILES)
  set(PLATFORM_SPECIFIC_FILES)
  set(DUMMY_FILES)
  set(UNRELATED_FILES)

  foreach(file ${files})
    if(file MATCHES "-${PLATFORM}\\.")
      list(APPEND PLATFORM_SPECIFIC_FILES ${file})
    elseif(file MATCHES "-generic\\.")
      list(APPEND DUMMY_FILES ${file})
    elseif(file MATCHES "-(linux|macos|windows)\\.")
      list(APPEND EXCLUDED_FILES ${file})
    else()
      list(APPEND UNRELATED_FILES ${file})
    endif()
  endforeach()

  set(PROCESSED_PREFIXES)
  foreach(file ${PLATFORM_SPECIFIC_FILES})
    string(REGEX REPLACE "-${PLATFORM}\\..*" "" prefix ${file})
    list(APPEND PROCESSED_PREFIXES ${prefix})
    list(APPEND FILTERED_FILES ${file})
  endforeach()

  foreach(file ${DUMMY_FILES})
    string(REGEX REPLACE "-generic\\..*" "" prefix ${file})
    if(prefix IN_LIST PROCESSED_PREFIXES)
      list(APPEND EXCLUDED_FILES ${file})
    else()
      list(APPEND FILTERED_FILES ${file})
    endif()
  endforeach()

  list(APPEND FILTERED_FILES ${UNRELATED_FILES})

  set(${output_files} ${FILTERED_FILES} PARENT_SCOPE)
  set(${delete_files} ${EXCLUDED_FILES} PARENT_SCOPE)
endfunction()

function(cc_glob OUTPUTS PATTERNS)
  if(NOT ${PATTERNS})
    return()
  endif()

  set(options EXCLUDE FILTER_OS_ARCH)
  set(oneValueArgs LOGID)
  set(multiValueArgs)

  # Parse additional options
  cmake_parse_arguments(CC_ARGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  set(MATCHED_FILES)

  # Loop through each pattern in the provided PATTERNS list
  foreach(pattern ${${PATTERNS}})
    set(CURRENT_FILES)

    # Perform recursive search if pattern contains '**'
    if(${pattern} MATCHES ".*\\*\\*.*")
      file(GLOB_RECURSE CURRENT_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${pattern})
      # Perform single-directory search if pattern contains '*'
    elseif(${pattern} MATCHES ".*\\*.*")
      file(GLOB CURRENT_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${pattern})
      # If no glob pattern is detected, directly append the file
    elseif(IS_DIRECTORY ${pattern})
      file(GLOB_RECURSE CURRENT_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${pattern}/*.*)
    else()
      list(APPEND CURRENT_FILES ${pattern})
    endif()

    list(APPEND MATCHED_FILES ${CURRENT_FILES})
  endforeach()

  cc_execlude_incompatible("${MATCHED_FILES}" FILTERED_FILES EXCLUDED_FILES)
  if(EXCLUDED_FILES AND CC_ARGS_LOGID)
    cc_log_append(${CC_ARGS_LOGID} "${CSI_Yellow}Incompatible platform files: ${EXCLUDED_FILES}${CSI_Reset}")
  endif()

  if(CC_ARGS_EXCLUDE)
    # cc_truncate_list(truncated_files TRUE ${FILTERED_FILES})
    # cc_log_append(${CC_ARGS_LOGID} "Excludes: ${truncated_files}")
    list(REMOVE_ITEM ${OUTPUTS} ${FILTERED_FILES})
    set(${OUTPUTS} ${${OUTPUTS}} PARENT_SCOPE)
  else()
    set(${OUTPUTS} ${FILTERED_FILES} PARENT_SCOPE)
  endif()
endfunction()

function(cc_warnings)
  set(all_targets ${ARGN})
  foreach(target IN LISTS all_targets)
    target_compile_options(
      ${target} PRIVATE
      $<$<COMPILE_LANGUAGE:C,CXX,ASM>:
        -Wformat=2
        -Wsign-compare
        -Wmissing-field-initializers
        -Wwrite-strings
        -Wvla
        -Wcast-align
        -Wcast-qual
        -Wswitch-enum
        -Wundef
        -Wdouble-promotion
        -Wdate-time
        -Wfloat-equal
        -fno-strict-aliasing
        -pipe
        -Wunused-const-variable
        -Wall
        -Wextra
        -fno-common
        -fvisibility=default
      >
    )

    target_compile_options(
      ${target} PRIVATE
      $<$<AND:$<COMPILE_LANGUAGE:C,CXX,ASM>,$<CXX_COMPILER_ID:GNUCC,GNUCXX>>:
        -Wtrampolines
        -Wl,-z,relro,-z,now
        -Wmissing-format-attribute
        -Wstrict-overflow=2
        -Wswitch-default
        -Wconversion
        -Wunused
        -Wpointer-arith
      >
    )

    if(CMAKE_COMPILER_IS_GNUCC)
      target_compile_options(
        ${target} PRIVATE
        $<$<VERSION_GREATER:$<C_COMPILER_VERSION>,4.3.0>:-Wlogical-op>
        $<$<VERSION_GREATER:$<C_COMPILER_VERSION>,4.8.0>:-Wno-array-bounds>
        # GCC (at least 4.8.4) has a bug where it'll find unreachable free() calls and declare that the code is
        # trying to free a stack pointer.
        $<$<VERSION_GREATER:$<C_COMPILER_VERSION>,4.8.4>:-Wno-free-nonheap-object>
        $<$<VERSION_GREATER:$<C_COMPILER_VERSION>,6.0.0>:-Wduplicated-cond -Wnull-dereference>
        $<$<VERSION_GREATER:$<C_COMPILER_VERSION>,7.0.0>:-Wduplicated-branches -Wrestrict>
      )
      # shared or module
      target_link_options(${target} PRIVATE $<$<NOT:$<BOOL:${APPLE}>>:-Wl,--fatal-warnings -Wl,--no-undefined>)
    endif()

    if(${CMAKE_CXX_COMPILER_ID} MATCHES "Clang")
      target_compile_options(
        ${target} PRIVATE
        $<$<COMPILE_LANGUAGE:C,CXX,ASM>:
          -Wmissing-variable-declarations -Wcomma
          -Wused-but-marked-unused -Wnewline-eof -fcolor-diagnostics
        >
        $<$<VERSION_GREATER:$<C_COMPILER_VERSION>,7.0.0>:-Wimplicit-fallthrough>
      )
    endif()

    target_compile_options(
      ${target} PRIVATE
      $<$<COMPILE_LANG_AND_ID:C,AppleClang,Clang,GNUCC,GNUCXX>:
        -Wmissing-prototypes
        -Wold-style-definition
        -Wstrict-prototypes
      >
      $<$<COMPILE_LANG_AND_ID:CXX,AppleClang,Clang,GNUCC,GNUCXX>:
        -Wmissing-declarations
        -Weffc++
      >
    )

    # In GCC, -Wmissing-declarations is the C++ spelling of -Wmissing-prototypes and using the wrong one is an error. In
    # Clang, -Wmissing-prototypes is the spelling for both and -Wmissing-declarations is some other warning.
    #
    # https://gcc.gnu.org/onlinedocs/gcc-7.1.0/gcc/Warning-Options.html#Warning-Options
    # https://clang.llvm.org/docs/DiagnosticsReference.html#wmissing-prototypes
    # https://clang.llvm.org/docs/DiagnosticsReference.html#wmissing-declarations
    target_compile_options(
      ${target} PRIVATE
      $<$<COMPILE_LANG_AND_ID:CXX,AppleClang,Clang>:-Wmissing-prototypes>
      $<$<COMPILE_LANG_AND_ID:C,GNUCC>:-Wc++-compat>
      $<$<VERSION_GREATER:$<C_COMPILER_VERSION>,4.7.99>:-Wshadow>
      $<$<VERSION_GREATER:$<CXX_COMPILER_VERSION>,4.7.99>:-Wshadow>
      $<$<VERSION_GREATER:$<ASM_COMPILER_VERSION>,4.7.99>:-Wshadow>
    )
  endforeach()
endfunction()

function(cc_small_footprint)
  set(all_targets ${ARGN})
  foreach(target IN LISTS all_targets)
    cc_log_append(${target} "${CSI_Blue}Small footprint${CSI_Reset}")
    target_compile_options(
      ${target} PRIVATE
      -Os
      $<
        $<AND:
          $<OR:$<COMPILE_LANGUAGE:C>, $<COMPILE_LANGUAGE:CXX>, $<COMPILE_LANGUAGE:ASM>>,
          $<OR:$<CXX_COMPILER_ID:GNUCC>, $<CXX_COMPILER_ID:GNUCXX>>
        >:
        --specs=nosys.specs --specs=nano.specs
      >
      $<
        $<AND:
          $<OR:$<COMPILE_LANGUAGE:C>, $<COMPILE_LANGUAGE:CXX>, $<COMPILE_LANGUAGE:ASM>>,
          $<OR:$<CXX_COMPILER_ID:AppleClang>, $<CXX_COMPILER_ID:Clang>>
        >:
        -flto=thin
      >
      $<
        $<OR:$<CXX_COMPILER_ID:GNU>, $<CXX_COMPILER_ID:Clang>>:
        -ffunction-sections -fdata-sections
      >
    )
    target_link_options(
      ${target} PRIVATE
      $<$<OR:$<LINKER_ID:GNU>,$<LINKER_ID:LLD>>:-Wl,--gc-sections>
    )
  endforeach()
endfunction()

function(cc_append_if_absent LIST VALUE)
  get_property(CACHE_TYPE CACHE ${LIST} PROPERTY TYPE)

  if(NOT "${VALUE}" IN_LIST ${LIST})
    if(CACHE_TYPE)
      get_property(VAR_HELPSTRING CACHE ${LIST} PROPERTY HELPSTRING)
      if(VAR_HELPSTRING)
        set(${LIST} "${${LIST}};${VALUE}" CACHE ${CACHE_TYPE} "${VAR_HELPSTRING}")
      else()
        set(${LIST} "${${LIST}};${VALUE}" CACHE ${CACHE_TYPE} "")
      endif()
    else()
      list(APPEND ${LIST} "${VALUE}")
      set(${LIST} "${${LIST}}" PARENT_SCOPE)
    endif()
  endif()
endfunction()

function(cc_get_first_defined OUTPUT)
    foreach(varname ${ARGN})
        if(DEFINED ${varname})
            set(${OUTPUT} "${${varname}}" PARENT_SCOPE)
            return()
        endif()
    endforeach()
endfunction()

function(cc_find_package Name found)
  string(TOUPPER "${Name}" upper_case_name)
  string(TOLOWER "${Name}" lower_case_name)
  string(REPLACE "-" "_" lower_case_name "${lower_case_name}")
  string(REPLACE "-" "_" upper_case_name "${upper_case_name}")

  set(flags "NO_CMAKE;USE_PKG_CONFIG")
  cmake_parse_arguments(CC "${flags}" "" "" "${ARGN}")
  string(REPLACE " " ";" EXTRA_ARGS "${CC_UNPARSED_ARGUMENTS}")

  if(NOT CC_NO_CMAKE)
    find_package(${Name} ${EXTRA_ARGS})
  endif()

  if(NOT ${Name}_FOUND AND CC_USE_PKG_CONFIG)
    find_package(PkgConfig)
    if(PKGCONFIG_FOUND)
      set(OLD_PKG_CONFIG_PATH $ENV{PKG_CONFIG_PATH})
      set(ENV{PKG_CONFIG_PATH} "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig")
      pkg_check_modules(${Name} ${lower_case_name})
      set(ENV{PKG_CONFIG_PATH} ${OLD_PKG_CONFIG_PATH})
    endif()
  endif()

  set(${found} ${${Name}_FOUND} PARENT_SCOPE)

  if(${Name}_FOUND)
    cc_append_if_absent(CC_IMPORTED_PACKAGES ${Name})
    message(STATUS "CC::${Name} imported:")

    cc_get_first_defined(_version
      ${Name}_VERSION
      ${lower_case_name}_VERSION
      ${upper_case_name}_VERSION
    )
    if(_version)
      message(STATUS "  + Version: ${_version}")
    endif()

    cc_get_first_defined(_include_dirs
      ${Name}_INCLUDE_DIRS
      ${lower_case_name}_INCLUDE_DIRS
      ${upper_case_name}_INCLUDE_DIRS
      ${Name}_INCLUDE_DIR
      ${lower_case_name}_INCLUDE_DIR
      ${upper_case_name}_INCLUDE_DIR
    )
    if(_include_dirs)
      message(STATUS "  + Include directories: ${_include_dirs}")
      cc_append_if_absent(CC_IMPORT_INCLUDE_DIRECTORIES "${_include_dirs}")
    endif()

    cc_get_first_defined(_libraries
      ${Name}_LIBRARIES
      ${lower_case_name}_LIBRARIES
      ${upper_case_name}_LIBRARIES
    )
    if(_libraries)
      cc_truncate_list(truncated_libraries TRUE ${_libraries})
      message(STATUS "  + Include directories: ${truncated_libraries}")
    endif()

    cc_get_first_defined(_library_dirs
      ${Name}_LIBRARY_DIRS
      ${lower_case_name}_LIBRARY_DIRS
      ${upper_case_name}_LIBRARY_DIRS
      ${Name}_LIBRARY_DIR
      ${lower_case_name}_LIBRARY_DIR
      ${upper_case_name}_LIBRARY_DIR
    )
    if(_library_dirs)
      cc_truncate_list(truncated_directories TRUE ${_library_dirs})
      message(STATUS "  + Library directories: ${truncated_directories}")
      cc_append_if_absent(CC_IMPORT_LINK_DIRECTORIES "${_library_dirs}")
    endif()
  endif()
endfunction()

function(cc_declare_fetch Name)
  FetchContent_Declare(${Name} ${ARGN})
endfunction()

function(cc_fetch_package Name DOWNLOAD_ONLY populated)
  set(${populated} FALSE PARENT_SCOPE)
  string(TOLOWER "${Name}" lower_case_name)

  if(DOWNLOAD_ONLY)
    FetchContent_Populate(${Name})
  else()
    FetchContent_MakeAvailable(${Name})
  endif()
  set(${populated} TRUE PARENT_SCOPE)
endfunction()

function(cc_import Name)
  set(flags QUIET REQUIRED PRECOMPILED DOWNLOAD_ONLY)
  set(oneValueArgs URI REPO SOURCE_DIR BINARY_DIR SUBBUILD_DIR)
  set(multiValueArgs CONFIGURE_COMMAND BUILD_COMMAND INSTALL_COMMAND)

  cmake_parse_arguments(CC "${flags}" "${oneValueArgs}" "${multiValueArgs}" "${ARGN}")

  if(NOT CC_REPO AND NOT CC_URI)
    set(find_args)
    if(CC_QUIET)
      list(APPEND find_args QUIET)
    endif()
    if(CC_REQUIRED)
      list(APPEND find_args REQUIRED)
    endif()
    if(CC_UNPARSED_ARGUMENTS)
      list(APPEND find_args ${CC_UNPARSED_ARGUMENTS})
    endif()

    cc_find_package(${Name} found ${find_args})

    return()
  endif()

  include(FetchContent)
  string(TOLOWER "${Name}" lower_case_name)
  string(TOUPPER "${Name}" upper_case_name)
  set(source_dir "${CC_SOURCE_CACHE}/${lower_case_name}-src")
  set(binary_dir "${CMAKE_BINARY_DIR}/deps/${lower_case_name}-build")
  set(subbuild_dir "${CMAKE_BINARY_DIR}/deps/${lower_case_name}-subbuild")
  set(CC_PACKAGE_${Name}_SOURCE_DIR "${source_dir}" CACHE INTERNAL "")
  set(CC_PACKAGE_${Name}_BINARY_DIR "${binary_dir}" CACHE INTERNAL "")

  if(CC_REPO)
    cmake_parse_arguments(CC_REPO "" "VERSION;COMMIT;TAG:BRANCH" "" "${CC_UNPARSED_ARGUMENTS}")
    set(CC_UNPARSED_ARGUMENTS ${CC_REPO_UNPARSED_ARGUMENTS})

    set(git_repo)
    if(CC_REPO MATCHES "^github:")
      string(REGEX REPLACE "^github:" "" _gh "${CC_REPO}")
      set(git_repo "https://github.com/${_gh}.git")
    else()
      set(git_repo "${CC_REPO}")
    endif()

    set(git_tag)
    if(CC_REPO_COMMIT)
      set(git_tag ${CC_REPO_COMMIT})
    elseif(CC_REPO_BRANCH)
      set(git_tag ${CC_REPO_BRANCH})
    elseif(CC_REPO_TAG)
      set(git_tag ${CC_REPO_TAG})
    elseif(CC_REPO_VERSION)
      set(git_tag "v${CC_REPO_VERSION}")
    else()
      set(git_tag "master")
    endif()

    message(STATUS "CC::${Name} Using GIT_REPOSITORY=${git_repo} GIT_TAG=${git_tag}")

    cc_declare_fetch(
      ${Name}
      GIT_REPOSITORY "${git_repo}"
      GIT_TAG "${git_tag}"
      GIT_SHALLOW ON
      GIT_PROGRESS ON
      SOURCE_DIR "${source_dir}"
      BINARY_DIR "${binary_dir}"
      SUBBUILD_DIR "${subbuild_dir}"
      ${CC_REPO_UNPARSED_ARGUMENTS}
    )

    if(NOT DEFINED CC_DOWNLOAD_ONLY)
      set(CC_DOWNLOAD_ONLY FALSE)
    endif()

    cc_fetch_package(${Name} ${CC_DOWNLOAD_ONLY} populated)
    if(populated)
      cc_append_if_absent(CC_IMPORTED_PACKAGES ${Name})
    endif()
    return()
  endif()

  if(NOT CC_PRECOMPILED)
    if(CC_CONFIGURE_COMMAND OR CC_BUILD_COMMAND OR CC_INSTALL_COMMAND)
      cc_declare_fetch(
        ${Name}
        URL "${CC_URI}"
        SOURCE_DIR "${source_dir}"
        BINARY_DIR "${binary_dir}"
        SUBBUILD_DIR "${subbuild_dir}"
        ${CC_UNPARSED_ARGUMENTS}
      )
      cc_fetch_package(${Name} TRUE populated)
      if(NOT populated)
        return()
      endif()
      set(CC_PACKAGE_${Name}_POPULATED CACHE INTERNAL TRUE "")
      file(TOUCH ${subbuild_dir}/.POPULATED)

      if(NOT CC_PACKAGE_${Name}_CONFIGURED AND NOT EXISTS ${subbuild_dir}/.CONFIGURED)
        string(REPLACE ";" " " CC_CONFIGURE_COMMAND "${CC_CONFIGURE_COMMAND}")
        string(REGEX REPLACE "^['\"]|['\"]$" "" CC_CONFIGURE_COMMAND "${CC_CONFIGURE_COMMAND}")
        string(FIND "${CC_CONFIGURE_COMMAND}" " " space_index)
        if(space_index EQUAL -1)
          set(configure_executable "${CC_CONFIGURE_COMMAND}")
        else()
          string(SUBSTRING "${CC_CONFIGURE_COMMAND}" 0 ${space_index} configure_executable)
        endif()
        if(NOT IS_ABSOLUTE ${configure_executable})
          set(configure_executable "${source_dir}/${configure_executable}")
        endif()

        if(space_index EQUAL -1)
          set(CC_CONFIGURE_COMMAND ${configure_executable})
        else()
          string(SUBSTRING "${CC_CONFIGURE_COMMAND}" ${space_index} -1 remaining_command)
          string(STRIP "${remaining_command}" remaining_command)
          set(CC_CONFIGURE_COMMAND ${configure_executable} ${remaining_command})
        endif()

        string(REGEX MATCH "--prefix[= ]([^ ]+)" match_result "${CC_CONFIGURE_COMMAND}")
        if(match_result)
          string(REGEX REPLACE "--prefix[= ]" "" prefix_path "${match_result}")
          if(NOT EXISTS "${prefix_path}")
            message(WARNING "Prefix path does not exist. Creating: ${prefix_path}")
            file(MAKE_DIRECTORY "${prefix_path}")
            if(EXISTS "${prefix_path}")
              message(STATUS "Prefix path successfully created: ${prefix_path}")
            else()
              message(FATAL_ERROR "Failed to create prefix path: ${prefix_path}")
            endif()
          endif()
        endif()

        execute_process(
          COMMAND ${CC_CONFIGURE_COMMAND}
          WORKING_DIRECTORY "${binary_dir}"
          RESULT_VARIABLE configure_result
          OUTPUT_VARIABLE configure_output
          ERROR_VARIABLE configure_error
          ECHO_OUTPUT_VARIABLE ECHO_ERROR_VARIABLE
        )
        if(NOT configure_result EQUAL 0)
          message(FATAL_ERROR "Configuring ${Name} failed")
        endif()
        file(TOUCH ${subbuild_dir}/.CONFIGURED)
        set(CC_PACKAGE_${Name}_CONFIGURED CACHE INTERNAL TRUE "")
      endif()

      if(NOT CC_PACKAGE_${Name}_COMPILED AND NOT EXISTS ${subbuild_dir}/.COMPILED)
        # string(REPLACE ";" " " CC_BUILD_COMMAND "${CC_BUILD_COMMAND}")
        # string(REGEX REPLACE "^['\"]|['\"]$" "" CC_BUILD_COMMAND "${CC_BUILD_COMMAND}")
        message(STATUS "Build: ${CC_BUILD_COMMAND}")
        execute_process(
          COMMAND ${CC_BUILD_COMMAND}
          WORKING_DIRECTORY "${binary_dir}"
          RESULT_VARIABLE build_result
          OUTPUT_VARIABLE build_output
          ERROR_VARIABLE build_error
          ECHO_OUTPUT_VARIABLE ECHO_ERROR_VARIABLE
        )
        if(NOT build_result EQUAL 0)
          message(FATAL_ERROR "Building ${Name} failed")
        endif()

        file(TOUCH ${subbuild_dir}/.COMPILED)
        set(CC_PACKAGE_${Name}_COMPILED CACHE INTERNAL TRUE "")
      endif()

      if(NOT CC_PACKAGE_${Name}_INSTALLED AND NOT EXISTS ${subbuild_dir}/.INSTALLED)
        # string(REPLACE ";" " " CC_INSTALL_COMMAND "${CC_INSTALL_COMMAND}")
        # string(REGEX REPLACE "^['\"]|['\"]$" "" CC_INSTALL_COMMAND "${CC_INSTALL_COMMAND}")
        execute_process(
          COMMAND ${CC_INSTALL_COMMAND}
          WORKING_DIRECTORY "${binary_dir}"
          RESULT_VARIABLE install_result
          OUTPUT_VARIABLE install_output
          ERROR_VARIABLE install_error
          ECHO_OUTPUT_VARIABLE ECHO_ERROR_VARIABLE
        )
        if(NOT install_result EQUAL 0)
          message(FATAL_ERROR "Installing ${Name} failed")
        endif()

        file(TOUCH ${subbuild_dir}/.INSTALLED)
        set(CC_PACKAGE_${Name}_INSTALLED CACHE INTERNAL TRUE "")
      endif()

      cc_find_package(
        ${Name} found
        QUIET
        USE_PKG_CONFIG
        NO_DEFAULT_PATH
        HINTS ${CMAKE_INSTALL_PREFIX}
      )
    else()
      cc_declare_fetch(
        ${Name}
        URL "${CC_URI}"
        SOURCE_DIR "${source_dir}"
        BINARY_DIR "${binary_dir}"
        ${CC_UNPARSED_ARGUMENTS}
      )
      FetchContent_MakeAvailable(${Name})
      cc_append_if_absent(CC_IMPORTED_PACKAGES ${Name})
    endif()
  else()
    cc_declare_fetch(
      ${Name}
      URL "${CC_URI}"
      SOURCE_DIR "${source_dir}"
      ${CC_UNPARSED_ARGUMENTS}
    )
    cc_fetch_package(${Name} TRUE populated)
    if(NOT populated)
      return()
    endif()

    if(EXISTS ${source_dir}/lib)
      cc_append_if_absent(CC_IMPORT_LINK_DIRECTORIES ${source_dir}/lib)
    endif()
    if(EXISTS ${source_dir}/include)
      cc_append_if_absent(CC_IMPORT_INCLUDE_DIRECTORIES ${source_dir}/include)
    endif()

    cc_find_package(${Name} found QUIET NO_DEFAULT_PATH HINTS ${source_dir})
  endif()
endfunction()

cc_import(
  doctest
  REPO "github:doctest/doctest" VERSION 2.4.11
)

# dpendency formats:
#   single package or target: pthread, your_cmake_target
#   path to precompiled library: /path/to/compied_library
#   single package can be found via find_package: Boost::system
#   multiple package can be found via find_package: Boost::system,filesystem
function(cc_depends target)
  set(all_depends ${ARGN})
  if(CC_IMPORT_LINK_DIRECTORIES)
    target_link_directories(${target} PUBLIC ${CC_IMPORT_LINK_DIRECTORIES})
  endif()
  if(CC_IMPORT_INCLUDE_DIRECTORIES)
    target_include_directories(${target} PUBLIC ${CC_IMPORT_INCLUDE_DIRECTORIES})
  endif()
  foreach(DEPNEDS IN LISTS all_depends)
    # Find the position of "::" in the dependencies string
    string(FIND "${DEPNEDS}" "::" pos)

    set(linkage_type "PUBLIC")
    get_target_property(TARGET_TYPE ${target} TYPE)
    if("${TARGET_TYPE}" STREQUAL "INTERFACE_LIBRARY")
      set(linkage_type "INTERFACE")
    endif()

    cc_log_get_id(${target} logid)

    if(pos GREATER -1)
      # Separate the package name and the components part
      math(EXPR cstart "${pos} + 2")
      string(SUBSTRING "${DEPNEDS}" 0 ${pos} package_name)
      string(SUBSTRING "${DEPNEDS}" ${cstart} -1 components_str)

      # Handle the components list (split by commas or spaces)
      string(REPLACE "," ";" components_list "${components_str}")
      string(REPLACE " " ";" components_list "${components_list}")

      # List to store missing components
      set(missing_components)

      # Check if each component already exists as a target
      foreach(component IN LISTS components_list)
        if(NOT TARGET ${package_name}::${component})
          prompt_once(STATUS "Component ${package_name}::${component} not found, will attempt to find it.")
          list(APPEND missing_components ${component}) # Add missing component to the list
        else()
          prompt_once(STATUS "Package ${package_name}::${component} already found, skipping.")
        endif()
      endforeach()

      # If there are missing components, call find_package to locate them
      if(missing_components)
        cc_log_append(${target} "${package_name} with missing components: ${missing_components}")
        find_package(${package_name} QUIET COMPONENTS ${missing_components})
      endif()

      # Link all components (including already found and newly found)
      foreach(component IN LISTS components_list)
        set(link_behavior)
        if(TARGET ${package_name}::${component})
          # For non-cmake target, get_target_property will throw an error
          get_target_property(link_behavior ${package_name}::${component} LINK_BEHAVIOR)

          if("${link_behavior}" STREQUAL "WHOLE_ARCHIVE")
            cc_log_append(${target} "${CSI_Yellow}${depend} Link whole archive${CSI_Reset}")
            # TODO(Oakley): fix this issue link whole-archive of static library will cause the multiple defined symbols error,
            # those also defined in libgcc. allow multiple definition is not good idea. it will cause constructors defined in
            # libraries execute more than twice times. build shared library can temporarily fix this problem
            if(APPLE)
              target_link_libraries(${target} ${linkage_type} -Wl,-force_load ${depend})
            elseif(MSVC)
              # In MSVC, we will add whole archive in default.
              target_link_libraries(${target} ${linkage_type} -WHOLEARCHIVE:${depend})
            else()
              # Assume everything else is like gcc
              target_link_libraries(${target} ${linkage_type} -Wl,--allow-multiple-definition)
              target_link_libraries(${target} ${linkage_type} -Wl,--whole-archive ${depend} -Wl,--no-whole-archive)
            endif()
          else()
            target_link_libraries(${target} ${linkage_type} ${package_name}::${component})
          endif()
        else()
          target_link_libraries(${target} ${linkage_type} ${package_name}::${component})
        endif()
      endforeach()
    else()
      # If no "::" is found, treat it as a single library
      if(NOT TARGET ${DEPNEDS})
        cc_log_append(${target} "add_deps: ${DEPNEDS}")
        find_package(${DEPNEDS} QUIET)
      endif()

      set(link_behavior)
      if(TARGET ${DEPNEDS})
        # For non-cmake target, get_target_property will throw an error
        get_target_property(link_behavior ${DEPNEDS} LINK_BEHAVIOR)

        if("${link_behavior}" STREQUAL "WHOLE_ARCHIVE")
          cc_log_append(${target} "${CSI_Yellow}${depend} Link whole archive${CSI_Reset}")
          # TODO(Oakley): fix this issue link whole-archive of static library will cause the multiple defined symbols error,
          # those also defined in libgcc. allow multiple definition is not good idea. it will cause constructors defined in
          # libraries execute more than twice times. build shared library can temporarily fix this problem
          if(APPLE)
            target_link_libraries(${target} ${linkage_type} -Wl,-force_load ${depend})
          elseif(MSVC)
            # In MSVC, we will add whole archive in default.
            target_link_libraries(${target} ${linkage_type} -WHOLEARCHIVE:${depend})
          else()
            # Assume everything else is like gcc
            target_link_libraries(${target} ${linkage_type} -Wl,--allow-multiple-definition)
            target_link_libraries(${target} ${linkage_type} -Wl,--whole-archive ${depend} -Wl,--no-whole-archive)
          endif()
        else()
          target_link_libraries(${target} ${linkage_type} ${DEPNEDS})
        endif()
      else()
        target_link_libraries(${target} ${linkage_type} ${DEPNEDS})
      endif()
    endif()
  endforeach()
endfunction()

function(cc_features targetname)
  set(all_targets)
  foreach(target IN LISTS ARGN)
    if(TARGET "${target}")
      get_target_property(alias_prop "${target}" ALIASED_TARGET)
      if(alias_prop)
        message(STATUS "target ${target} is aliased to ${alias_prop}")
        continue()
      endif()
      list(APPEND all_targets ${target})
    else()
      message(FATAL_ERROR "No target named ${target}")
    endif()
  endforeach()

  set(enabled_features PIC)
  set(SUPPORTED_FEATURES DEB CFI COV FUZZ MSAN TSAN ASAN UBSAN)
  foreach(feature IN LISTS SUPPORTED_FEATURES)
    # Construct the global variable name, e.g., CC_ENABLE_CFI, etc.
    set(enabled_list_var "CC_ENABLE_${feature}")
    if(NOT DEFINED ${enabled_list_var})
      set(${enabled_list_var})
    endif()
    # message(STATUS "${enabled_list_var}: ${${enabled_list_var}}")
    if("${${enabled_list_var}}" STREQUAL "all")
      set(FEATURES_${feature} ON)
      list(APPEND enabled_features ${feature})
      continue()
    endif()

    # Check if the target name exists in the CC_ENABLE_* list
    string(REPLACE "," ";" ${enabled_list_var} "${${enabled_list_var}}")
    list(FIND ${enabled_list_var} ${targetname} target_index)
    if(target_index GREATER -1)
      set(FEATURES_${feature} ON)
      list(APPEND enabled_features ${feature})
    else()
      set(FEATURES_${feature} OFF)
    endif()
  endforeach()

  set(logid "CC::${targetname}")
  cc_log_append(${logid} "${CSI_Blue}Features: ${enabled_features}${CSI_Reset}")

  if(FEATURES_DEB)
    foreach(target IN LISTS all_targets)
      target_compile_options(${target} PRIVATE
        $<$<AND:$<CONFIG:Debug>,$<C_COMPILER_ID:GNU>>:-O0 -ggdb>
        $<$<AND:$<CONFIG:Debug>,$<C_COMPILER_ID:Clang>>:-O0 -ggdb>
        $<$<AND:$<CONFIG:Debug>,$<C_COMPILER_ID:MSVC>>:/Od /Z7>
      )
    endforeach()
  endif()

  if(FEATURES_FUZZ)
    if(NOT (CMAKE_COMPILER_IS_CLANG OR CMAKE_COMPILER_IS_GNU))
      message(FATAL_ERROR "You need Clang or GCC for fuzzing to work")
    endif()

    if(CMAKE_COMPILER_IS_CLANG AND CMAKE_C_COMPILER_VERSION VERSION_LESS "6.0.0")
      message(FATAL_ERROR "You need Clang ≥ 6.0.0 for fuzzing")
    endif()

    if(CMAKE_COMPILER_IS_GNU AND CMAKE_C_COMPILER_VERSION VERSION_LESS "8.1.0")
      message(FATAL_ERROR "You need GCC ≥ 8.1.0 for fuzzing")
    endif()

    foreach(target IN LISTS all_targets)
      target_compile_definitions(${target} PRIVATE -DUNSAFE_DETERMINISTIC_MODE)
      target_compile_options(
        ${target} PRIVATE
        $<$<COMPILE_LANGUAGE:C,CXX>:
          -fsanitize=fuzzer-no-link
        >
      )
    endforeach()
  endif()

  if(FEATURES_MSAN)
    if(FEATURES_ASAN)
      message(FATAL_ERROR "${CSI_BoldRed}ASAN and MSAN are mutually exclusive${CSI_Reset}")
    endif()

    if(NOT (CMAKE_COMPILER_IS_CLANG OR CMAKE_COMPILER_IS_GNU))
      message(FATAL_ERROR "MSAN requires Clang or GCC")
    endif()

    if(CMAKE_COMPILER_IS_GNU AND CMAKE_C_COMPILER_VERSION VERSION_LESS "7.0")
      message(FATAL_ERROR "You need GCC ≥ 7.0 for MSAN")
    endif()

    foreach(target IN LISTS all_targets)
      target_compile_options(
        ${target} PRIVATE
        $<$<COMPILE_LANG_AND_ID:C,CXX,AppleClang,Clang,GNU>:
          -fsanitize=memory
          -fsanitize-memory-track-origins
          -fno-omit-frame-pointer
        >
      )
    endforeach()
  endif()

  if(FEATURES_ASAN)
    if(FEATURES_MSAN)
      message(FATAL_ERROR "${CSI_BoldRed}ASAN and MSAN are mutually exclusive${CSI_Reset}")
    endif()

    if(NOT (CMAKE_COMPILER_IS_CLANG OR CMAKE_COMPILER_IS_GNU))
      message(FATAL_ERROR "ASAN requires Clang or GCC")
    endif()

    foreach(target IN LISTS all_targets)
      target_compile_options(
        ${target} PRIVATE
        $<$<COMPILE_LANG_AND_ID:C,CXX,AppleClang,Clang,GNU>:
          -fsanitize=address
          -fsanitize-address-use-after-scope
          -fno-omit-frame-pointer
        >
      )
      target_link_options(
        ${target} PRIVATE
        $<$<COMPILE_LANG_AND_ID:C,CXX,AppleClang,Clang,GNU>:
          -fsanitize=address
          -fsanitize-address-use-after-scope
          -fno-omit-frame-pointer
        >
      )
    endforeach()
  endif()

  # ROP(Return-oriented Programming) Attack
  if(FEATURES_CFI)
    if(NOT CMAKE_COMPILER_IS_CLANG)
      message(FATAL_ERROR "${CSI_BoldRed}CFI requires Clang${CSI_Reset}")
    endif()

    foreach(target IN LISTS all_targets)
      target_compile_options(
        ${target} PRIVATE
        $<$<COMPILE_LANGUAGE:C,CXX>:
          -fsanitize=cfi -fno-sanitize-trap=cfi -flto=thin
        >
      )
      target_link_options(
        ${target} PRIVATE
        $<$<COMPILE_LANGUAGE:C,CXX>:
          -fsanitize=cfi -fno-sanitize-trap=cfi -flto=thin
        >
      )
    endforeach()
  endif()

  if(FEATURES_TSAN)
    if(NOT CMAKE_COMPILER_IS_CLANG)
      message(FATAL_ERROR "${CSI_BoldRed}Cannot enable TSAN unless using Clang${CSI_Reset}")
    endif()

    foreach(target IN LISTS all_targets)
      target_compile_options(${target} PRIVATE $<$<COMPILE_LANGUAGE:C,CXX>:-fsanitize=thread>)
      target_link_options($<$<STREQUAL:$<TARGET_PROPERTY:${target},TYPE>,"EXECUTABLE">:-fsanitize=thread>)
    endforeach()
  endif()

  if(FEATURES_UBSAN)
    if(NOT (CMAKE_COMPILER_IS_CLANG OR CMAKE_COMPILER_IS_GNU))
      message(FATAL_ERROR "UBSAN requires Clang or GCC")
    endif()

    foreach(target IN LISTS all_targets)
      target_compile_options(
        ${target} PRIVATE
        $<$<COMPILE_LANG_AND_ID:C,CXX,AppleClang,Clang,GNU>:
          -fsanitize=undefined
          -fsanitize=float-divide-by-zero
          -fsanitize=float-cast-overflow
          -fsanitize=integer
        >
      )
      target_link_options(
        ${target} PRIVATE
        $<$<COMPILE_LANG_AND_ID:C,CXX,AppleClang,Clang,GNU>:
          -fsanitize=undefined
          -fsanitize=float-divide-by-zero
          -fsanitize=float-cast-overflow
          -fsanitize=integer
        >
      )
    endforeach()

    if(NOT FEATURES_UBSAN_RECOVER)
      foreach(target IN LISTS all_targets)
        target_compile_options(${target} PRIVATE $<$<COMPILE_LANG_AND_ID:C,CXX,AppleClang,Clang,GNU>:-fno-sanitize-recover=undefined>)
        target_link_options(${target} PRIVATE $<$<COMPILE_LANG_AND_ID:C,CXX,AppleClang,Clang,GNU>:-fno-sanitize-recover=undefined>)
      endforeach()
    endif()
  endif()

  # Coverage
  if(FEATURES_COV)
    if(NOT TARGET all_cov)
      add_custom_target(
        all_cov
        COMMAND ${CMAKE_COMMAND} -E echo "Aggregating all coverage reports..."
        COMMENT "Aggregating coverage for all targets"
      )
    endif()

    if(CMAKE_SYSTEM_NAME STREQUAL "Linux" AND CMAKE_COMPILER_IS_GNUCC)
      foreach(target IN LISTS all_targets)
        target_link_libraries(${target} PUBLIC gcov)
        target_compile_options(${target} PUBLIC $<$<COMPILE_LANGUAGE:C,CXX>:-fprofile-arcs -ftest-coverage>)
      endforeach()

      add_custom_target(
        ${targetname}_cov
        COMMAND ${CMAKE_COMMAND} -E make_directory reports/coverage
        COMMAND ${CMAKE_MAKE_PROGRAM} test
        COMMAND echo "Generating coverage reports ..."
        COMMAND gcovr -r ${CMAKE_SOURCE_DIR} --html --html-details
                ${CMAKE_BINARY_DIR}/reports/coverage/full.html
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      )
      add_dependencies(all_cov ${targetname}_cov)
    elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin" AND ${CMAKE_CXX_COMPILER_ID} MATCHES "Clang")
      foreach(target IN LISTS all_targets)
        target_compile_options(${target} PUBLIC $<$<COMPILE_LANGUAGE:C,CXX>:-fprofile-instr-generate -fcoverage-mapping>)
        target_link_options(${target} PRIVATE -fprofile-instr-generate -fcoverage-mapping)
      endforeach()

      add_custom_target(
        ${targetname}_cov
        COMMAND ${CMAKE_COMMAND} -E make_directory reports/coverage
        COMMAND ${CMAKE_MAKE_PROGRAM} test
        COMMAND echo "Generating coverage reports ..."
        COMMAND llvm-profdata merge -sparse default.profraw -o coverage.profdata
        COMMAND llvm-cov show ${CMAKE_BINARY_DIR}
                --instr-profile=coverage.profdata
                --format=html
                --output-dir=reports/coverage
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      )
      add_dependencies(all_cov ${targetname}_cov)
    else()
      message(WARNING "Coverage is not configured on this platform: ${CMAKE_SYSTEM_NAME}")
    endif()
  endif()
endfunction()

# HEADERS/SOURCES:
# PUBLIC/PRIVATE/INTERFACE or not specified
#   - Recursive: /path/to/(**.h, **.cc)
#   - Non-recursive: /path/to/(*.h, *.cc)
#   - Relative/Absolute: /path/to/(xx.h, xx.cc)
#
# OPTIONS: Compile Options
# LINK_OPTIONS: Link Options
#
# INCLUDES: Include Directories
#
# DEPENDS: Dependencies of this target
#
# FEATURES: Sanitize Options and Features
#   - CFI: Ensures control flow integrity to prevent function pointer or vtable hijacking
#   - COV: Provides test coverage analysis by generating statistics on tested code
#   - FUZZ: Uses random input generation to detect vulnerabilities or crashes
#   - MSAN: Detects uninitialized memory reads
#   - ASAN: Identifies memory errors like buffer overflows and use-after-free
#   - TSAN: Detects data races in multithreaded programs
#   - UBSAN: Identifies undefined behavior such as integer overflow or invalid type casts
function(cc_package Name)
  set(logid "CC::${Name}")
  set(options LIBRARY BINARY TEST STATIC SHARED ALWAYS_LINK SMALL_FOOTPRINT EXCLUDE_FROM_ALL KEEP_SOURCE_DIRECTORY)
  set(oneValueArgs VERSION SOVERSION ALIAS OUTPUT_NAME VISIBILITY INCLUDE_PREFIX)
  set(multiValueArgs INCLUDES HEADERS SOURCES OPTIONS LINK_OPTIONS DEPENDS FEATURES REQUIRES)
  cmake_parse_arguments(CC_ARGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(CC_ARGS_REQUIRES)
    cc_check_requires(requires_met ${logid} ${CC_ARGS_REQUIRES})
    if(NOT requires_met)
      cc_log_append(${logid} "${CSI_Yellow}requires not met, skipped.${CSI_Reset}")
      cc_log_flush(${logid})
      return()
    endif()
  endif()

  set(subOptions)
  set(subOneValueArgs)
  set(subMultiValueArgs PUBLIC PRIVATE INTERFACE EXCLUDE)
  foreach(arg IN LISTS multiValueArgs)
    cmake_parse_arguments(CC_SUBARGS_${arg} "${subOptions}" "${subOneValueArgs}" "${subMultiValueArgs}" ${CC_ARGS_${arg}})
    unset(CC_ARGS_${arg})

    if(CC_SUBARGS_${arg}_UNPARSED_ARGUMENTS)
      set(CC_ARGS_${arg} ${CC_SUBARGS_${arg}_UNPARSED_ARGUMENTS})
    endif()
    foreach(subArg IN LISTS subMultiValueArgs)
      if(CC_SUBARGS_${arg}_${subArg})
        set(CC_ARGS_${arg}_${subArg} ${CC_SUBARGS_${arg}_${subArg}})
      endif()
    endforeach()
  endforeach()

  cc_get_parent_namespace(SUPERIOR_NAMESPACE)
  if(NOT CC_ARGS_ALIAS)
    if(SUPERIOR_NAMESPACE)
      set(CC_ARGS_ALIAS ${SUPERIOR_NAMESPACE}::${CC_ARGS_NAMESPACE})
    else()
      set(CC_ARGS_ALIAS ${Name})
    endif()
  endif()
  if(NOT CC_ARGS_OUTPUTNAME)
    string(REPLACE "::" "_" CC_ARGS_OUTPUTNAME ${Name})
  endif()

  if(CC_ARGS_NAMESPACE)
    cc_set_namespace(${CC_ARGS_NAMESPACE})
  endif()

  set(HEADER_FILES)
  if(CC_ARGS_HEADERS)
    cc_glob(HEADER_FILES_DEFAULT CC_ARGS_HEADERS LOGID ${logid})
    if(CC_ARGS_HEADERS_EXCLUDE)
      cc_glob(HEADER_FILES_DEFAULT CC_ARGS_HEADERS_EXCLUDE EXCLUDE LOGID ${logid})
    endif()
    list(APPEND HEADER_FILES ${HEADER_FILES_DEFAULT})
  endif()
  foreach(scope PUBLIC PRIVATE INTERFACE)
    if(CC_ARGS_HEADERS_${scope})
      set(HEADER_FILES_${scope})
      cc_glob(HEADER_FILES_${scope} CC_ARGS_HEADERS_${scope} LOGID ${logid})
      if(CC_ARGS_HEADERS_EXCLUDE)
        cc_glob(HEADER_FILES_${scope} CC_ARGS_HEADERS_${scope} EXCLUDE LOGID ${logid})
      endif()
      list(APPEND HEADER_FILES ${HEADER_FILES_${scope}})
    endif()
  endforeach()

  set(SOURCE_FILES)
  if(CC_ARGS_SOURCES)
    cc_glob(SOURCE_FILES_DEFAULT CC_ARGS_SOURCES LOGID ${logid})
    if(CC_ARGS_SOURCES_EXCLUDE)
      cc_glob(SOURCE_FILES_DEFAULT CC_ARGS_SOURCES_EXCLUDE EXCLUDE LOGID ${logid})
    endif()
    list(APPEND SOURCE_FILES ${SOURCE_FILES_DEFAULT})
  endif()
  foreach(scope PUBLIC PRIVATE INTERFACE)
    if(CC_ARGS_SOURCES_${scope})
      set(SOURCE_FILES_${scope})
      cc_glob(SOURCE_FILES_${scope} CC_ARGS_SOURCES_${scope} LOGID ${logid})
      if(CC_ARGS_SOURCES_EXCLUDE)
        cc_glob(SOURCE_FILES_${scope} CC_ARGS_SOURCES_EXCLUDE EXCLUDE LOGID ${logid})
      endif()
      list(APPEND SOURCE_FILES ${SOURCE_FILES_${scope}})
    endif()
  endforeach()

  set(all_targets)
  set(all_target_types)
  set(all_targets_not_interface)

  if(CC_ARGS_LIBRARY OR CC_ARGS_STATIC OR CC_ARGS_SHARED OR CC_ARGS_OBJECT OR CC_ARGS_INTERFACE)
    set(enable_shared_target OFF)
    set(enable_static_target OFF)
    set(enable_interface_target OFF)
    if(NOT CC_ARGS_SHARED)
      set(enable_shared_target ON)
      set(enable_static_target ON)
    elseif(CC_ARGS_SHARED)
      set(enable_shared_target ON)
    else()
      set(enable_static_target ON)
    endif()
    if(NOT SOURCE_FILES OR CC_ARGS_INTERFACE)
      if(NOT SOURCE_FILES AND (enable_shared_target OR enable_static_target))
        cc_log_append(${logid} "${CSI_Yellow}No source files, add interface only${CSI_Reset}")
      endif()
      set(enable_shared_target OFF)
      set(enable_static_target OFF)
      set(enable_interface_target ON)
    endif()

    if(enable_shared_target)
      add_library(${Name}-shared SHARED)
      add_library(${CC_ARGS_ALIAS} ALIAS ${Name}-shared)
      set_target_properties(${Name}-shared PROPERTIES EXPORT_NAME ${CC_ARGS_ALIAS})
      set_target_properties(${Name}-shared PROPERTIES OUTPUT_NAME ${CC_ARGS_OUTPUTNAME})
      list(APPEND all_targets ${Name}-shared)
      list(APPEND all_targets_not_interface ${Name}-shared)
      list(APPEND all_target_types "shared")
    endif()
    if(enable_static_target)
      add_library(${Name}-static STATIC)
      if(NOT TARGET ${CC_ARGS_ALIAS})
        add_library(${CC_ARGS_ALIAS} ALIAS ${Name}-static)
        set_target_properties(${Name}-static PROPERTIES EXPORT_NAME ${CC_ARGS_ALIAS})
      endif()
      set_target_properties(${Name}-static PROPERTIES OUTPUT_NAME ${CC_ARGS_OUTPUTNAME})
      list(APPEND all_targets ${Name}-static)
      list(APPEND all_targets_not_interface ${Name}-static)
      list(APPEND all_target_types "static")
    endif()
    if(enable_interface_target)
      add_library(${Name}-interface INTERFACE)
      if(NOT TARGET ${CC_ARGS_ALIAS})
        add_library(${CC_ARGS_ALIAS} ALIAS ${Name}-interface)
        set_target_properties(${Name}-interface PROPERTIES EXPORT_NAME ${CC_ARGS_ALIAS})
      endif()
      list(APPEND all_targets ${Name}-interface)
      list(APPEND all_target_types "interface")
    endif()
  elseif(CC_ARGS_BINARY)
    add_executable(${Name})
    list(APPEND all_targets ${Name})
    list(APPEND all_targets_not_interface ${Name})
    set_property(
      TARGET ${Name}
      APPEND PROPERTY INSTALL_RPATH
        "${CMAKE_INSTALL_PREFIX}/lib"
        "../lib"
        "lib"
    )
    list(APPEND all_target_types "binary")
    install(TARGETS ${Name} DESTINATION bin)
  elseif(CC_ARGS_TEST)
    add_executable(${Name})
    add_test(${Name} ${Name})
    list(APPEND all_targets ${Name})
    list(APPEND all_targets_not_interface ${Name})
    set_property(
      TARGET ${Name}
      APPEND PROPERTY INSTALL_RPATH
        "${CMAKE_INSTALL_PREFIX}/lib"
        "../lib"
        "lib"
    )
    list(APPEND all_target_types "test")
    if(APPLE)
      target_compile_options(${Name} PRIVATE -Wno-deprecated-declarations)
    endif()
    target_link_libraries(${Name} PRIVATE doctest::doctest)
    install(TARGETS ${Name} DESTINATION bin/tests)
  else()
    message(FATAL_ERROR "${CSI_BoldRed}Unknown package arguments${CSI_Reset}")
  endif()

  cc_log_set_id(${logid} ${all_targets})
  cc_get_current_namespace(fullnamespace)
  string(REPLACE ";" ", " all_target_types "${all_target_types}")
  cc_log_append(${logid} "Type: ${all_target_types}")
  cc_log_append(${logid} "Targets: ${all_targets}")

  if(CC_ARGS_VERSION)
    cc_log_append(${logid} "Version: ${CC_ARGS_VERSION}")
    foreach(target IN LISTS all_targets_not_interface)
      set_target_properties(${target} PROPERTIES VERSION ${CC_ARGS_VERSION})
    endforeach()
  endif()

  if(CC_ARGS_SOVERSION)
    cc_log_append(${logid} "SOVersion: ${CC_ARGS_SOVERSION}")
    foreach(target IN LISTS all_targets_not_interface)
      set_target_properties(${target} PROPERTIES SOVERSION ${CC_ARGS_SOVERSION})
    endforeach()
  endif()

  if(fullnamespace)
    cc_log_append(${logid} "Namespace: ${CSI_Bold}${fullnamespace}${CSI_Reset}")
  endif()

  if(SOURCE_FILES)
    cc_truncate_list(truncated_source_files TRUE ${SOURCE_FILES})
    cc_log_append(${logid} "Sources: ${truncated_source_files}")
  endif()

  foreach(target IN LISTS all_targets)
    set(default_scope PRIVATE)
    get_target_property(target_type ${target} TYPE)
    if("${target_type}" STREQUAL "INTERFACE_LIBRARY")
      set(default_scope INTERFACE)
    endif()
    if(SOURCE_FILES_DEFAULT)
      target_sources(${target} ${default_scope} ${SOURCE_FILES_DEFAULT})
    endif()
    foreach(scope PUBLIC PRIVATE INTERFACE)
      if(SOURCE_FILES_${scope})
        target_sources(${target} ${scope} ${SOURCE_FILES_${scope}})
      endif()
    endforeach()
  endforeach()

  set(EXPORTED_SCOPES PUBLIC INTERFACE)
  foreach(target IN LISTS all_targets)
    set(PUBLIC_HEADERS)
    set(default_scope PUBLIC)
    get_target_property(target_type ${target} TYPE)
    if("${target_type}" STREQUAL "INTERFACE_LIBRARY")
      set(default_scope INTERFACE)
    endif()
    if(HEADER_FILES_DEFAULT AND default_scope STREQUAL "PUBLIC" OR scope STREQUAL "INTERFACE")
      list(APPEND PUBLIC_HEADERS ${HEADER_FILES_DEFAULT})
    endif()
    foreach(scope PUBLIC PRIVATE INTERFACE)
      if(HEADER_FILES_${scope})
        if(scope STREQUAL "PUBLIC" OR scope STREQUAL "INTERFACE")
          list(APPEND PUBLIC_HEADERS ${HEADER_FILES_${scope}})
        endif()
      endif()
    endforeach()
    target_sources(${target} PUBLIC FILE_SET HEADERS BASE_DIRS ${CMAKE_CURRENT_SOURCE_DIR} FILES ${PUBLIC_HEADERS})
  endforeach()

  foreach(target IN LISTS all_targets)
    set(default_scope PUBLIC)
    get_target_property(target_type ${target} TYPE)
    if("${target_type}" STREQUAL "INTERFACE_LIBRARY")
      set(default_scope INTERFACE)
    endif()
    if(CC_ARGS_INCLUDES)
      target_include_directories(${target} ${default_scope} ${CC_ARGS_INCLUDES})
    endif()
    foreach(scope PUBLIC PRIVATE INTERFACE)
      if(CC_ARGS_INCLUDES_${scope})
        target_include_directories(${target} ${scope} ${CC_ARGS_INCLUDES_${scope}})
      endif()
    endforeach()
  endforeach()

  foreach(target IN LISTS all_targets)
    set(default_scope PRIVATE)
    get_target_property(target_type ${target} TYPE)
    if("${target_type}" STREQUAL "INTERFACE_LIBRARY")
      set(default_scope INTERFACE)
    endif()
    if(CC_ARGS_OPTIONS)
      target_compile_options(${target} ${default_scope} ${CC_ARGS_OPTIONS})
    endif()
    if(CC_ARGS_DEFINITIONS)
      target_compile_definitions(${target} ${default_scope} ${CC_ARGS_DEFINITIONS})
    endif()
    if(CC_ARGS_LINK_OPTIONS)
      target_compile_options(${target} ${default_scope} ${CC_ARGS_LINK_OPTIONS})
    endif()
    foreach(scope PUBLIC PRIVATE INTERFACE)
      if(CC_ARGS_OPTIONS_${scope})
        target_compile_options(${target} ${scope} ${CC_ARGS_OPTIONS_${scope}})
      endif()
    endforeach()
    foreach(scope PUBLIC PRIVATE INTERFACE)
      if(CC_ARGS_DEFINITIONS_${scope})
        target_compile_definitions(${target} ${scope} ${CC_ARGS_DEFINITIONS_${scope}})
      endif()
    endforeach()
    foreach(scope PUBLIC PRIVATE INTERFACE)
      if(CC_ARGS_LINK_OPTIONS_${scope})
        target_compile_options(${target} ${scope} ${CC_ARGS_LINK_OPTIONS_${scope}})
      endif()
    endforeach()
  endforeach()

  if(CC_ARGS_VISIBILITY)
    foreach(target IN LISTS all_targets)
      set_target_properties(${target} PROPERTIES C_VISIBILITY_PRESET ${CC_ARGS_VISIBILITY})
      set_target_properties(${target} PROPERTIES CXX_VISIBILITY_PRESET ${CC_ARGS_VISIBILITY})
    endforeach()
    cc_log_append(${logid} "${CSI_Yellow}Visibility: ${CC_ARGS_VISIBILITY}${CSI_Reset}")
  endif()

  # Enable position-independent code defaultly.
  # This is needed because some library targets are OBJECT libraries.
  # cc_log_append(${logid} "${CSI_Blue}Position Independent Code${CSI_Reset}")
  foreach(target IN LISTS all_targets)
    set_property(TARGET ${target} PROPERTY POSITION_INDEPENDENT_CODE ON)
  endforeach()

  # Option: Whole achrive
  if(CC_ARGS_ALWAYS_LINK)
    foreach(target IN LISTS all_targets)
      set_property(TARGET ${target} PROPERTY LINK_BEHAVIOR WHOLE_ARCHIVE)
    endforeach()
  endif()
  foreach(target IN LISTS all_targets)
    cc_depends(${target} ${CC_ARGS_DEPENDS})
  endforeach()

  # libunwind: a portable and efficient C programming interface (API) to determine the call-chain of a program
  if(CMAKE_SYSTEM_NAME STREQUAL "Linux" AND NOT CMAKE_CROSSCOMPILING)
    find_package(PkgConfig)
    if(PkgConfig_FOUND)
      pkg_check_modules(LIBUNWIND libunwind-generic QUIET)
      if(LIBUNWIND_FOUND)
        foreach(target IN LISTS all_targets)
          target_compile_definitions(${target} PRIVATE -DHAVE_LIBUNWIND)
        endforeach()
      else()
        cc_log_append(${logid} "${CSI_Yellow}libunwind not found. Disabling unwind tests${CSI_Reset}")
      endif()
    else()
      cc_log_append(${logid} "${CSI_Yellow}pkgconfig not found. Disabling unwind tests${CSI_Reset}")
    endif()
  endif()

  foreach(target IN LISTS all_targets_not_interface)
    target_compile_options(
      ${target} PRIVATE
      $<$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>:-fomit-frame-pointer>
      # $<$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>:-freg-struct-return>
      $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<VERSION_GREATER_EQUAL:$<CXX_COMPILER_VERSION>,4.9>>:-fstack-protector-strong>
    )
    target_compile_definitions(
      ${target} PRIVATE
      $<IF:$<CONFIG:Debug>,__DEBUG__,__RELEASE__ NDEBUG>
    )
    target_compile_options(
      ${target} PRIVATE
      $<$<CONFIG:Debug>:
        $<$<CXX_COMPILER_ID:GNU>:-g -gdwarf-5>
        $<$<CXX_COMPILER_ID:Clang>:-g -gdwarf-5>
        $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<PLATFORM_ID:Windows>>:/Zi>
        $<$<AND:$<CXX_COMPILER_ID:Intel>,$<PLATFORM_ID:Linux>>:-g -gdwarf-5>
        $<$<PLATFORM_ID:Darwin>:-g>
        # $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>,$<VERSION_GREATER_EQUAL:$<CXX_COMPILER_VERSION>,4.7>>:-gsplit-dwarf>
      >
    )
  endforeach()

  if(CC_ARGS_SMALL_FOOTPRINT)
    cc_small_footprint(${all_targets})
  endif()

  if(NOT CC_ARGS_KEEP_SOURCE_DIRECTORY)
    # redefine __FILE__ after stripping project dir
    foreach(target IN LISTS all_targets_not_interface)
      target_compile_options(${target} PRIVATE -Wno-builtin-macro-redefined)
    endforeach()
    get_target_property(source_files ${CC_ARGS_ALIAS} SOURCES)
    foreach(srcfile ${source_files})
      # Get compile definitions in source file
      get_property(defs SOURCE "${srcfile}" PROPERTY COMPILE_DEFINITIONS)
      # Get absolute path of source file
      get_filename_component(filepath "${srcfile}" ABSOLUTE)
      # Trim leading dir
      string(FIND "${filepath}" "${CMAKE_BINARY_DIR}" pos)
      if(${pos} EQUAL 0)
        file(RELATIVE_PATH relpath ${CMAKE_BINARY_DIR} ${filepath})
      else()
        file(RELATIVE_PATH relpath ${CMAKE_SOURCE_DIR} ${filepath})
      endif()
      # Add __FILE__ definition to compile definitions
      list(APPEND defs "__FILE__=\"${relpath}\"")
      # Set compile definitions to property
      set_property(SOURCE "${srcfile}" PROPERTY COMPILE_DEFINITIONS ${defs})
    endforeach()
  endif()

  # Install
  if(CC_ARGS_LIBRARY OR CC_ARGS_STATIC OR CC_ARGS_SHARED OR CC_ARGS_INTERFACE)
    set(HEADERS_DIR include)
    if(CC_ARGS_INCLUDE_PREFIX)
      set(HEADERS_DIR ${HEADERS_DIR}/${CC_ARGS_INCLUDE_PREFIX})
    else()
    endif()
    install(
      TARGETS ${all_targets}
      EXPORT ${Name}Targets
      ARCHIVE DESTINATION lib
      LIBRARY DESTINATION lib
      RUNTIME DESTINATION bin
      FILE_SET HEADERS DESTINATION ${HEADERS_DIR}
    )
    install(
      EXPORT ${Name}Targets
      FILE ${Name}Config.cmake
      NAMESPACE ${Name}::
      DESTINATION lib/cmake/${Name}
    )
  endif()

  cc_features(${Name} ${all_targets_not_interface})

  cc_log_flush(${logid})
endfunction()

function(cc_protobuf libname)
  cmake_parse_arguments(CC_ARGS "STATIC;SHARED" "" "" ${ARGN})
  set(proto_files ${CC_ARGS_UNPARSED_ARGUMENTS})

  find_package(absl REQUIRED)
  find_package(Protobuf REQUIRED)
  protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS ${proto_files})

  set(logid "CC::${libname}::protobuf")

  set(all_targets)
  set(all_target_types)
  if(NOT CC_ARGS_SHARED AND CC_ARGS_STATIC)
    add_library(${libname}-static STATIC ${PROTO_SRCS} ${PROTO_HDRS})
    set_target_properties(${libname}-static PROPERTIES OUTPUT_NAME ${libname})
    set_target_properties(${libname}-static PROPERTIES PUBLIC_HEADER "${PROTO_HDRS}")
    target_link_libraries(
      ${libname}-static PUBLIC
      ${Protobuf_LIBRARIES}
      absl::base absl::log
      absl::log_internal_check_op
    )
    target_include_directories(${libname}-static
      PUBLIC
        ${Protobuf_INCLUDE_DIRS}
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
    )
    list(APPEND all_targets ${libname}-static)
    list(APPEND all_target_types static)
  endif()

  if(NOT CC_ARGS_STATIC AND CC_ARGS_SHARED)
    add_library(${libname}-shared SHARED ${PROTO_SRCS} ${PROTO_HDRS})
    set_target_properties(${libname}-shared PROPERTIES OUTPUT_NAME ${libname})
    set_target_properties(${libname}-shared PROPERTIES PUBLIC_HEADER "${PROTO_HDRS}")
    target_link_libraries(
      ${libname}-shared PUBLIC
      ${Protobuf_LIBRARIES}
      absl::base absl::log
      absl::log_internal_check_op
    )
    target_include_directories(${libname}-shared
      PUBLIC
        ${Protobuf_INCLUDE_DIRS}
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
    )
    list(APPEND all_targets ${libname}-shared)
    list(APPEND all_target_types shared)
  endif()

  cc_log_append(${logid} "Type: ${all_target_types}")
  cc_log_append(${logid} "Targets: ${all_targets}")
  cc_log_append(${logid} "Protos: ${proto_files}")

  list(GET all_targets 0 first_target)
  set_target_properties(${first_target} PROPERTIES EXPORT_NAME ${libname}::${libname})
  add_library(${libname} ALIAS ${first_target})

  install(
    TARGETS ${all_targets}
    EXPORT ${libname}Targets
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
    PUBLIC_HEADER DESTINATION include/${libname}
  )
  install(
    EXPORT ${libname}Targets
    FILE ${libname}Config.cmake
    NAMESPACE ${libname}::
    DESTINATION lib/cmake/${libname}
  )

  cc_log_flush(${logid})
endfunction()

function(cc_library Name)
  cc_package(${Name} LIBRARY ${ARGN})
endfunction()

function(cc_binary Name)
  cc_package(${Name} BINARY ${ARGN})
endfunction()

function(cc_test Name)
  cc_package(${Name} TEST ${ARGN})
endfunction()

function(cc_module)
  cc_get_parent_namespace(SUPERIOR_NAMESPACE)
  get_filename_component(CURRENT_DIR ${CMAKE_CURRENT_SOURCE_DIR} NAME)
  set(CURRENT_TARGET ${SUPERIOR_NAMESPACE}::${CURRENT_DIR})
  string(REPLACE "::" "_" CURRENT_TARGET ${CURRENT_TARGET})

  cc_library(
    ${CURRENT_TARGET}
    NAMESPACE ${CURRENT_DIR}
    ALIAS ${SUPERIOR_NAMESPACE}::${CURRENT_DIR}
    ${ARGV}
  )

  set(TEST_PATTERNS **_test.cc)
  cc_glob(TEST_FILES TEST_PATTERNS)
  if(CC_BUILD_TESTS AND TEST_FILES)
    cc_test(
      test-${CURRENT_TARGET}
      NAMESPACE ${CURRENT_DIR}::tests
      SOURCES ${TEST_FILES}
    )
  endif()
endfunction()

function(cc_check_requires RESULT_VAR LOGID)
  set(${RESULT_VAR} TRUE PARENT_SCOPE)

  set(required_compilers "")
  set(required_platforms "")
  set(required_archs "")
  set(cxx_standard_condition "")
  set(c_standard_condition "")
  set(required_libraries "")

  function(map_operator_to_cmake symbol result_var)
    if(symbol STREQUAL ">")
      set(${result_var} "GREATER" PARENT_SCOPE)
    elseif(symbol STREQUAL "<")
      set(${result_var} "LESS" PARENT_SCOPE)
    elseif(symbol STREQUAL ">=")
      set(${result_var} "GREATER_EQUAL" PARENT_SCOPE)
    elseif(symbol STREQUAL "<=")
      set(${result_var} "LESS_EQUAL" PARENT_SCOPE)
    elseif(symbol STREQUAL "=" OR symbol STREQUAL "==")
      set(${result_var} "EQUAL" PARENT_SCOPE)
    elseif(symbol STREQUAL "!=")
      set(${result_var} "NOT_EQUAL" PARENT_SCOPE)
    else()
      message(FATAL_ERROR "Unsupported operator: ${symbol}")
    endif()
  endfunction()

  foreach(require IN LISTS ARGN)
    if(require MATCHES "^Compiler=([^,]+)(,.+)?$")
      set(required_compilers "${CMAKE_MATCH_1}")
      if(CMAKE_MATCH_2)
        string(REPLACE "," ";" compiler_versions "${CMAKE_MATCH_2}")
      endif()
    elseif(require MATCHES "^Platform=([^,]+)$")
      string(REPLACE "," ";" required_platforms "${CMAKE_MATCH_1}")
    elseif(require MATCHES "^Arch=([^,]+)$")
      string(REPLACE "," ";" required_archs "${CMAKE_MATCH_1}")
    elseif(require MATCHES "^CXXStandard([<>=!]+)([0-9]+)$")
      map_operator_to_cmake("${CMAKE_MATCH_1}" operator)
      set(cxx_standard_condition "${operator};${CMAKE_MATCH_2}")
    elseif(require MATCHES "^CStandard([<>=!]+)([0-9]+)$")
      map_operator_to_cmake("${CMAKE_MATCH_1}" operator)
      set(c_standard_condition "${operator};${CMAKE_MATCH_2}")
    elseif(require MATCHES "^Libraries=([^,]+(,.+)?)$")
      string(REPLACE "," ";" required_libraries "${CMAKE_MATCH_1}")
    endif()
  endforeach()

  set(current_compiler "")
  set(current_compiler_version "")
  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(current_compiler "gcc")
    set(current_compiler_version "${CMAKE_CXX_COMPILER_VERSION}")
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    set(current_compiler "clang")
    set(current_compiler_version "${CMAKE_CXX_COMPILER_VERSION}")
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(current_compiler "msvc")
    set(current_compiler_version "${MSVC_VERSION}")
  else()
    set(current_compiler "unknown")
  endif()

  if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(current_platform "linux")
  elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(current_platform "macos")
  elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    set(current_platform "windows")
  else()
    set(current_platform "unknown")
  endif()

  if(NOT CMAKE_C_STANDARD AND c_standard_condition)
    list(GET c_standard_condition 1 required_standard)
    set(flag "-std=c${required_standard}")
    include(CheckCCompilerFlag)
    check_c_compiler_flag("${flag}" SUPPORTS_C_STANDARD)
    if(NOT SUPPORTS_C_STANDARD)
      cc_log_append(${LOGID} "Current compiler '${current_compiler}' does not support C standard ${required_standard}. Please check your compiler or upgrade.")
      set(${RESULT_VAR} FALSE PARENT_SCOPE)
      return()
    else()
      cc_log_append(${LOGID} "CMAKE_C_STANDARD is not set. Consider setting CMAKE_C_STANDARD=${required_standard} or adding the compiler flag '${flag}'.")
    endif()
  elseif(CMAKE_C_STANDARD AND c_standard_condition)
    list(GET c_standard_condition 0 operator)
    list(GET c_standard_condition 1 required_standard)
    if(NOT CMAKE_C_STANDARD ${operator} required_standard)
      cc_log_append(${LOGID} "C standard '${CMAKE_C_STANDARD}' does not meet condition: ${operator} ${required_standard}")
      set(${RESULT_VAR} FALSE PARENT_SCOPE)
      return()
    endif()
  endif()

  if(NOT CMAKE_CXX_STANDARD AND cxx_standard_condition)
    list(GET cxx_standard_condition 1 required_standard)
    set(flag "-std=c++${required_standard}")
    include(CheckCXXCompilerFlag)
    check_cxx_compiler_flag("${flag}" SUPPORTS_CXX_STANDARD)
    if(NOT SUPPORTS_CXX_STANDARD)
      cc_log_append(${LOGID} "Current compiler '${current_compiler}' does not support C++ standard ${required_standard}. Please check your compiler or upgrade.")
      set(${RESULT_VAR} FALSE PARENT_SCOPE)
      return()
    else()
      cc_log_append(${LOGID} "CMAKE_CXX_STANDARD is not set. Consider setting CMAKE_CXX_STANDARD=${required_standard} or adding the compiler flag '${flag}'.")
    endif()
  elseif(CMAKE_CXX_STANDARD AND cxx_standard_condition)
    list(GET cxx_standard_condition 0 operator)
    list(GET cxx_standard_condition 1 required_standard)
    if(NOT CMAKE_CXX_STANDARD ${operator} required_standard)
      cc_log_append(${LOGID} "C++ standard '${CMAKE_CXX_STANDARD}' does not meet condition: ${operator} ${required_standard}")
      set(${RESULT_VAR} FALSE PARENT_SCOPE)
      return()
    endif()
  endif()

  foreach(lib IN LISTS required_libraries)
    find_library(LIB_PATH "${lib}")
    if(NOT LIB_PATH)
      cc_log_append(${LOGID} "Required library '${lib}' not found.")
      set(${RESULT_VAR} FALSE PARENT_SCOPE)
      return()
    else()
      cc_log_append(${LOGID} "Library '${lib}' found at: ${LIB_PATH}")
    endif()
  endforeach()

  if(required_platforms AND NOT "${current_platform}" IN_LIST required_platforms)
    cc_log_append(${LOGID} "Platform '${current_platform}' is not supported. Required: ${required_platforms}")
    set(${RESULT_VAR} FALSE PARENT_SCOPE)
    return()
  endif()

  if(required_archs AND NOT "${current_arch}" IN_LIST required_archs)
    cc_log_append(${LOGID} "Architecture '${current_arch}' is not supported. Required: ${required_archs}")
    set(${RESULT_VAR} FALSE PARENT_SCOPE)
    return()
  endif()
endfunction()

set(CC_UNINSTALL_SCRIPT "${CMAKE_BINARY_DIR}/cmake_uninstall.cmake")
set(CC_UNINSTALL_SCRIPT_TEMPLATE "${CMAKE_BINARY_DIR}/cmake_uninstall.cmake.in.txt")
if (NOT EXISTS ${CC_UNINSTALL_SCRIPT_TEMPLATE})
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "if(NOT EXISTS \"@CMAKE_CURRENT_BINARY_DIR@/install_manifest.txt\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "  message(FATAL_ERROR \"Cannot find install manifest: @CMAKE_CURRENT_BINARY_DIR@/install_manifest.txt\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "endif(NOT EXISTS \"@CMAKE_CURRENT_BINARY_DIR@/install_manifest.txt\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "file(READ \"@CMAKE_CURRENT_BINARY_DIR@/install_manifest.txt\" files)\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "string(REGEX REPLACE \"\\n\" \";\" files \"\${files}\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "list(REMOVE_DUPLICATES files)\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "foreach(file \${files})\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "  message(STATUS \"Uninstalling \$ENV{DESTDIR}\${file}\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "  if(IS_SYMLINK \"\$ENV{DESTDIR}\${file}\" OR EXISTS \"\$ENV{DESTDIR}\${file}\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "    execute_process(\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "      COMMAND @CMAKE_COMMAND@ -E remove \"\$ENV{DESTDIR}\${file}\"\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "      OUTPUT_VARIABLE rm_out\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "      RESULT_VARIABLE rm_retval\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "    )\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "    if(NOT \"\${rm_retval}\" EQUAL 0)\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "      message(FATAL_ERROR \"Problem when removing \$ENV{DESTDIR}\${file}\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "    endif(NOT \"\${rm_retval}\" EQUAL 0)\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "    set(stop_dir \"\$ENV{DESTDIR}@CMAKE_INSTALL_PREFIX@\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "    get_filename_component(current_dir \"\$ENV{DESTDIR}\${file}\" DIRECTORY)\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "    while(1)\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "      if(\${current_dir} STREQUAL \${stop_dir})\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "        break()\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "      endif()\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "      if(NOT IS_DIRECTORY \"\${current_dir}\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "        break()\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "      endif()\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "      file(GLOB dir_entries \"\${current_dir}/*\" \"\${current_dir}/.*\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "      set(actual_entries \"\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "      foreach(entry \${dir_entries})\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "        get_filename_component(_entry_name \"\${entry}\" NAME)\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "        if(NOT _entry_name STREQUAL \".\" AND NOT _entry_name STREQUAL \"..\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "          list(APPEND actual_entries \"\${entry}\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "        endif()\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "      endforeach()\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "      if(actual_entries STREQUAL \"\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "        message(STATUS \"Removing empty directory: '\${current_dir}'\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "        execute_process(\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "          COMMAND \"\${CMAKE_COMMAND}\" -E remove_directory \"\${current_dir}\"\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "          RESULT_VARIABLE rmdir_retval\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "        )\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "        if(NOT \${rmdir_retval} EQUAL 0)\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "          message(STATUS \"Failed to remove '\${current_dir}' - maybe not empty or no permission.\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "          break()\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "        endif()\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "      else()\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "        break()\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "      endif()\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "      get_filename_component(temp_dir \"\${current_dir}\" DIRECTORY)\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "      if(temp_dir STREQUAL \"\${current_dir}\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "        break()\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "      endif()\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "      set(current_dir \"\${temp_dir}\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "    endwhile()\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "  else(IS_SYMLINK \"\$ENV{DESTDIR}\${file}\" OR EXISTS \"\$ENV{DESTDIR}\${file}\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "    message(STATUS \"File \$ENV{DESTDIR}\${file} does not exist.\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "  endif(IS_SYMLINK \"\$ENV{DESTDIR}\${file}\" OR EXISTS \"\$ENV{DESTDIR}\${file}\")\n")
  file(APPEND ${CC_UNINSTALL_SCRIPT_TEMPLATE} "endforeach(file)\n")
endif()

if(NOT TARGET uninstall)
  configure_file("${CC_UNINSTALL_SCRIPT_TEMPLATE}" "${CC_UNINSTALL_SCRIPT}" IMMEDIATE @ONLY)
  add_custom_target(uninstall
    COMMAND ${CMAKE_COMMAND} -P "${CC_UNINSTALL_SCRIPT}"
    COMMENT "Uninstall files listed in install_manifest.txt"
  )
endif()
# cmake-format: on
