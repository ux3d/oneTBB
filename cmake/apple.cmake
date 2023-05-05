function(make_framework)
    if (APPLE)
        set(options)
        set(oneValueArgs TARGET VERSION IDENTIFIER)
        set(multiValueArgs PUBLIC_HEADER)
        cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

        # Shared libraries should be frameworks on macOS
        get_target_property(type ${ARG_TARGET} TYPE)
        if (${type} STREQUAL "SHARED_LIBRARY")
            gather_frameworks(used_frameworks TARGETS ${ARG_TARGET})

            set_target_properties(${ARG_TARGET} PROPERTIES
                FRAMEWORK TRUE
                FRAMEWORK_VERSION C
                MACOSX_FRAMEWORK_IDENTIFIER ${ARG_IDENTIFIER}
                # "current version" in semantic format in Mach-O binary file
                VERSION ${ARG_VERSION}
                # "compatibility version" in semantic format in Mach-O binary file
                SOVERSION ${ARG_VERSION}
            )
        endif()

        set_target_properties(${ARG_TARGET} PROPERTIES
            XCODE_ATTRIBUTE_SKIP_INSTALL YES # Frameworks should generally skip the install
            PUBLIC_HEADER "${ARG_PUBLIC_HEADER}"
            # XCODE_LINK_BUILD_PHASE_MODE KNOWN_LOCATION
            XCODE_EMBED_FRAMEWORKS "${used_frameworks}"
            XCODE_EMBED_FRAMEWORKS_CODE_SIGN_ON_COPY      TRUE
            XCODE_EMBED_FRAMEWORKS_REMOVE_HEADERS_ON_COPY TRUE
        )
    endif()
endfunction()
