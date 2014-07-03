define postgresql::user(
		$username,
		$password = undef
) {
	include postgresql::core

	exec { "${name}::Add the ${username} user to PgSQL":
		command => "/bin/su -l postgres -c \"createuser -DRSl -c 3 ${username}\"",
		unless  => "/bin/su -l postgres -c \"/usr/local/sbin/check-pg-user-exists ${username}\"",
		require => [Service["postgresql"],
		            File["/usr/local/sbin/check-pg-user-exists"]];
	}

	if $password {
		$pwhash = pg_hash($username, $password)

		exec { "${name}::Set the password for PgSQL user ${username}":
			command => "/bin/su -l postgres -c \"/usr/local/sbin/set-pg-user-pass ${username} ${pwhash}\"",
			unless  => "/bin/su -l postgres -c \"/usr/local/sbin/check-pg-user-pass ${username} ${pwhash}\"",
			require     => [Service["postgresql"],
			                File["/usr/local/sbin/set-pg-user-pass"],
			                File["/usr/local/sbin/check-pg-user-pass"],
			                Exec["${name}::Add the ${username} user to PgSQL"]
			               ];
		}
	}
}
