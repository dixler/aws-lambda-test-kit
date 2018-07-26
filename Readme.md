# Overview
This is a small toolkit for testing lambdas locally in CLI.
I noticed that my eyes would get very strained from trying to code in a browser 
and would rather code in my native environment. The lambda assets are stored in the source folder 
and are built into a deployment package right before we launch terraform and are then removed right 
after to reduce clutter. There are some pretty gross build scripts inside of the makefile so if 
anyone wants to contribute, go for it!

## dependencies on
- aws config being set up
- terraform
- awscli
- zip
- make(I just like being able to type make in most of my projects and know that a build job is going)
