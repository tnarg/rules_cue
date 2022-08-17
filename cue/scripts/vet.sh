#!/usr/bin/env bash

set -e

function main() {
    ROOTMOST_SCHEMA_ZIPFILE="%ROOTMOST_SCHEMA_ZIPFILE%"
    ROOTMOST_SCHEMA_MANIFEST=$(zipinfo -1 "${ROOTMOST_SCHEMA_ZIPFILE}")
    ROOTMOST_SCHEMA_MANIFEST_LINE_COUNT=$(echo "${ROOTMOST_SCHEMA_MANIFEST}" | wc -l | python3 -c "import sys; print(sys.stdin.read().strip(), end='')")
    if [ "$ROOTMOST_SCHEMA_MANIFEST_LINE_COUNT" -ne "1" ]; then
        echo "Schema for vetting should be a single .cue file, but the specified schema included more than one file in its zip archive:"
	echo "${ROOTMOST_SCHEMA_MANIFEST}"

	exit 1
    fi
    CUE_SCHEMA_FILENAME=$(echo "${ROOTMOST_SCHEMA_MANIFEST}" | python3 -c "import sys; print(sys.stdin.read().strip().split('/')[-1], end='')")

    local EXECROOT_PATH="$(head -1 %ROOT_DIR_FILE%)/execroot/${TEST_WORKSPACE}"

    ZIPFILES=(%SCHEMA_ZIPFILES%)
    for ZIPFILE in ${ZIPFILES[@]}
    do
        unzip -oq "${ZIPFILE}"
    done
    CUE_SCHEMA_PATH=$(find . -name "${CUE_SCHEMA_FILENAME}" | tr '\n' ' ')
    CUE_BINARY="${EXECROOT_PATH}/%CUE_EXECUTABLE%"

    # Run cue vet ... <schema>
    #
    $CUE_BINARY vet %FILES_TO_VET% ${CUE_SCHEMA_PATH}
    FILES_TO_VET=(%FILES_TO_VET%)
    for FILE_TO_VET in ${FILES_TO_VET[@]}
    do
        echo "Vetted ${FILE_TO_VET} successfully."
    done
}

main "$@"
