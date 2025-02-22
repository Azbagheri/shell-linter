#! /bin/bash

source ./entrypoint.sh "" "" "" "" "--test"

test_severity_mode_invalid(){
    input_paths="./test_data/severity_mode/test_script_warning.sh"
    severity_mode="verbose"
    local expected_message1="Warning: unknown severity mode. Defaulting severity mode to style."
    local expected_message2="SC2143"
    local actual_message=$(process_input)

    assertContains "Did not find the message." "$actual_message" "$expected_message1"
    assertContains "Did not find the message." "$actual_message" "$expected_message2"
}

test_severity_mode_error(){
    input_paths="./test_data/severity_mode/test_script_error.sh"
    severity_mode="error"
    local expected_message="SC1050"
    local actual_message=$(process_input)

    assertContains "Did not find the message." "$actual_message" "$expected_message"
}

test_severity_mode_no_error(){
    input_paths="./test_data/severity_mode/test_script_no_error.sh"
    severity_mode="error"
    local expected_message="Successfully scanned"
    local actual_message=$(process_input)

    assertContains "Did not find the message." "$actual_message" "$expected_message"
}

test_severity_mode_warning(){
    input_paths="./test_data/severity_mode/test_script_warning.sh"
    severity_mode="warning"
    local expected_message="SC2053"
    local actual_message=$(process_input)

    assertContains "Did not find the message." "$actual_message" "$expected_message"
}

test_severity_mode_info(){
    input_paths="./test_data/severity_mode/test_script_info.sh"
    severity_mode="info"
    local expected_message="SC2035"
    local actual_message=$(process_input)

    assertContains "Did not find the message." "$actual_message" "$expected_message"
}

test_severity_mode_style(){
    input_paths="./test_data/severity_mode/test_script_style.sh"
    severity_mode="style"
    local expected_message="SC2005"
    local actual_message=$(process_input)

    assertContains "Did not find the message." "$actual_message" "$expected_message"
}

source ./tests/shunit2
