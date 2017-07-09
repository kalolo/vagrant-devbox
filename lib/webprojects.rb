class WebProjects
	@path
	@hostname
	@synced_folders

	def initialize(projects_path, hostname)

		@hostname = hostname
		@synced_folders = Array.new

		# I should change this to pick all elements added on projects path
		if projects_path.has_key?('www')
			self.scanProjects(projects_path['www'], 'www')
		end

		if projects_path.has_key?('laravel')
			self.scanProjects(projects_path['laravel'], 'laravel')
		end

	end

	def hostnames

		names = Array.new

		@synced_folders.each { |proj| names.push proj[:hostname] }

		return names
	end

	def syncedFolders
		return @synced_folders
	end

	def scanProjects(path, type)

		path = path.sub(/(\/)+$/,'') + '/'

		Dir.foreach(path) do |item|
			next if item.start_with?(".") || !File.directory?(real_path = self.getPath(path + item))
			@synced_folders.push({name: item, path: real_path, hostname: slug(item), type: type})
		end

	end

	def slug (name)
		return name.downcase.strip.gsub(' ', '-')
	end

	def getPath(directory)
		return (File.symlink?directory) ? File.readlink(directory) : directory
	end


	def writeMacroHosts(path)
		macrovhost = ""
			self.syncedFolders.each { |proj|  macrovhost += "Use #{proj[:type]} #{proj[:hostname]} 80 /var/www/html/#{proj[:name]} \n" }
		File.open(path, 'w') { |file| file.write(macrovhost) }
	end
end
