# Shell Linter

[![Release](https://img.shields.io/github/release/Azbagheri/shell-linter.svg)](https://github.com/Azbagheri/shell-linter/releases)
[![Marketplace](https://img.shields.io/badge/GitHub-Marketplace-red.svg)](https://github.com/marketplace/actions/shell-linter)
[![Actions Status](https://github.com/Azbagheri/shell-linter/workflows/CI-workflow/badge.svg)](https://github.com/Azbagheri/shell-linter/actions?query=branch%3Adevelop)


A GitHub Action that performs static analysis for shell scripts using [ShellCheck](https://github.com/koalaman/shellcheck).

![](docs/images/preview.png)

## 🚨 Repository Transferred – Manual Update Required  

This repository has moved from **`azohra/shell-linter`** to **`Azbagheri/shell-linter`**.  

❗ **Important:** Contrary to our understanding, GitHub is NOT automatically redirecting workflows. You must manually update your YAML configuration:  

```diff
- uses: azohra/shell-linter@latest
+ uses: Azbagheri/shell-linter@latest 
```

We sincerely apologize for any inconvenience this has caused.
<br>

# Usage

Shell Linter can perform static analysis in various ways. By default it scans all the ShellCheck-supported shell scripts (sh/bash/dash/ksh) in your project. However, you can use the `path` parameter to scan a specific file or folder or use the `exclude-paths` parameter to exclude files or folders from the scan. With Shell Linter, you can also specify the minimum severity of errors to consider using the `severity` parameter. Specific use cases along with examples are shown below:

#### Run static analysis for all the supported shell scripts in your repository:
```yml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      - name: Run ShellCheck
        uses: Azbagheri/shell-linter@latest
```

#### Run static analysis for a single shell script:
```yml
      - name: Run ShellCheck
        uses: Azbagheri/shell-linter@latest
        with:
          path: "setup.sh"
```

#### Run static analysis for multiple shell scripts **with or without** extension:
```yml
      - name: Run ShellCheck
        uses: Azbagheri/shell-linter@latest
        with:
          path: "setup,deploy.sh"
```

#### Run static analysis for all the shell scripts in a folder:
```yml
      - name: Run ShellCheck
        uses: Azbagheri/shell-linter@latest
        with:
          path: "src"
```

#### Run static analysis using a **wildcard** path:
```yml
      - name: Run ShellCheck
        uses: Azbagheri/shell-linter@latest
        with:
          path: "src/*.sh"
```
#### Exclude files and folders from the static analysis:
```yml
      - name: Run ShellCheck
        uses: Azbagheri/shell-linter@latest
        with:
          exclude-paths: "src/setup.sh,tests/unit_tests" 
```
Note that `exclude-paths` only accepts paths relative to your project's root directory. However, **do not** include `./` at the beginning of the paths. 

To exclude a folder and it's content recursively just provide the path of the folder **without** a `/` at the end. In the example above, the entire folder at the path `tests/unit_tests` will be excluded from linting.

#### Run static analysis for all the shell scripts and only report issues with error severity while excluding specific issues:
```yml
      - name: Run ShellCheck
        uses: Azbagheri/shell-linter@latest
        with:
          path: "src/*.sh"
          severity: "error"
          exclude-issues: "SC1068,SC1066"
```
Note that `exclude-issues` contains a comma-separated list of ShellCheck issues (example: "SC1068") to ignore.

#### Run analysis by using a specific version of Shell Linter:
```yml
      - name: Run ShellCheck
        uses: Azbagheri/shell-linter@v0.7.0
```

# Input

### `exclude-issues`
Optional. Specify shellcheck issues to exclude during scan. For more information refer to [Checks](https://github.com/koalaman/shellcheck/wiki/Checks). Default: scan all issues.

### `exclude-paths`
Optional. Exclude files and folders from ShellCheck scan. 

### `path`
Optional. Execute lint check on a specific file or folder. Default: `.`

### `severity`
Optional. Specify minimum severity of errors to consider [style, info, warning, error]. Default: `style`

# License
This software is available as open source under the terms of the MIT License.

