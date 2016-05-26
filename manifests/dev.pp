class postgresql::dev {
	package { "libpq-dev":
		tag    => 'postgresql',
	}
}
