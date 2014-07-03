class postgresql::core {
	file {
		"/usr/local/sbin/check-pg-db-exists":
			source => "puppet:///modules/postgresql/usr/local/sbin/check-pg-db-exists",
			owner  => "root",
			group  => "root",
			mode   => 0555;
		"/usr/local/sbin/check-pg-user-exists":
			source => "puppet:///modules/postgresql/usr/local/sbin/check-pg-user-exists",
			owner  => "root",
			group  => "root",
			mode   => 0555;
		"/usr/local/sbin/check-pg-user-pass":
			source => "puppet:///modules/postgresql/usr/local/sbin/check-pg-user-pass",
			owner  => "root",
			group  => "root",
			mode   => 0555;
		"/usr/local/sbin/set-pg-user-pass":
			source => "puppet:///modules/postgresql/usr/local/sbin/set-pg-user-pass",
			owner  => "root",
			group  => "root",
			mode   => 0555;
	}
}

