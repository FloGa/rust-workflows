# rust-workflows

Some helper scripts and workflows for my Rust projects.

## Word of warning

The scripts and workflows in this repository are mostly tied to my own projects, and they might rely on quirks that
only I do.

**Please do not blindly use them in your projects unless you read the code carefully and understand what it does!**

In some uncertain future I might polish it up to make it more generic and actually usable for others. Until then, use it
with extreme care!

## Usage

For my usual projects, I need the following workflow files in each repository. Also, I need to configure a
secret `CRATES_IO_TOKEN`, with the API token from `crates.io`.

<details>

<summary><code>.github/targets.json</code></summary>

Incompatible or unwanted targets can be removed.

```json
[
  { "os": "ubuntu-latest", "target": "aarch64-unknown-linux-gnu" },
  { "os": "ubuntu-latest", "target": "arm-unknown-linux-gnueabihf" },
  { "os": "ubuntu-latest", "target": "i686-unknown-linux-gnu" },
  { "os": "ubuntu-latest", "target": "i686-unknown-linux-musl" },
  { "os": "ubuntu-latest", "target": "x86_64-unknown-linux-gnu" },
  { "os": "ubuntu-latest", "target": "x86_64-unknown-linux-musl" },

  { "os": "macos-latest", "target": "x86_64-apple-darwin" },

  { "os": "windows-latest", "target": "i686-pc-windows-msvc" },
  { "os": "windows-latest", "target": "x86_64-pc-windows-msvc" }
]
```

</details>

<details>

<summary><code>.github/prepare-system</code></summary>

Optional script to set up the system before building. This is required if some dependencies are needed for compiling.
The first argument will be the operating system name.

```shell
#!/bin/bash

# EXAMPLE! This will install FUSE libraries before compiling.

case "$1" in
    macos-latest)
        brew update
        brew install macfuse
        ;;
    ubuntu-latest | *)
        sudo apt-get -y update
        sudo apt-get -y install libfuse3-dev
        ;;
esac
```

</details>

<details>

<summary><code>.github/workflows/release.yml</code></summary>

```yaml
name: Release

on:
  push:
    branches:
      - main
      - master
      - 'hotfix/**'
      - 'release/**'

  workflow_dispatch:

jobs:
  test:
    uses: ./.github/workflows/test.yml
    # with:
    #   test-args: -- --include-ignored # optional

  call-release-workflow:
    uses: FloGa/rust-workflows/.github/workflows/release.yml@0.4.0
    with:
      targets-config: ./.github/targets.json
      # system-preparation: ./.github/prepare-system # optional
    secrets:
      CRATES_IO_TOKEN: ${{ secrets.CRATES_IO_TOKEN }}
    needs:
      - test
```

</details>

<details>

<summary><code>.github/workflows/release_existing_tags.yml</code></summary>

```yaml
name: Release existing tags

on:
  workflow_dispatch:

jobs:
  call-release-exisiting-workflow:
    uses: FloGa/rust-workflows/.github/workflows/release_existing_tags.yml@0.4.0
    with:
      targets-config: ./.github/targets.json
      # system-preparation: ./.github/prepare-system # optional
```

</details>

<details>

<summary><code>.github/workflows/test.yml</code></summary>

```yaml
name: Test

on:
  pull_request:

  push:
    branches:
      - develop
      - 'feature/**'

  workflow_call:
    inputs:
      test-args:
        type: string
        required: false
        description: Additional arguments for "cargo test"

  workflow_dispatch:
    inputs:
      test-args:
        type: string
        required: false
        description: Additional arguments for "cargo test"

jobs:
  call-test-workflow:
    uses: FloGa/rust-workflows/.github/workflows/test.yml@0.4.0
    with:
      run-check: true # optional
      run-clippy: true # optional
      run-fmt: true # optional
      # system-preparation: ./.github/prepare-system # optional
      test-args: --workspace ${{ inputs.test-args }}
      test-on-linux: true # optional, true by default
      test-on-macos: true # optional
      test-on-windows: true # optional
```

</details>
