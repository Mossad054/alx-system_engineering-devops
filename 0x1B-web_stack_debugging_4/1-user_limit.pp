# File: 1-user_limit.pp

exec { 'increase_open_files_limit':
  command => "/bin/echo 'holberton soft nofile 1024\nholberton hard nofile 2048' >> /etc/security/limits.conf",
  unless  => "/bin/grep -q 'holberton soft nofile' /etc/security/limits.conf",
}

exec { 'enable_pam_limits_in_common_session':
  command => "/bin/echo 'session required pam_limits.so' >> /etc/pam.d/common-session",
  unless  => "/bin/grep -q 'pam_limits.so' /etc/pam.d/common-session",
}

exec { 'enable_pam_limits_in_common_session_noninteractive':
  command => "/bin/echo 'session required pam_limits.so' >> /etc/pam.d/common-session-noninteractive",
  unless  => "/bin/grep -q 'pam_limits.so' /etc/pam.d/common-session-noninteractive",
}

