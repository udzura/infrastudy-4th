NS = Namespace
pid = fork do
  NS.unshare NS::CLONE_NEWNS | NS::CLONE_NEWNET

  Dir.chroot "/var/run/myroot"
  Dir.chdir "/"
  system "mount --make-rslave /"
  system "mount proc /proc -t proc"
  system "mount sys /sys -t sysfs"

  puts "PID=#{Process.pid}"
  Exec.exec("/bin/bash")
  # ls -l /sys/devices/virtual/net
end
p Process.waitpid2(pid)
