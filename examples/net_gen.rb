pid = ARGV[0].to_i
raise("Invalid pid") if pid <= 0
container_ip = ARGV[1] || "10.0.0.2"

bridge_name = "haconiwa0"
bridge_ip = "10.0.0.1"
bridge_ip_netmask = "10.0.0.1/24"

unless `ip a`.include?("haconiwa0")
  puts "Gen bridge"
  [
    "ip link add #{bridge_name} type bridge",
    "ip addr add #{bridge_ip_netmask} dev #{bridge_name}",
    "ip link set dev #{bridge_name} up"
  ].each {|c| system(c) || puts("skip") }
end

Namespace.persist_ns(pid, Namespace::CLONE_NEWNET, "/var/run/netns/netns-for-#{pid}")
ns = "netns-for-#{pid}"

puts "Gen veth"

host = "hos#{pid}"
guest = "gst#{pid}"
[
  "ip link add #{host} type veth peer name #{guest}",
  "ip link set #{host} up",
  "ip link set dev #{host} master #{bridge_name}",
  "ip link set #{guest} netns #{ns} up",
  "ip netns exec #{ns} ip addr add #{container_ip}/24 dev #{guest}",
  "ip netns exec #{ns} ip link set lo up",
  "ip netns exec #{ns} ip route add default via #{bridge_ip}"
].each {|c| system(c) || puts("skip") }

system "umount -l /var/run/netns/netns-for-#{pid}"
system "rm -f /var/run/netns/netns-for-#{pid}"
