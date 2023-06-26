# Home

Holds my home directory and accompanying dotfiles as a Git repository.

## Initial setup

To install into a new home, take the following steps:

- Set up the staging directory.

    ```bash
    name=MACHINE_NAME
    cd ~
    git clone https://github.com/abhinav/home home-int
    (cd home-int && git checkout -b $name)
    ```

- Turn `$HOME` into a Git repository.

    ```bash
    cd ~
    git init -b $name
    ```

- Check out the repository in `$HOME`
  without adding the staging repository as a remote.
  Resolve any conflicts.

    ```bash
    git fetch ~/home-int
    git reset FETCH_HEAD
    ```

- Add `$HOME` as a remote to the staging repository.

    ```bash
    cd home-int
    git remote add local ~
    git fetch local
    ```

## Machine-specific setup

Install [GNU Stow](https://www.gnu.org/software/stow/)
and inside the stow/ directory, run:

```bash
stow $system
```

Where `$system` is the kind of system.
