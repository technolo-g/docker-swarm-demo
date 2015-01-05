VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |vagrant|

  # VMware Configuration
  vagrant.vm.provider "vmware_fusion" do |provider, override|
    override.vm.box = "vmware-trusty64-20140902.box"
    override.vm.box_url = 'https://s3-us-west-2.amazonaws.com/technolo-g/vagrant-boxes/ubuntu/vmware-trusty64-20140902.box'
  end

  vagrant.vm.provider "vmware_fusion" do |v|
    v.vmx["memsize"] = '2048'
    v.vmx["numvcpus"] = '2'
  end

  # Machine Configuration
  # Swarm Host
  vagrant.vm.define "dockerswarm01" do |config|
    config.vm.hostname = "dockerswarm01"
    config.vm.network "private_network", ip: "10.100.199.200"
    config.vm.provision :hosts
    config.vm.provision :ansible do |ansible|
      ansible.playbook = 'ansible/docker_swarm.yml'
      ansible.groups   = {'dockerswarm' => ["dockerswarm01"], 'local' => ['localhost']}
      ansible.raw_arguments = '--timeout=30'
      ansible.host_key_checking = false
    end
  end

  # Docker Hosts
  (1..5).each do |i|
    vagrant.vm.define "dockerhost0#{i}" do |config|
      config.vm.hostname = "dockerhost0#{i}"
      config.vm.network "private_network", ip: "10.100.199.20#{i}"
      config.vm.provision :hosts
      config.vm.provision :ansible do |ansible|
        ansible.playbook = 'ansible/docker_host.yml'
        ansible.groups   = {'dockerhosts' => ["dockerhost0#{i}"], 'local' => ['localhost']}
        ansible.raw_arguments = '--timeout=30'
        ansible.host_key_checking = false
      end
    end
  end
end
