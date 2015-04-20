# Enable the PostgreSQL Development Group's custom package repos.
#
# Attributes:
#
#  * `version` (string; optional; default `main`)
#
#     Which "version" of the PostgreSQL repos you wish to select.  The default,
#     `main`, includes several versions of the server/client/contrib components,
#     and the "primary supported" version of common components like `libpq`.
#
#  * `include_source` (boolean; optional; default `false`)
#
#     For distributions which separate source and binary packages, this option
#     allows you to enable or disable the inclusion of the source repositories.
#     It defaults to `false`, so as to minimise transfer time.
#
class postgresql::pgdg(
		$version        = "main",
		$include_source = false
) {
	include postgresql::core

	case $::operatingsystem {
		Debian: {
			apt::key { 'B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8':
				key_source => 'http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc',
				before     => Apt::Source["pgdg"];
			}

			apt::source { 'pgdg':
				location    => 'http://apt.postgresql.org/pub/repos/apt/',
				release     => "${::lsbdistcodename}-pgdg",
				repos       => $version,
				include_src => $include_source,
				before      => Noop["postgresql/server/preinstalled"],
			}
		}
		default: {
			fail "I don't know how to enable PGDG for ${::operatingsystem}.  Patches welcome!"
		}
	}
}

