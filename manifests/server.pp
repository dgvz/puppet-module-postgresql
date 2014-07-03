define postgresql::server() {
	package { "postgresql": }

	service { "postgresql":
		ensure  => running,
		enable  => true,
		require => Package["postgresql"]
	}
}
