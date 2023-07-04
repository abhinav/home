# git-bco

git-bco is a simple Zig program that acts as a shortcut to check out a branch
in a Git repository.

When invoked with a branch name, it behaves like `git checkout`.
When invoked without one, it uses [fzf](https://github.com/junegunn/fzf)
to provide a fuzzy-matching screen of available **local** branches.

## Implementation notes

This functionality can be implemented as a shell script quite easily.
Doing it in Zig as a standalone program tickled me, so I have.
Care was taken to minimize the number of dynamic allocations made.

**Limitations**:
Branch names longer than 256 characters are ignored.
