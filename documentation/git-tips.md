
Commands to clean up local and remote branches once they have been merged can be adding manually with `git config -e --global`
```
[alias]
        cleanup = "!git branch --merged | egrep -v \"(^\\*|master|upstream)\" | xargs git branch -d"
        remotecleanup = "!git branch -r --merged | egrep -v '(^\\*|master|upstream)' | sed 's/origin\\///' | xargs -n 1 git push --delete origin"
```
