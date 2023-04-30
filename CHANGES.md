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
