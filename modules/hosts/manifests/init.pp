class hosts {
  host { 'drewbilee.internets.cool':
    ensure         => 'present',
    host_aliases   => ['coolbeans', 'yoloswaggins'],
    ip             => '192.168.1.1',
  }
}
