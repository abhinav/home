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

- Set up hooks to be able to push to `$HOME`.

    ```bash
    ~/home-int/etc/git-setup-checkout-push/setup.sh
    ```

## Machine-specific setup

Install [GNU Stow](https://www.gnu.org/software/stow/)
and inside the sys/ directory, run:

```bash
cd sys
stow $system
```

Where `$system` is the kind of system.

## License

This repository contains just configurations and accompanying scripts
and is not likely to be useful enough to others for the license to be relevant.

However, to keep it easy in case any snippet of code in this repository is of
value to anyone else, the contents of this repository are licensed under the
MIT license.

```
Copyright © 2023 Abhinav Gupta

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
