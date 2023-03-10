
DEBIAN_VERSION:=11.6.0
DEBIAN_ISO:=debian-$(DEBIAN_VERSION)-amd64-netinst.iso
DEBIAN_URL:=https://cdimage.debian.org/cdimage/release/$(DEBIAN_VERSION)/amd64/iso-cd/$(DEBIAN_ISO)
NAME:=bastion

WORK_DIRS:=output tmp

.PHONY: build clean

$(WORK_DIRS):
	mkdir -p $@

clean:
	rm -rf $(WORK_DIRS)

tmp/$(DEBIAN_ISO): | tmp
	wget -O $@ $(DEBIAN_URL)

output/%.box: %.pkr.hcl | output
	packer build -var 'iso_url=$(word 2,$^)' -var 'output_dir=$(@D)' -var 'vm_name=$(@F)' $<

output/bastion_no_provision.box: tmp/$(DEBIAN_ISO)
output/bastion.box: tmp/bastion_no_provision.qcow2 

tmp/bastion_no_provision.qcow2: output/bastion_no_provision.box | tmp
	tar -xvzf $< box_0.img -O > $@

build: output/bastion.box