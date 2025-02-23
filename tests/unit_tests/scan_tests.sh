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
    local not_expected1="Scanning test.zsh"
    local not_expected2="ShellCheck only supports sh, bash, dash, and ksh scripts. To ensure your script is scanned correctly, add a proper shebang on the first line or a shell directive on the second line."
    local actual=$(scan_file ./test_data/script_type/test.zsh)

    assertNotContains "Actual messages:$actual contains the message.\n" "$actual" "$not_expected1" 
    assertNotContains "Actual messages:$actual contains the message.\n" "$actual" "$not_expected2" 
}

test_scan_external_sourced_file(){
    local actual=$(scan_file ./test_data/test_dir/external_sources.sh)
    local not_expected="SC1091: Not following"
    local expected="Scanning external_sources.sh"

    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expected" 
    assertNotContains "Actual messages:$actual\n contains the unexpected message: '$not_expected'\n" "$actual" "$not_expected"
}

test_scan_script_with_valid_shell_directive(){
    local expected="Scanning script_with_valid_shell_directive"
    local not_expected="ShellCheck only supports sh, bash, dash, and ksh scripts. To ensure your script is scanned correctly, add a proper shebang on the first line or a shell directive on the second line."
    local actual=$(scan_file ./test_data/script_type/script_with_valid_shell_directive)

    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expected" 
    assertNotContains "Actual messages:$actual\n contains the unexpected message: '$not_expected'\n" "$actual" "$not_expected"
}

# scan_dir tests
test_scan_a_directory(){
    local message1="Scanning all the shell scripts at ./test_data/script_type"
    local message2="Scanning sample.bash"
    local message3="Scanning test_script_wsh.sh"
    local message4="ShellCheck only supports sh, bash, dash, and ksh scripts. To ensure your script is scanned correctly, add a proper shebang on the first line or a shell directive on the second line."
    local actual_message=$(scan_dir ./test_data/script_type)

    assertContains "Actual messages:$actual_message Did not contain the expected message.\n" "$actual_message" "$message1"
    assertContains "Actual messages:$actual_message Did not contain the expected message.\n" "$actual_message" "$message2"
    assertContains "Actual messages:$actual_message Did not contain the expected message.\n" "$actual_message" "$message3"
    assertNotContains "Actual message:$actual_message contains the message.\n" "$actual_message" "$message4"
}

test_unscanned_files_count(){
    local expected_count=4
    scan_dir ./test_data/script_type > /dev/null
    local actual_count="${#invalid_files[@]}"

    assertEquals  "$expected_count" "$actual_count"
}

source ./tests/shunit2