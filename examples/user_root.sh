#!/bin/bash
set -ex
rsync -av --exclude '*.h' --exclude wrk/ --exclude run/ --exclude var/run/ --exclude home/vagrant/myroot_user/ /var/run/myroot/ /home/vagrant/myroot_user/
sudo chown -R vagrant:vagrant /home/vagrant/myroot_user
