file='Gemfile.lock'
gem_lines = []
File.readlines(file).each do |line|
  	if line[-2] == ")"
  		gem_lines.append(line.strip)
  	end
end

# split lines into gem name and version
gem_specs = gem_lines.map {|l| [ l.split(" ")[0], l.split(" ", 2)[1][1...-1]] }

# resolve versioning conflicts by prioritizing exact versions over approximate versions
gem_versions = {}
for spec in gem_specs
	gem_name, version = spec

	if gem_versions.key? gem_name
		cv = gem_versions[gem_name]
		if (version.split(" ").count == 1) and (cv.include? "~" or cv.include? "=" or cv.include? "<" or cv.include? "<")
			gem_versions[gem_name] = version
		end
	else
		gem_versions[gem_name] = version
	end
end

puts gem_versions.inspect

# gem install all of our dependencies using ruby_ship_gem.sh
# for gem_name in gem_versions.keys
# 	version = gem_versions[gem_name]
# 	puts "./bin/ruby_ship_gem.sh install #{gem_name} -v '#{version}' -N"
# 	system "./bin/ruby_ship_gem.sh install #{gem_name} -v '#{version}' -N"
# end