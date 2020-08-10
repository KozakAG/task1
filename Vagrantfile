
BOX_IMAGE1 = "ubuntu/trusty64"
BOX_IMAGE2 = "centos/7"
Vagrant.configure("2") do |config|
        config.vm.define "database1" do |db|
            db.vm.provider "virtualbox" do |v|
                v.name = "db1_vm"
            end
            db.vm.box = BOX_IMAGE1
            db.vm.network "private_network", ip: "192.168.63.15"
            db.vm.provider "virtualbox" do |vb|
                vb.memory = "1024"
                vb.cpus = "1"
            end
            db.vm.provision :shell, path: "db1_vm.sh"
        end
        config.vm.define "application1" do |app|
            app.vm.provider "virtualbox" do |v|
                v.name = "app1_vm"
            end
            app.vm.box = BOX_IMAGE1
            app.vm.network "private_network", ip: "192.168.63.20"
            app.vm.provider "virtualbox" do |vb|
                vb.memory = "1024"
                vb.cpus = "1"
            end
            app.vm.provision :shell, path: "app1__vm.sh"
        end

end
