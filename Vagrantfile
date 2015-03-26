# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
    config.vm.box = "hashicorp/precise32"
    config.vm.define :webappsec do |webappsec_config|
        webappsec_config.vm.hostname = "webappsec"
        webappsec_config.vm.network :private_network,
                             :ip => "192.168.33.10"
        webappsec_config.vm.provision "puppet" do |puppet|
            puppet.module_path = "modules"
            puppet.manifest_file = "webappsec.pp"
        end
    end
end
