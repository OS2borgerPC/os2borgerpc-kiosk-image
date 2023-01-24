The documentation is built by Read the Docs automatically, but via the Makefile you can build it locally, fx. for testing
changes.

To build the documentation locally:
1. Install the dependencies for sphinx, which can be done via `just`, once you have that installed:
   ```bash
   just install-deps-ubuntu
   ```
2.
   ```bash
      make html      # or run `make` with no arguments to see other options
   ```
