require 'digest/md5'

module Puppet::Parser::Functions
	newfunction(:pg_hash, :type => :rvalue, :doc => "Returns the PgSQL hash for a given user/pass pair.") do |args|
		args.length == 2 or raise Puppet::ParseError.new("pg_hash: expecting 2 arguments, got #{args.length}")
		user = args[0]
		pass = args[1]

		is_scalar = Puppet::Parser::Functions.function(:is_scalar) or raise Puppet::Error.new("pg_hash: is_scalar could not be loaded")
		send(is_scalar, [user]) or raise Puppet::ParseError.new("pg_hash: invalid user: #{user} (expecting scalar, got #{user.class})")
		send(is_scalar, [pass]) or raise Puppet::ParseError.new("pg_hash: invalid pass: #{pass} (expecting scalar, got #{pass.class})")

		'md5' + Digest::MD5.hexdigest("#{pass}#{user}")
	end
end
