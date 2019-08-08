## Introduction 

Here, we'll show how to use Git from within RStudio. We'll create a simple text file, and --- like we did in demo 1 --- we'll add & commit this file to Git. If time allows, we'll make changes to our file, add and then commit, and then note the difference between our first & second commits.

## Git within RStudio

RStudio has some easy-to-use features for using Git. It helps --- especially when working remotely (i.e., GitHub) --- to create your work within a project (as in *.Rproj). Though, this is not totally necessary.

First, we need to tell RStudio the file path of the git.exe we downloaded.

1. Within RStudio select Tools --> Global Options...
2. Select Git/SVN  
   <img src="pics/GitScreenshot.png" alt="Commit" height="300" width="300">
3. Click Browse in the Git executable section, and find your installed git.exe file
4. Click OK (you may need to restart RStudio)

## New Project

We'll now create a new (empty) project with a git repository.

1. File --> New Project...
2. Select New Directory
3. Select Empty Project
4. Give the directory a name (e.g., TestGitHub) & check the box to the left of "Create a git repository"

## New File

Create a simple text file in your new project.

1. In the text file type "this is sample text"
2. Save the file
3. Switch to the Git tab (likely next to Environment or History tabs)
4. You should see your text file (with the letter 'A' next to it)
5. Click the box under "Staged"
6. Click the "Commit" button (should see something like below)  
   <img src="pics/CommitScreenshot.png" alt="Commit" height="300" width="300"> 
7. Type a message in the "Commit message" area
8. Press Commit

<!-- TODO: continue here with changing text -->
