#! /bin/bash

source ./entrypoint.sh "" "" "" "" "--test"

test_exclude_no_error(){
    input_paths="./test_data/exclude_issues/test_script_exclude_none.sh"
    severity_mode="style"
    exclude_issues=""
    local expected_error="SC2154"
    local actual_message=$(process_input)

    assertContains "Actual messages:$actual_message Did not find the message.\n" "$actual_message" "$expected_error"
}

test_exclude_one_error(){
    input_paths="./test_data/exclude_issues/test_script_exclude_one_error.sh"
    severity_mode="style"
    exclude_issues="SC2283"
    local expected_error="SC3037"
    local not_expected_error="SC2283"
    local actual_message=$(process_input)

    assertContains "Actual messages:$actual_message Did not find the message.\n" "$actual_message" "$expected_error"
    assertNotContains "Actual messages:$actual_message contains the message.\n" "$actual_message" "$not_expected_error"
}

test_exclude_multiple_errors(){
    input_paths="./test_data/exclude_issues/test_script_exclude_multiple_errors.sh"
    severity_mode="style"
    exclude_issues="SC1017,SC2281,SC2034,SC2154,SC2005"
    local expected_message="Successfully scanned"
    local actual_message=$(process_input)

    assertContains "Actual messages:$actual_message Did not find the message.\n" "$actual_message" "$expected_message"
}

source ./tests/shunit2
