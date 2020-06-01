# Setting up

To install in a new home:

```shell
$ name=MACHINE_NAME
$ cd ~

# Set up local home-int for this machine.
$ git clone github.com/abhinav/dotfiles home-int
$ (cd home-int && git checkout -b $name)

# Set up $HOME.
$ git init
$ git remote add origin ~/home-int
$ git fetch home-int

# Install in $HOME.
$ git checkout -f -b $name origin/$name
$ git remote rm origin

# Set up push-to-$HOME.
$ git setup-worktree-push
$ cd home-int && \
	git remote add local ~ && \
	git push -u local $name
```
