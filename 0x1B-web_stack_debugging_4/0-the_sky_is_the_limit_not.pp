# File: 0-the_sky_is_the_limit_not.pp

exec { 'increase_worker_processes':
  command => "/bin/sed -i 's/worker_processes .*/worker_processes auto;/' /etc/nginx/nginx.conf",
  onlyif  => "/bin/grep -q 'worker_processes [0-9]' /etc/nginx/nginx.conf",
}

exec { 'increase_worker_connections':
  command => "/bin/sed -i '/events {/{n;s/.*/    worker_connections 1024;/}' /etc/nginx/nginx.conf",
  onlyif  => "/bin/grep -q 'events {' /etc/nginx/nginx.conf",
}

exec { 'set_system_limits':
  command => "/bin/echo '* soft nofile 10000\n* hard nofile 30000' >> /etc/security/limits.conf",
  unless  => "/bin/grep -q 'soft nofile' /etc/security/limits.conf",
}

exec { 'enable_pam_limits':
  command => "/bin/echo 'session required pam_limits.so' >> /etc/pam.d/common-session && /bin/echo 'session required pam_limits.so' >> /etc/pam.d/common-session-noninteractive",
  unless  => "/bin/grep -q 'pam_limits.so' /etc/pam.d/common-session",
}

exec { 'tune_kernel_parameters':
  command => "/bin/echo 'net.core.somaxconn = 1024\nnet.core.netdev_max_backlog = 5000\nnet.ipv4.tcp_max_syn_backlog = 2048\nnet.ipv4.ip_local_port_range = 1024 65535\nnet.ipv4.tcp_tw_reuse = 1\nnet.ipv4.tcp_fin_timeout = 15' >> /etc/sysctl.conf && /sbin/sysctl -p",
  unless  => "/bin/grep -q 'net.core.somaxconn' /etc/sysctl.conf",
}

exec { 'reload_nginx':
  command => "/usr/sbin/service nginx reload",
  require => Exec['increase_worker_processes', 'increase_worker_connections', 'set_system_limits', 'enable_pam_limits', 'tune_kernel_parameters'],
}

