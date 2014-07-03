define postgresql::database(
		$name,
		$owner
) {
	include postgresql::core

	exec { "${name}::Add the ${name} DB, owned by ${owner}, to PgSQL":
		command => "/bin/su -l postgres -c \"createdb -O ${owner} ${name}\"",
		unless  => "/bin/su -l postgres -c \"/usr/local/sbin/check-pg-db-exists ${name}\"",
		require => [Service["postgresql"],
		            File["/usr/local/sbin/check-pg-db-exists"]];
	}
}
