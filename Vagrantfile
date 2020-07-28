Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2004"
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 4
    vb.memory = "4096"
  end

  config.vm.provision :shell, inline: (<<-SHELL), name: "phase1", reboot: true
    set -x
    apt -y update
    apt -y install apt install build-essential ruby rake bison git
    apt -y install linux-image-5.6.0-1020-oem
    wget http://ftp.kr.debian.org/debian/pool/main/l/linux/linux-libc-dev_5.6.14-2~bpo10+1_amd64.deb
    apt install ./linux-libc-dev_5.6.14-2~bpo10+1_amd64.deb
  SHELL

  config.vm.provision :shell, inline: (<<-SHELL), name: "phase2"
    set -x
    add-apt-repository multiverse
    apt install virtualbox-guest-dkms virtualbox-guest-x11
  SHELL

  config.vm.synced_folder ".", "/wrk"
end
