OpenEdge InjectABL Inversion of Control container/Dependency Injection module
===============================================================================
InjectABL is an Inversion of Control container/Dependency Injection module that was created as part of the [AutoEdge|TheFactory reference implementation](http://communities.progress.com/pcom/community/psdn/openedge/architecture/autoedgethefactory). This project breaks separates the InjectABL module from the larger AutoEdge code, and makes it available for independent use.

There's more information on usage at <http://communities.progress.com/pcom/docs/DOC-105068>.    

What is dependency injection (DI)?
-----------------------------------
The [short and sweet answer](http://jamesshore.com/Blog/Dependency-Injection-Demystified.html) is:
    
>    Dependency injection means giving an object its instance variables
>

Contained in that statement is the statement _"the object does not manage it's instance variables' lifecycles, creation in particular"_.

There are 3 main injection patterns: constructor, method and property injection. We assume that constructor injection is intended for mandatory dependencies, and method and property injection is for optional dependencies.

Another good description of dependency injection is on the [Ninject site](http://wiki.github.com/enkari/ninject/dependency-injection-by-hand).

What's an Inversion of Control (IoC) container?
-----------------------------------------------
While dependency injection means that an object does not manage it's own dependencies' lifecycles, the objects have to come from somewhere: this is an IoC container's purpose. It manages the lifecycles of the injected objects.

Why do we need such a beast? Most examples of dependency injection show reasonably simple examples; in these cases it's easy to see the concepts of injection. However, if we want our DI to scale, we need something to manage the dependencies. This is what the IoC container does, at the simplest level. Wikipedia has [more](http://en.wikipedia.org/wiki/Inversion_of_control), including pros and cons, and further reading. Note that the techniques available to IoC include the injection techniques above.

Coding against interfaces
--------------------------
The reference implementation aims to provide extensible and replaceable components (since one size does not fit all). Coding to an interface is a strategy used to achieve this goal. From Wikipedia,

>    The use of interface allows to implement a programming style called programming against interfaces. The idea behind this is to base the logic one develops on the sole interface definition of the objects one uses and do not make the code depend on the internal details. This allows the programmer the ability to later change the behavior of the system by simply swapping the object used with another implementing the same interface.
>

When a class is coded against interfaces, there's an additional requirement to know which class to instantiate that implements that interface (since an interface cannot be invoked itself). This knowledge will take the form of some kind of mapping from the interface to the concrete class.

This ties nicely into DI, since we can inject the implementing (or concrete) object into the relevant object. Furthermore, since the IoC container manages these injected objects' lifecycle, we have the perfect place to keep the interface mapping information.
InjectABL design

The InjectABL IoC component is inspired by, and largely based - conceptually and to a lesser degree code - on the [Ninject](http://wiki.github.com/enkari/ninject) DI container. While many DI/IoC products provide mapping facilities, the majority of them are XML based; Ninject starts with source code-based mappings, which can be extended to use XML. This provides more readability; in addition Ninject has usable defaults, and is relatively simple to use and understand. It is also itself easily extensible.

Binding
==========
The binding stores the mapping between an interface and a concrete type in InjectABL. Bindings allow us to easily change the objects being injected, to provide the necessary parameters for injection, and to specify conditions under which the bindings are valid.

Modules
---------
Modules are collections of bindings that are loaded into the kernel; multiple modules can (and will typically) be loaded into a single kernel. This allows an application to keep its bindings at an appropriate level of granularity (ie. there aren't accounting bindings mixed together with the infrastructure bindings).

Modules typically inherit from the abstract `OpenEdge.InjectABL.Binding.Modules.InjectionModule` class, which implements `OpenEdge.InjectABL.Binding.Modules.IInjectionModule`. The individual bindings are created (destroyed) when the module is loaded (unloaded) into the kernel.

InjectABL supports the concept of a ModuleLoader which can discover the modules in the application: this may work on some kind of name pattern (e.g. "\*Module.cls").

Note that there's nothing precluding the storage of bindings in JSON, XML or some other data store, such as a database table.

Binding syntax
-----------------
The syntax for binding is defined in the `OpenEdge.InjectABL.Binding.IBindingSyntax` interface, and can be described as below. `<type>` below refers to an instance of `Progress.Lang.Class`. A type is specified since it is the kernel that creates the instance from this type. The binding is not responsible for instantiating the implementation (that's the kernel's job).


The type passed in to the Bind() method is referred to a service in the InjectABL module; this should not be confused with the notion of a service as in SOA.
 
    Bind(<type>)             /* [required] service/interface or concrete class */
      :ToSelf()|To(<type>)   /* [required] concrete class type. ToSelf requires that the binding above be to a concrete type */
     
      :Using(<type>)         /* provider type */
      :InSingletonScope()|InTransientScope()|InAgentScope()|InScope(<type>, <enum>)  /* The lifecycle scope of the object. The InScope() allows for custom scope */
      :OnClientSession()|OnWebSession()|OnServerSession()    /* To which session type this binding applies */
      :Named(<char name>)    /* An instance name for the object */
     
      :WithConstructorArgument(<parameter>)             /* One or more constructor arguments to use. These can be ABL primitives, types or objects */
      :WithPropertyValue(<property name>, <parameter>)  /* One or more properties to set. These can be ABL primitives, types or objects */
      :WithMethodValue(<method name>, <parameter>)      /* One or more method arguments for one or more methods. These can be ABL primitives, types or objects */  
      :When:<condition>      /* One or more conditions conforming to IConditionSyntax */
 
 
 

