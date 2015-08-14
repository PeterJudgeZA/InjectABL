OpenEdge InjectABL Inversion of Control container/Dependency Injection module
===============================================================================
InjectABL is an Inversion of Control container/Dependency Injection module that was created as part of the [AutoEdge|TheFactory reference implementation](http://communities.progress.com/pcom/community/psdn/openedge/architecture/autoedgethefactory). This project breaks separates the InjectABL module from the larger AutoEdge code, and makes it available for independent use.

The InjectABL IoC component is inspired by, and largely based - conceptually and to a lesser degree code - on the [Ninject](http://wiki.github.com/enkari/ninject) DI container. While many DI/IoC products provide mapping facilities, the majority of them are XML based; Ninject starts with source code-based mappings, which can be extended to use XML. This provides more readability; in addition Ninject has usable defaults, and is relatively simple to use and understand. It is also itself easily extensible.

The [wiki](https://github.com/PeterJudge-PSC/InjectABL/wiki) contains more details.

Installation/setup
====================
This project assumes that it will run against OpenEdge version 11.4.0+. There are some dependencies on source (includes) which require the extraction of the source code contained in the OpenEdge.Core.pl library. To do so, open ProEnv and cd to the OpenEdge install, using `cd %dlc%\src` . Now extract the code using `extractpl OpenEdge.Core.pl`. Note that in 11.5 this results in a error, and you will need to create some missing folders first: `mkdir OpenEdge\Core\Assertion`. Now run the `extractpl` command and you should be all set.

You will also need to add the root `/src` and (possibly) `/bin` folders to your propath in order to use InjectABL.
