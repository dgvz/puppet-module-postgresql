class postgresql::core {
	noop {
		"postgresql/server/preinstalled": ;
		"postgresql/server/installed":
			require => Noop["postgresql/server/preinstalled"];
		"postgresql/server/configured":
			require => Noop["postgresql/server/installed"];
		"postgresql/client/preinstalled": ;
		"postgresql/client/installed":
			require => Noop["postgresql/client/preinstalled"];
		"postgresql/client/configured":
			require => Noop["postgresql/client/installed"];
	}

	file {
		"/usr/local/sbin/check-pg-db-exists":
			source => "puppet:///modules/postgresql/usr/local/sbin/check-pg-db-exists",
			owner  => "root",
			group  => "root",
			mode   => 0555,
			before => Noop["postgresql/server/preinstalled"];
		"/usr/local/sbin/check-pg-db-extensions":
			source => "puppet:///modules/postgresql/usr/local/sbin/check-pg-db-extensions",
			owner  => "root",
			group  => "root",
			mode   => 0555,
			before => Noop["postgresql/server/preinstalled"];
		"/usr/local/sbin/set-pg-db-extensions":
			source => "puppet:///modules/postgresql/usr/local/sbin/set-pg-db-extensions",
			owner  => "root",
			group  => "root",
			mode   => 0555,
			before => Noop["postgresql/server/preinstalled"];
		"/usr/local/sbin/check-pg-user-exists":
			source => "puppet:///modules/postgresql/usr/local/sbin/check-pg-user-exists",
			owner  => "root",
			group  => "root",
			mode   => 0555,
			before => Noop["postgresql/server/preinstalled"];
		"/usr/local/sbin/check-pg-user-conn-limit":
			source => "puppet:///modules/postgresql/usr/local/sbin/check-pg-user-conn-limit",
			owner  => "root",
			group  => "root",
			mode   => 0555,
			before => Noop["postgresql/server/preinstalled"];
		"/usr/local/sbin/set-pg-user-conn-limit":
			source => "puppet:///modules/postgresql/usr/local/sbin/set-pg-user-conn-limit",
			owner  => "root",
			group  => "root",
			mode   => 0555,
			before => Noop["postgresql/server/preinstalled"];
		"/usr/local/sbin/check-pg-user-pass":
			source => "puppet:///modules/postgresql/usr/local/sbin/check-pg-user-pass",
			owner  => "root",
			group  => "root",
			mode   => 0555,
			before => Noop["postgresql/server/preinstalled"];
		"/usr/local/sbin/set-pg-user-pass":
			source => "puppet:///modules/postgresql/usr/local/sbin/set-pg-user-pass",
			owner  => "root",
			group  => "root",
			mode   => 0555,
			before => Noop["postgresql/server/preinstalled"];
		"/usr/local/sbin/check-pg-user-groups":
			source => "puppet:///modules/postgresql/usr/local/sbin/check-pg-user-groups",
			owner  => "root",
			group  => "root",
			mode   => 0555,
			before => Noop["postgresql/server/preinstalled"];
		"/usr/local/sbin/set-pg-user-groups":
			source => "puppet:///modules/postgresql/usr/local/sbin/set-pg-user-groups",
			owner  => "root",
			group  => "root",
			mode   => 0555,
			before => Noop["postgresql/server/preinstalled"];
	}
}
