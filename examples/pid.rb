NS = Namespace
NS.unshare NS::CLONE_NEWPID
pid = fork do
  NS.unshare NS::CLONE_NEWNS

  Dir.chroot "/var/run/myroot"
  Dir.chdir "/"
  system "mount --make-rslave /"
  system "mount proc /proc -t proc"

  Exec.exec("/bin/bash")
end

p Process.waitpid2(pid)
