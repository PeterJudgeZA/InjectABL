# OpenEdge InjectABL Inversion of Control container/Dependency Injection module #

InjectABL is an Inversion of Control container/Dependency Injection module that was created as part of the [AutoEdge|TheFactory reference implementation](http://communities.progress.com/pcom/community/psdn/openedge/architecture/autoedgethefactory). This project breaks separates the InjectABL module from the larger AutoEdge code, and makes it available for independent use.

The InjectABL IoC component is inspired by, and largely based - conceptually and to a lesser degree code - on the [Ninject](http://wiki.github.com/enkari/ninject) DI container. While many DI/IoC products provide mapping facilities, the majority of them are XML based; Ninject starts with source code-based mappings, which can be extended to use XML. This provides more readability; in addition Ninject has usable defaults, and is relatively simple to use and understand. It is also itself easily extensible.

The [wiki](https://github.com/PeterJudge-PSC/InjectABL/wiki) contains more details.

## Installation/setup ##

This project assumes that it will run against OpenEdge version 11.7.0+.

The project follows a pretty standard Maven layout.

|Folder|Contents|
--- | ---
|`src/main/abl` | Contains the library's sourceABL source code
|`src/main/resources` | Contains non-source-code resources used to compile and/or build
|`src/test/abl` | Contains unit tests. The project uses ABLUnit for unit testing
|`src/test/resources` | Contains non-source-code resources used to build and run unit tests
|`build/**` | Created by the Gradle build; should be considered transient (ie liable to be deleted)
|`build/dist` | Contains the source ZIP and rcode PL files created by the build. These are named `injectabl-<version>-[sources|tty].[zip|pl]` . The ZIP file contains the source code.
|`build/rcode` | Contains the project's compiled rcode (from `src/main/abl`).
|`build/lib/**` | Contains any source code dependencies
|`build/tests` | Contains ABLUnit test results in `results.xml` 

It is built using Gradle. To run the build, run `gradlew` from the project's root directory. The location of an OpenEdge install must be known; this is specified either by using a `DLC` environment variable, or specifying a path in the `gradle.properties` file.

## Running/development ##

To develop in an IDE, make sure that `src/main/abl` is added to `PROPATH` 
To run, either add the rcode PL to `PROPATH`, or add the rcode fodler (`build/rcode`), or to run from source code, add `/src/main/abl`.

