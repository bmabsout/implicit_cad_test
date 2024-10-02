#!/usr/bin/env bash

# Start fstl and store its PID
fstl render.stl &
FSTL_PID=$!

# Function to clean up processes
cleanup() {
    echo "Cleaning up..."
    kill $FSTL_PID
    exit 0
}

# Set up trap to catch SIGINT (Ctrl+C)
trap cleanup SIGINT

exec 3> >(ghci)
inotifywait -r -m -e close_write . | 
    while read file_path file_event file_name; do
        if [[ $file_name =~ ^.*\.hs$ ]]; then # we need check if it also has a main
            echo ${file_path}${file_name} event: ${file_event}
            # runhaskell -- -XLambdaCase -XPatternSynonyms -XTemplateHaskell -XTypeFamilies -XPartialTypeSignatures -XRecordWildCards ${file_path}${file_name}
            # runhaskell ${file_path}${file_name}
            echo ":l ${file_path}${file_name}" >&3
            echo "main" >&3
            echo "Success"
        fi
    done