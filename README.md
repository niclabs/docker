#Docker
Repositoy to store Dockerfiles for Niclabs projects

# Projects
* ```adkintunmobile/```: Adkintun Mobile is an Android application project for monitoring QoS on mobile network. For more information, visit the repository [here](https://www.github.com/niclabs/adkintunmobile)
* ```ratadns/```: RaTA DNS is a real time analytics project for DNS servers. Visit the repository [here](https://www.github.com/niclabs/ratadns).
* ```tchsm/``` [github.com/niclabs/tchsm](https://www.github.com/niclabs/tchsm)

# Contributing
This repository is intended to contain only Dockerfiles and instructions related to its use.
Place your Dockerfiles and related files at `/project_name/ ` 

## How to do the Dockerfile?
We are following some simple conventions to make the dockerfiles to look alike among them.
### Miscellaneous
1. When listing, several dependencies for instance, use one line per item, this make easier to see the diff among versions.
2. Also when listing, follow an alphabetical order if possible. This make quicker to find something specific when searching.

### Structure
1. Header:
  1. *From*: You MUST have one docker from a specified version (FROM debian:**8**), you might use **latest** version but only if you have a fixed version of the same docker. This is intended to keep at least one version tested all the time.
  2. *Maintainer*: Include a maintainer.
2. [Dependencies]:
  1. *Binary*: Install first the binary dependencies, and among them, start by the ones included in packages by the host OS. Use one line per dependency, this makes easier to see diff among versions.
  2. *Source*: After binary dependencies install the ones not available as packages or binaries and requires compilation or other process. Again, keep them in separate lines.
3. [Configuration]:
  1. At this step, change configurations, copy needed files, etc.. This usually is very project-dependent, so it might be confusing for someone outside the project, add as many comments as posible to make it clear.
4. [Clean Up]:
  1. There might be dependencies only needed at compile-time, the compiler is a classic example. Remove all dependencies not needed at run-time at this step. This keep the image smaller and removing the compiler in a production system is always a good idea.
5. [Run command].

### Example:
For reference or to use it as template you can see the following file.
* [Dockerfile example] (https://github.com/niclabs/docker/blob/master/ratadns/gopher/Dockerfile)

### Useful links:
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/ "Reference")

* [Docker best practices](http://crosbymichael.com/dockerfile-best-practices.html "Best Practices")

* [Refactoring Dockerfiles for Image size](https://blog.replicated.com/2016/02/05/refactoring-a-dockerfile-for-image-size/)
 
