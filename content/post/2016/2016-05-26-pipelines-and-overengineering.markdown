+++
layout = "single"
title = "The path to production and overengineering"
date = "2016-05-26"
tags = [
  "pipelines",
  "CD",
  "Builds"
  ]

+++

#### *"The path to production is beset on all sides by the inequity of the good-intentioned selfish and tyrrany of overengineering."* Ezekiel 25:17

The core of many development organizations is a desire to innovate technologically and maintain quality. A key factor of keeping up with the cutting edge is to accelerate development and maximize the productivity of your teams, which is often wrapped in the implementation of a build and deploy pipeline.

Development teams need a pipeline that automatically runs tests, runs builds, maintains artifacts, configures applications, and manages deployments and promotions through their environments. These are the functional requirements of a pipeline. The acceptance criteria are that development is accelerated, and developer and operational experience of deployments are consistent and high quality. Core functionality of the pipeline is ensuring artifacts go from environment to environment reliably and repeatably so that risk is reduced. It is also a powerful tool for maintaining the discipline and health of the project when used properly.

### Scope creep and value propositions

There are other requirements that may creep in such as tracking bugs and releases, integrating operational metrics from the application, adding business metrics around revenue or market events, and tracing quality or other characteristics from their version control system or other sources. These are *nice-to-haves* in the first version of your pipeline and should be summarily sent to the backlog before discussions get too detailed.

Many companies design their pipelines around their development environment, citing specifics about their processes or technologies that require attention. These are technology-based decisions around build systems, testing frameworks, and integration with internal systems of record for releases. I caution that these are considerations for after the pipeline has proven to provide some value.

The value proposition of a pipeline begins to fade into the background as the technical details and toolset of the pipeline are decided upon. This is a slippery slope in any project, but especially toxic in infrastructure projects, where the customers and stakeholders of the project are often ill-defined or self-referential. By this I mean that the needs of internal customers, especially development teams are particularly difficult to extract.

#### *The ideal pipeline is an unopinionated orchestration of independent tools, workflows, and environmental constraints whose output is configured, running software.*

The purpose of a pipeline is to continuously deliver high-quality software. As the complexity of the software or number of components increases, the CI pipeline should reduce complexity by having an established and repeatable path to production.

### Mitigating the risks of overengineering

As developers, we often strive to build the most generic and flexible system possible, to enable other developers to make responsible decisions for themselves. After all, they know their software better and are therefore poised to make the best decisions for the code. The ideal pipeline is an unopinionated orchestration of independent tools, workflows, and environmental constraints whose output is working, running software.

This quote by Joel Moses encapsulates the risks of overengineering very well. An interesting piece of related trivia is that the ◇ character allowed multiple statements per line of text; it was APL's semicolon.

#### *APL is like a beautiful diamond - flawless, beautifully symmetrical. But you can't add anything to it. If you try to glue on another diamond, you don't get a bigger diamond. Lisp is like a ball of mud. Add more and it's still a ball of mud - it still looks like Lisp.*

As experienced DevOps practicioners and developers, this is what we want. A loosely-coupled system that provides the abstractions to do just about anything in respect to building, testing, and releasing software. Jenkins and TeamCity are CI servers, built around the concepts of projects, artifacts, workspaces, and nodes. However, this abstraction is very limited and the concepts are inherently stateful, whereas with CD tools that understand these principles, developers are freed from CI-only abstractions.

GoCD and concourse.ci take a higher-level conceptual view and allows users to express the complex relationships of dependent pipelines, determine the order in which artifacts must be built, and understand triggers based on their context. They use a small number of general concepts to encapsulate the intention and capture the value of the pipeline. Resources, jobs, and tasks with inputs and outputs are the primitives used to describe pipelines. This is actually far simpler and less error prone than the [**complicated** nature](https://larrycuban.wordpress.com/2010/06/08/the-difference-between-complicated-and-complex-matters/) of plugins, frameworks, languages, and tools that a CI server has to deal with. The CD-aware toolchain expresses simple abstractions using the above concepts, pushing the complexity that CI is traditionally responsible for, to developers and users of the pipeline. This is where a strong conceptual model and framework of what your pipeline should accomplish is necessary for success.

### Migration of Complexity
It is important to note that this shift in where the complexity lies is the key consideration in different build and deployment pipeline paradigms. There is a critical designation between runtime complexity and compile-time complexity. How that is handled is paramount to a successful CD strategy.

The widespread use of containers and microservices has accelerated the pattern of moving compile-time complexity on to the developer and away from the operations team far past the humble beginnings of [Heroku's 12 factor](http://12factor.net) app philosophy. Conversely, this pushes runtime complexity (scaling, monitoring, security, redundancy) further away from the developer and onto the operations team. Developers may see this as losing control of their applications, and in some ways it is a sacrifice of freedom for safety. The operations team now needs to have service discovery working reliably, good configuration management, and well-abstracted data layers for other applications to consume. A very high level of operational maturity is required for this to work, let alone to begin paying dividends.

Creating a good foundation is critical, however a balance of usefulness to developers and graceful operational orthodoxy must be struck and that balance is only known by you in your environment.
