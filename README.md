# hxproject

Having good compiler services for code editors, such as import suggestions, symbol searching and refactoring
requires using compiler cache to the maximum extent, basically meaning that the project should be periodically
built through the same cache server that is used for display queries.

However, compiler arguments used for building often differ from display arguments, for example:
 * They can contain `--next` and `-cmd` that are no-no for display arguments.
 * They can contain `--macro` calls that are not useful for display features and can break it or slow it down.
 * Most often they only define entry point types for compilation, however for IDE features we would want
   to cache basically everything we have in class paths (and libraries).

Maintaining two sets of arguments is very tedious and not user-friendly, too hard and low-level, especially
for people coming from languages with more developed tooling (e.g. .NET solutions, TypeScript project configs).

What I'd like to propose here is an unified declarative "haxe project" format which would define a single haxe project in such way that tools could use it for both building and providing IDE support, as well different kinds
of processing (linters, formatters, etc).

## Not a build system

This project doesn't aim to unify and replace existing build system for Haxe (moon-run, hxmake, YHaxen and others). What I'd like to achieve is a replacement for hxml files, so one could have a single file that could be used by IDEs to provide their features in a consistent way, and by Haxe to simply compile the output, so this should stay minimalistic and simple. The complex project-specific build systems could then generate a hxproject file as they wish to compile haxe code and enable IDE features.

## Project format

TODO. Things to consider: easy for simple projects, flexible for complex build configurations (release/build, different targets, etc), per-directory overrides? (probably not, but we might want to have "base project file" and a number of actual project files inheriting it).

## Tool

Eventually, if accepted, this format could be supported by the Haxe compiler directly, however it's possible
to write a tool/library that reads the project file and provides necessary compiler command line arguments for
different use-cases (building, indexing, display queries).

TODO. Things to also consider: watching project directories and rebuilding/reindexing automatically.


