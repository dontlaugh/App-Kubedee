# kubedee

This is a Raku rewrite of `kubedee`. It's very much a work in progress right 
now. In fact, it's a mess that only works on my machine.



## Goal

The original goal of `kubedee` was to facilitate development of Kubernetes
itself.


## Prebuild Images

Build the Packer images, locally

```
lxc remote switch local
cd resources/packer
packer build build.pkr.hcl
```


## Origin Story

Kubedee was a project originally developed by [Michael Schubert](https://www.schu.io/).
It was designed to facilitate quick testing/development of Kubernetes itself.
The technique is interesting: mounting raw binaries into multiple LXD containers,
and executing the core services under systemd. It was thousands of lines of
bash that worked the first time I ran it, with only a few dependencies.
Frankly, it amazed me.

But Michael doesn't need to develop K8s these days, so I am forking. K8s is a 
big part of my life now, for better _and_ worse.

My goals are slightly different, but the techniques of the original kubedee
serve them well.

First off, I want to learn [Raku](https://docs.raku.org/). It fascinates me,
and the community is so helpful and friendly. The learning curve is a little 
steep. It has more syntax than any language I've used so far. [This blog post](https://www.codesections.com/blog/raku-manifesto/)
is a good _philosophical_ introduction. If you don't vibe with that, stay away.

As for what I want from kubedee, I need to launch lots of K8s clusters.
Testing this stuff is hard, and I've written quite a few bespoke tools in the
past few years. While I appreciate what k3s and the other "micro" k8s tools do,
they do not allow for much customization at the low level where my team needs
to operate.

LXD is the perfect substrate for implementing this system. It's Linux containers
without the nightmare straightjacket of Dockerfiles. LXD, and the `lxc` command
line tool give you remote execution, backups, orchestration, and more without
requiring you to write hundreds of lines of YAML. It's a powerful platform tool.

In other words, I'm scratching my own itch :)