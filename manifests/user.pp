define postgresql::user(
		$ensure   = present,
		$username,
		$password = undef,
		$groups   = undef
) {
	include postgresql::core

	if $ensure == present {
		exec { "${name}::Add the ${username} user to PgSQL":
			command => "/bin/su -l postgres -c \"/usr/bin/createuser -DRSl -c 3 ${username}\"",
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

		if $groups {
			exec { "${name}::Set groups for ${username}":
				command => "/bin/su -l postgres -c \"/usr/local/sbin/set-pg-user-groups ${username} ${groups}"\"",
				unless  => "/bin/su -l postgres -c \"/usr/local/sbin/check-pg-user-groups ${username} ${groups}"\"",
				require     => [Service["postgresql"],
									 File["/usr/local/sbin/set-pg-user-groups"],
									 File["/usr/local/sbin/check-pg-user-groups"],
									 Exec["${name}::Add the ${username} user to PgSQL"],
									];
			}
		}
	} elsif $ensure == absent {
		exec { "${name}::Remove the ${username} user from PgSQL":
			command => "/bin/su -l postgres -c \"/usr/bin/dropuser ${username}\"",
			onlyif  => "/bin/su -l postgres -c \"/usr/local/sbin/check-pg-user-exists ${username}\"",
			require => [Service["postgresql"],
			            File["/usr/local/sbin/check-pg-user-exists"]];
		}
	} else {
		fail "Unknown value for \$ensure: ${ensure}"
	}
}
