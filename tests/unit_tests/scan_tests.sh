#! /bin/bash
# shellcheck disable=SC2155

source ./entrypoint.sh "" "style" "" "" "--test"

# scan_file tests
test_scan_valid_script_with_extension(){
    local expected="Scanning sample.bash"
    local actual=$(scan_file ./test_data/script_type/sample.bash)

    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expected"
}

test_scan_valid_script_without_extension(){
    local expected="Scanning executable_script"
    local actual=$(scan_file ./test_data/test_dir/executable_script)

    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expected" 
}

test_scan_unsupported_script(){
    local expected1="Scanning test.zsh"
    local expected2="ShellCheck only supports sh/bash/dash/ksh scripts. For supported scripts to be scanned, make sure to add a proper shebang on the first line of the script."
    local actual=$(scan_file ./test_data/script_type/test.zsh)

    assertNotContains "Actual messages:$actual contains the message.\n" "$actual" "$expected1" 
    assertNotContains "Actual messages:$actual contains the message.\n" "$actual" "$expected2" 
}

test_scan_external_sourced_file(){
    local actual=$(scan_file ./test_data/test_dir/external_sources.sh)
    local notExpected="SC1091: Not following"
    local expected="Scanning external_sources.sh"

    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expected" 
    assertNotContains "Actual messages:$actual\n contains the unexpected message: '$notExpected'\n" "$actual" "$notExpected"
}

# scan_dir tests
test_scan_a_directory(){
    local message1="Scanning all the shell scripts at ./test_data/script_type"
    local message2="Scanning sample.bash"
    local message3="Scanning test_script_wsh.sh"
    local message4="ShellCheck only supports sh/bash/dash/ksh scripts. For supported scripts to be scanned, make sure to add a proper shebang on the first line of the script."
    local actual_message=$(scan_dir ./test_data/script_type)

    assertContains "Actual messages:$actual_message Did not contain the expected message.\n" "$actual_message" "$message1"
    assertContains "Actual messages:$actual_message Did not contain the expected message.\n" "$actual_message" "$message2"
    assertContains "Actual messages:$actual_message Did not contain the expected message.\n" "$actual_message" "$message3"
    assertNotContains "Actual message:$actual_message contains the message.\n" "$actual_message" "$message4"
}

test_unscanned_files_count(){
    local expected_count=3
    scan_dir ./test_data/script_type > /dev/null
    local actual_count="${#invalid_files[@]}"

    assertEquals  "$expected_count" "$actual_count"
}

source ./tests/shunit2