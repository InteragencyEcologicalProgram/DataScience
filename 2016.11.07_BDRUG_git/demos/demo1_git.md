## Introduction

In this demo, we introduce Git: where to download; how to configure; how to initialize a directory; adding a file to our directory; and adding and committing our file to Git. All work herein will down via command line, and we won't be using R or RStudio for this demo.

## Download Git

Downloading Git is straightforward. Click [here](https://git-scm.com/downloads) to get started. Select the appropriate download for your operating system. For now, I suggest accepting all the default installations unless you are familiar with the custom features.

## Configure Git

Given Git's history and origins, you'll likely have to dabble a bit with the command line. Most R users are already familiar with command line programming, but using the Git Bash can take some getting used to (unless you're familiar with Linux or Unix-type commands).

After installation, right-click anywhere on your desktop and select Git Bash (some might say Git Bash Here). At the `$` prompt, type the following lines (start with `git` not the `$`).

> $ git config --global user.name "Your Name Comes Here"  
> $ git config --global user.email you@yourdomain.example.com  

The lines above tell Git who you are. Any "commits" you make will be attributed to you. This especially comes in to play when collaborating (i.e., who made the change, update). Run `git config --list` to confirm successful configuration. Or you can run the lines below.

> $ git config user.name  
> $ git config user.email

You'll perform only once the `git config --global ...` commands. After that Git knows who you are.

## Initialize Directory & First Commit

Right-click in your desktop and select Git Bash. Perform the commands below.

1. git init sampledir
2. cd sampledir
3. echo "my first git file" > firstgit.txt
4. ls -a
5. git add .
6. git commit -m "my first commit"

In the steps above, you just created a new git repository (directory, named "sampledir"). Switched to that directory (cd = change directory). Added a file with a bit of text. Listed all the files in your new directory. Added (or staged) all files to Git. And finally, commited all files to Git.

## Act 2: Second Commit

In this section we'll change the text in our firstgit.txt file. We'll still use the command line, so perform the commands below after right-clicking in your desktop.

1. cd sampledir
2. vi firstgit.txt

A new window will appear. Your text will likely appear at the top of this new window. You should see the text "my first git file." Perform the commands below. Note: vi is a text editor and --- though it looks funky --- will allow you to make changes in your text file. Alternatively, you could open firstgit.txt, make the change, and then continue with step 1 in the next section (git diff).

1. Press i
2. Use the delete key to remove all text
3. Type: I am changing this text!
4. Press <Esc> then colon (you should be at a colon prompt at the bottom of the window)
5. Type: exit (you return to the first window)

You have changed the text in file firstgit.txt. We still need to add and then commit this change.

1. git diff (will show difference between master and branch)
2. git add firstgit.txt
3. git commit -m "changed text for demo"
4. git log -p (press return until you see (END), and then type q)
5. gitk

We made a change to our file and committed the change. We used git log -p or gitk to view our changes.
