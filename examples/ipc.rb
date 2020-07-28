NS = Namespace
pid = fork do
  NS.unshare NS::CLONE_NEWNS | NS::CLONE_NEWIPC

  Dir.chroot "/var/run/myroot"
  Dir.chdir "/"
  system "mount --make-rslave /"
  system "mount proc /proc -t proc"
  system "mount dev /dev -t devtmpfs"
  system "mount mqueue /dev/mqueue -t mqueue"

  Exec.exec("/bin/bash")
end

p Process.waitpid2(pid)
