# Configure some "global" PostgreSQL options.
#
# Attributes:
#
#  * `locale` (string; optional; default `undef`)
#
#     Set a specific default locale for all PostgreSQL clusters created on
#     this machine.
#
#  * `encoding` (string; optional; default `undef`)
#
#     Set a specific default character encoding for all PostgreSQL clusters
#     created on this machine.
#
class postgresql::global(
		$locale   = undef,
		$encoding = undef
) {
	package { "postgresql-common":
		tag    => 'postgresql',
	}

	$postgresql_global_locale   = $locale
	$postgresql_global_encoding = $encoding

	file { "/etc/postgresql-common/createcluster.conf":
		ensure  => "file",
		content => template("postgresql/etc/postgresql-common/createcluster.conf"),
		mode    => 0444,
		owner   => "root",
		group   => "root",
		require => Package["postgresql-common"],
		before  => Noop["postgresql/server/preinstalled"],
	}
}
