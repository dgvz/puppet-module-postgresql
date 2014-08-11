define postgresql::database(
		$name,
		$owner,
		$extensions = undef,
) {
	include postgresql::core

	exec { "${name}::Add the ${name} DB, owned by ${owner}, to PgSQL":
		command => "/bin/su -l postgres -c \"createdb -O ${owner} ${name}\"",
		unless  => "/bin/su -l postgres -c \"/usr/local/sbin/check-pg-db-exists ${name}\"",
		require => [Service["postgresql"],
		            File["/usr/local/sbin/check-pg-db-exists"]];
	}

	if $extensions {
		exec { "${name}::Set extensions for ${name} DB to ${extensions}":
			command => "/bin/su -l postgres -c \"/usr/local/sbin/set-pg-db-extensions ${name} ${extensions}\"",
			unless  => "/bin/sh -l postgres -c \"/usr/local/sbin/check-pg-db-extensions ${name} ${extensions}\"",
			require => [Service["postgresql"],
			            File["/usr/local/sbin/set-pg-db-extensions"],
			            File["/usr/local/sbin/check-pg-db-extensions"],
			            Exec["${name}::Add the ${name} DB, owned by ${owner}, to PgSQL"],
			           ],
		}
	}
}
