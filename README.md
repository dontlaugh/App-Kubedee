_Note: This is very WIP while I learn Raku and rewrite the original bash version._

# kubedee

Run Kubernetes on LXD, locally.

## Requirements

* [Raku](https://rakudo.org)
* [LXD](https://github.com/lxc/lxd)
  * Make sure your user is member of the `lxd` group (see `lxd --group ...`)
  * btrfs is used a storage driver currently and required
* [cfssl](https://github.com/cloudflare/cfssl) with cfssljson
* [jq](https://stedolan.github.io/jq/)
* kubectl

## Installation

Clone this repo. Then,

```
zef install .
```

Study [these docs](https://docs.raku.org/language/modules#Testing_modules_and_a_distribution)

## Local Data

kubedee stores all data in `~/.local/share/kubedee/...`. kubedee LXD resources
have a `kubedee-` prefix.

`KUBEDEE_DEBUG=1` enables verbose debugging output (`set -x`).

## Usage

_TODO_

