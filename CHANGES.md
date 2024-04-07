# Changes since latest release

# Changes in 0.5.0

-   Add Python script for test matrix

-   Support cross platform testing

-   Optimize Python script

-   Update to latest checkout action

-   Update to latest gh-release action

-   Update to latest artifact actions

# Changes in 0.4.0

-   Add script to detect workspaces

-   Make release workspace aware

-   Add script to decide whether publish is necessary

    Not all workspaces will be needed to be published on every release. The
    workspaces that have not changed should be skipped in this case.

-   Skip unchanged workspaces

-   Run release on main branches, not on tags

    When using multiple workspaces, tehre can be many tags at once. However,
    GitHub will not run if there are more than three tags at once. It will
    however run once for the main branch, so use that to determine which
    components to publish.

-   Handle case where changelog is not found

# Changes in 0.3.0

-   Optionally support cargo check and clippy

-   Optionally check cargo-fmt in tests

# Changes in 0.2.0

-   Support a preparation script before building

-   Do not fail release without artifacts

    If the build failed, there will be no artifacts. Even then, create a
    release for the tag!

-   Do not create checksums if no artifacts exist

-   Support additional test arguments

# Changes in 0.1.1

-   Don't fail on compiling existing releases

    Existing releases might not be able to be compiled for all targets. If
    this is the case, just ignore failed builds and continue with the
    successful ones.

# Changes in 0.1.0

Initial release.
