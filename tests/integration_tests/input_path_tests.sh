#! /bin/bash
# shellcheck disable=SC2155

source ./entrypoint.sh "" "" "" "" "--test"

test_execution_mode(){
    local expected_path=./test_data
    process_input > /dev/null
    local actual_path=$my_dir

    assertEquals "ERROR: Values did not match." "$expected_path" "$actual_path"
}

test_invalid_script_with_extension(){
    input_paths="./test_data/script_type/test_script.js"
    local expected1="Found 1 unscanned files that could potentially be supported"
    local expected2="ShellCheck only supports sh/bash/dash/ksh scripts. For supported scripts to be scanned, make sure to add a proper shebang on the first line of the script."
    local actual=$(process_input)

    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expected1" 
    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expected2" 
}

test_invalid_script_without_extension(){
    input_paths="./test_data/script_type/test_python"
    local expected1="Found 1 unscanned files that could potentially be supported"
    local expected2="ShellCheck only supports sh/bash/dash/ksh scripts. For supported scripts to be scanned, make sure to add a proper shebang on the first line of the script."
    local actual=$(process_input)

    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expected1"
    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expected2"
}

test_unsupported_script_without_extension(){
    input_paths="./test_data/script_type/test_zsh_wsh"
    local expect1="Found 1 unscanned files that could potentially be supported"
    local expect2="ShellCheck only supports sh/bash/dash/ksh scripts. For supported scripts to be scanned, make sure to add a proper shebang on the first line of the script."
    local actual=$(process_input)

    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expect1"
    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expect2"
}

test_unsupported_script_with_extension(){
    input_paths="./test_data/script_type/test.zsh"
    local expect1="Found 1 unscanned files that could potentially be supported"
    local expect2="ShellCheck only supports sh/bash/dash/ksh scripts. For supported scripts to be scanned, make sure to add a proper shebang on the first line of the script."
    local actual=$(process_input)

    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expect1"
    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expect2"
}

test_valid_file_without_shebang(){
    input_paths="./test_data/script_type/test_script_wosh.sh"
    local expected1="Found 1 unscanned files that could potentially be supported"
    local expected2="ShellCheck only supports sh/bash/dash/ksh scripts. For supported scripts to be scanned, make sure to add a proper shebang on the first line of the script."
    local actual=$(process_input)

    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expected1" 
    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expected2"
}

test_valid_file_input(){
    input_paths="./test_data/test_dir/example_script.sh"
    local expected="Scanning example_script.sh"
    local actual=$(process_input)

    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expected"
}

test_default_input_file(){
    input_paths="."
    local expected_expect="Scanning all the shell scripts at ./test_data"
    local actual=$(process_input)

    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expected_expect"
}

test_input_directory(){
    input_paths="./test_data/test_dir"
    local expect1="Scanning all the shell scripts at ./test_data/test_dir"
    local expect2="Scanning example_script.sh"
    local expect3="Scanning executable_script"
    local expect4="Found 1 unscanned files that could potentially be supported"
    local actual=$(process_input)

    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expect1"
    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expect2"
    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expect3"
    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expect4"
}

test_multiple_input_directories(){
    input_paths="./test_data/test_dir,./test_data/script_type"
    local expected1="Scanning all the shell scripts at ./test_data/test_dir"
    local expected2="Scanning all the shell scripts at ./test_data/script_type"
    local actual=$(process_input)

    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expect1"
    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expected2"
}

test_input_files_with_wildcard() {
    input_paths="./test_data/script_type/test*.sh"
    local expected1="Scanning test_script_wsh.sh"
    local expected2="Found 1 unscanned files that could potentially be supported"
    local actual=$(process_input)
    
    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expected1"
    assertContains "Actual messages:$actual Did not contain the expected message.\n" "$actual" "$expected2"
}

tearDown(){
   input_paths="" 
   invalid_files=()
}
source ./tests/shunit2