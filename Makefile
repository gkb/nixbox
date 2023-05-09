BUILDERS ?= "vmware-iso.vmware"

PACKER_ON_ERROR ?= "cleanup"

all: build

build: build-i686 build-x86_64 build-aarch64

build-i686: nixos.pkr.hcl
	packer build -on-error=${PACKER_ON_ERROR} -var-file="nixos.auto.pkvars.hcl"\
    -var arch=i686 --only=${BUILDERS} $<

build-x86_64: nixos.pkr.hcl
	packer build -on-error=${PACKER_ON_ERROR} -var-file="nixos.auto.pkvars.hcl"\
    -var arch=x86_64 --only=${BUILDERS} $<

build-aarch64: nixos.pkr.hcl
	packer build -on-error=${PACKER_ON_ERROR} -var-file="nixos.auto.pkvars.hcl"\
    -var arch=aarch64 --only=${BUILDERS} $<

.PHONY: all build-i686 build-x86_64 build-aarch64
