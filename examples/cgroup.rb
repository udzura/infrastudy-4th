NS = Namespace
#system "rmdir /sys/fs/cgroup/cpu/mygroup01/sub*"
#system "rmdir /sys/fs/cgroup/cpu/mygroup01"

system "mkdir /sys/fs/cgroup/cpu/mygroup01"
File.open("/sys/fs/cgroup/cpu/mygroup01/cpu.cfs_quota_us", "w") do |f|
  f.write "50000"
end

NS.unshare NS::CLONE_NEWPID
pid = fork do
  File.open("/sys/fs/cgroup/cpu/mygroup01/tasks", "w") do |f|
    f.write Process.pid.to_s
  end

  NS.unshare NS::CLONE_NEWNS | NS::CLONE_NEWCGROUP

  system "mount --make-rslave /"
  Dir.chroot "/var/run/myroot"
  Dir.chdir "/"
  system "mount proc /proc -t proc"
  system "mount sys /sys -t sysfs"
  system "mount tmpfs /sys/fs/cgroup -t tmpfs"
  system "mkdir /sys/fs/cgroup/cpu,cpuacct"
  system "mount cgroup /sys/fs/cgroup/cpu,cpuacct -t cgroup -o cpu,cpuacct"

  system "mkdir /sys/fs/cgroup/cpu,cpuacct/sub01"
  system "mkdir /sys/fs/cgroup/cpu,cpuacct/sub02"

  Exec.exec("/bin/bash")
end

p Process.waitpid2(pid)
sleep 1

system "rmdir /sys/fs/cgroup/cpu/mygroup01/sub01"
system "rmdir /sys/fs/cgroup/cpu/mygroup01/sub02"
system "rmdir /sys/fs/cgroup/cpu/mygroup01"
