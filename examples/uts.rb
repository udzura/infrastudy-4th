NS = Namespace
pid = fork do
  NS.unshare NS::CLONE_NEWUTS
  Exec.exec("/bin/bash")
end

p Process.waitpid2(pid)
