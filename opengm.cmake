#
# Install opengm libraries from source
#

if (NOT opengm_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

external_git_repo (opengm
    576dc472324a5dce40b7e9bb4c270afbd9b3da37
    https://github.com/opengm/opengm)

if(CPLEX_ROOT_DIR)
    set(CMAKE_CPLEX_ROOT_DIR "-DCPLEX_ROOT_DIR=${CPLEX_ROOT_DIR}")
endif()

message ("Installing ${opengm_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${opengm_NAME}
    DEPENDS             ${boost_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${opengm_URL}
    GIT_TAG             ${opengm_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${BUILDEM_ENV_STRING} ${PATCH_EXE}
			# This patch disables linking against the rt-lib on Mac for the combilp test
			${opengm_SRC_DIR}/src/unittest/inference/CMakeLists.txt ${PATCH_DIR}/opengm-toggle-rt.patch

    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${opengm_SRC_DIR} 
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
        -DCMAKE_CXX_FLAGS=${BUILDEM_ADDITIONAL_CXX_FLAGS}
        -DWITH_CPLEX=ON
        -DWITH_BOOST=ON
        ${CMAKE_CPLEX_ROOT_DIR}

    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
    TEST_COMMAND        ${BUILDEM_ENV_STRING} $(MAKE) test
)

set_target_properties(${opengm_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT opengm_NAME)
