NS = Namespace
pid = fork do
  NS.unshare NS::CLONE_NEWNS | NS::CLONE_NEWTIME

  uptime = File.read("/proc/uptime").split()[0].to_i
  File.open("/proc/self/timens_offsets", "w") do |f|
    f.write "boottime -#{uptime} 0"
  end

  system "mount --make-rslave /"
  Dir.chroot "/var/run/myroot"
  Dir.chdir "/"
  system "mount proc /proc -t proc"

  Exec.exec("/bin/bash")
end

p Process.waitpid2(pid)
