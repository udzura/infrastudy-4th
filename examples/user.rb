NS = Namespace
uid = `id -u`.chomp

NS.unshare NS::CLONE_NEWNS | NS::CLONE_NEWUSER | NS::CLONE_NEWPID
File.open("/proc/self/setgroups", "w") do |f|
  f.write "deny\n"
end
File.open("/proc/self/gid_map", "w") do |f|
  f.write "0 #{uid} 1\n"
end
File.open("/proc/self/uid_map", "w") do |f|
  f.write "0 #{uid} 1\n"
end

pid = fork do
  system "mount --make-rslave /"
  Dir.chroot "/home/vagrant/myroot_user"
  Dir.chdir "/"
  system "mount proc /proc -t proc"

  Exec.exec("/bin/bash")
end

p Process.waitpid2(pid)
