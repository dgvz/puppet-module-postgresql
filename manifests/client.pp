# Install the PostgreSQL client utilities.
#
# Attributes:
#
#  * `version` (string; optional; default `undef`)
#
#     Which version of the tools to install.  The default, `undef`, will
#     give you the default version provided with your OS.
#
define postgresql::client(
		$version = undef
) {
	include postgresql::core

	case $::operatingsystem {
		Debian: {
			if $version {
				$client_package  = "postgresql-client-$version"
			} else {
				$client_package  = "postgresql-client"
			}

			package { $client_package:
				before  => Noop["postgresql/client/installed"],
				require => Noop["postgresql/client/preinstalled"],
				tag    => 'postgresql',
			}
		}
		default: {
			fail "I don't know how to install a PostgreSQL client on ${::operatingsystem}.  Patches accepted"
		}
	}
}
