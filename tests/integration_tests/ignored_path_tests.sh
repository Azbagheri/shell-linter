#! /bin/bash
# shellcheck disable=SC2155

source ./entrypoint.sh "" "" "" "" "--test"

test_ignore_directories(){
    local exclude_paths="test_dir,severity_mode"
    local actual_message=$(process_input)
    local message1="Scanning example_script.sh"
    local message2="Scanning test_script_info.sh"
    local expected1="Scanning test_script_wsh.sh"
    
    assertNotContains "Actual message:$actual_message contains the message.\n" "$actual_message" "$message1"
    assertNotContains "Actual message:$actual_message contains the message.\n" "$actual_message" "$message2"
    assertContains "Actual messages:$actual_message Did not contain the expected message.\n" "$actual_message" "$expected1"
}

test_ignore_files(){
    local input_paths="./test_data/script_type"
    local exclude_paths="script_type/test.zsh,script_type/test_script.js,script_type/test_zsh_wsh,script_type/test_python,script_type/test_script_wosh.sh"
    local actual_message=$(process_input)
    local expected1="Scanning sample.bash"
    local expected2="Scanning test_script_wsh.sh"
    local notExpected="ShellCheck only supports sh/bash/dash/ksh scripts. For supported scripts to be scanned, make sure to add a proper shebang on the first line of the script."

    assertContains "Actual messages:$actual_message Did not contain the expected message.\n" "$actual_message" "$expected1"
    assertContains "Actual messages:$actual_message Did not contain the expected message.\n" "$actual_message" "$expected2"
    assertNotContains "Actual message:$actual_message contains the message.\n" "$actual_message" "$notExpected"
}

test_ignore_file_and_directory(){
    local exclude_paths="script_type,severity_mode,test_dir/invalid_script"
    local actual_message=$(process_input)
    local expected1="Scanning example_script.sh"
    local expected2="Scanning executable_script"
    local notExpected="ShellCheck only supports sh/bash/dash/ksh scripts. For supported scripts to be scanned, make sure to add a proper shebang on the first line of the script."

    assertContains "Actual messages:$actual_message Did not contain the expected message.\n" "$actual_message" "$expected1"
    assertContains "Actual messages:$actual_message Did not contain the expected message.\n" "$actual_message" "$expected2"
    assertNotContains "Actual message:$actual_message contains the message.\n" "$actual_message" "$notExpected"
}

tearDown(){
   input_paths="" 
   invalid_files=()
}
source ./tests/shunit2
