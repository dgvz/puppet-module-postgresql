# Install a system-wide PostgreSQL server.
#
# Attributes:
#
#  * `version` (string; optional; default `undef`)
#
#     Select a specific version of the server to install.  If left as the
#     default, the default version for your OS will be installed.  Note that
#     this type does not attempt to source packages from any external repos;
#     if the version you want is not provided by your OS package manager by
#     default, you will need to enable additional repositories (see the
#     `postgresql::pgdg` class for help with that).
#
#  * `development` (boolean; optional; default `false`)
#
#     Whether to install development packages (static libraries and
#     headers).  You'll typically need to set this to `true` if you're
#     building any software that uses PostgreSQL.
#
#  * `contrib` (boolean; optional; default `false`)
#
#     Whether to install additional contributed software.
#
#  * `client` (boolean; optional; default `true` if `version == `undef`,
#             `false` otherwise)
#
#    Whether to install the corresponding PostgreSQL client for this server
#    version.  Normally we will only install the client if you're installing
#    the default system version of PostgreSQL, but if you have a thing for
#    multiple clients, you can turn it on here.

define postgresql::server(
		$version     = undef,
		$development = false,
		$contrib     = false,
		$client      = undef,
) {
	noop {
		"postgresql/server/preinstalled": ;
		"postgresql/server/installed":
			require => Noop["postgresql/server/preinstalled"];
		"postgresql/server/configured":
			require => Noop["postgresql/server/installed"];
	}

	case $::operatingsystem {
		Debian: {
			if $version {
				$server_package  = "postgresql-$version"
				$dev_packages    = ["postgresql-server-dev-$version", "libpq-dev"]
				$contrib_package = "postgresql-contrib-$version"
			} else {
				$server_package  = "postgresql"
				$dev_packages    = ["libpq-dev"]
				$contrib_package = "postgresql-contrib-$version"
			}

			package { $server_package:
				before  => Noop["postgresql/server/installed"],
				require => Noop["postgresql/server/preinstalled"],
			}

			service { "postgresql":
				ensure  => running,
				enable  => true,
				require => Noop["postgresql/server/configured"],
			}

			$pkgopts = { "before"  => Noop["postgresql/server/installed"],
			             "require" => Noop["postgresql/server/preinstalled"]
			           }

			if $development {
				ensure_packages($dev_packages, $opts)
			}

			if $contrib {
				ensure_packages($contrib_package, $opts)
			}
		}
		default: {
			fail "I don't know how to install a PostgreSQL server on ${::operatingsystem}.  Patches accepted"
		}
	}

	if $client == undef and $version == undef {
		postgresql::client { $name: }
	}

	if $client {
		postgresql::client { $name:
			version => $version
		}
	}
}
