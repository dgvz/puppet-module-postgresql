# Manage a PgSQL user, with a specified password and "group" (actually
# roles) list.
#
# Attributes:
#
#  * `ensure` (`present` or `absent`; optional; default `present`)
#
#     Control whether the specified user should exist, or be removed.
#     Things get exciting if you have two resources with the same `username`
#     and different values for this parameter, so don't do that.
#
#  * `username` (string; optional; default `$name`)
#
#     The name of the specified user.  By default, the username will be
#     taken from the resource's title, but to allow different parts of a
#     manifest to ensure the same user exists, you can use this parameter to
#     override the title.
#
#  * `password` (string; optional; default `undef`)
#
#     If specified, this is taken to be the plaintext password for the user,
#     and hence the user will be able to specify this password to login.  A
#     user without a password can still use ident or client cert
#     authentication, if available and appropriate.
#
#  * `groups` (string; optional; default `undef`)
#
#     If specified, this is a list of groups (or, more precisely, roles) to
#     which the user should be granted privileges.  Specifying this
#     attribute does not guarantee that the user will not have access to
#     other groups (this is because of the ability to have multiple
#     `postgresql::user` resources for a single PgSQL user).  If you wish to
#     be sure that a user does *not* have access to a particular group, you
#     can specify `-<group>` in the group list.  Note that having two
#     resources with conflicting group lists (that is, one resource
#     specifies `<group>` and the other specifies `-<group>` will result in
#     duelling resources and a configuration that will never converge, so
#     you probably don't want to do that (but Puppet won't complain).
#
#  * `connection_limit` (integer; optional; default `-1`)
#
#     What connection limit to apply to this user.  The default, `-1`, is a
#     nice, "no surprises" default that will allow the user unlimited
#     connections.  If people are playing silly-buggers, then you might want
#     to tie this down a bit.
#
define postgresql::user(
		$ensure           = present,
		$username         = undef,
		$password         = undef,
		$groups           = undef,
		$connection_limit = -1
) {
	include postgresql::core

	if $username {
		$user = $username
	} else {
		$user = $name
	}

	if $ensure == present {
		exec { "${name}::Add the ${user} user to PgSQL":
			command => "/bin/su -l postgres -c \"/usr/bin/createuser -DRSl -c 3 ${user}\"",
			unless  => "/bin/su -l postgres -c \"/usr/local/sbin/check-pg-user-exists ${user}\"",
			require => [Service["postgresql"],
							File["/usr/local/sbin/check-pg-user-exists"]];
		}

		if $password {
			$pwhash = pg_hash($user, $password)

			exec { "${name}::Set the password for PgSQL user ${user}":
				command => "/bin/su -l postgres -c \"/usr/local/sbin/set-pg-user-pass ${user} ${pwhash}\"",
				unless  => "/bin/su -l postgres -c \"/usr/local/sbin/check-pg-user-pass ${user} ${pwhash}\"",
				require     => [Service["postgresql"],
									 File["/usr/local/sbin/set-pg-user-pass"],
									 File["/usr/local/sbin/check-pg-user-pass"],
									 Exec["${name}::Add the ${user} user to PgSQL"]
									];
			}
		}

		if $groups {
			exec { "${name}::Set groups for ${user}":
				command => "/bin/su -l postgres -c \"/usr/local/sbin/set-pg-user-groups ${user} ${groups}\"",
				unless  => "/bin/su -l postgres -c \"/usr/local/sbin/check-pg-user-groups ${user} ${groups}\"",
				require     => [Service["postgresql"],
									 File["/usr/local/sbin/set-pg-user-groups"],
									 File["/usr/local/sbin/check-pg-user-groups"],
									 Exec["${name}::Add the ${user} user to PgSQL"],
									];
			}
		}

		if $connection_limit {
			exec { "${name}::Set connection_limit for ${user}":
				command => "/bin/su -l postgres -c \"/usr/local/sbin/set-pg-user-conn-limit ${user} ${connection_limit}\"",
				unless  => "/bin/su -l postgres -c \"/usr/local/sbin/check-pg-user-conn-limit ${user} ${connection_limit}\"",
				require     => [Service["postgresql"],
									 File["/usr/local/sbin/set-pg-user-conn-limit"],
									 File["/usr/local/sbin/check-pg-user-conn-limit"],
									 Exec["${name}::Add the ${user} user to PgSQL"],
									];
			}
		}
	} elsif $ensure == absent {
		exec { "${name}::Remove the ${user} user from PgSQL":
			command => "/bin/su -l postgres -c \"/usr/bin/dropuser ${user}\"",
			onlyif  => "/bin/su -l postgres -c \"/usr/local/sbin/check-pg-user-exists ${user}\"",
			require => [Service["postgresql"],
			            File["/usr/local/sbin/check-pg-user-exists"]];
		}
	} else {
		fail "Unknown value for \$ensure: ${ensure}"
	}
}
