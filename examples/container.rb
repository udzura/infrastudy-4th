comm = ARGV[0]
uid = `id -u`.chomp
NS = Namespace
NS.unshare(
  NS::CLONE_NEWUTS | NS::CLONE_NEWNS |
  NS::CLONE_NEWIPC | NS::CLONE_NEWPID |
  NS::CLONE_NEWNET | NS::CLONE_NEWUSER
)
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
  Exec.exec comm
end
puts "PID=#{pid}"
p Process.waitpid2(pid)
