# create a manifest to kills  process named killmenow
exec { 'killmenow':
  command => 'pkill killmenow',
  path    => '/usr/bin/'
}
