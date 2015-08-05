class WebProjects 
	@path
	@hostname
	@synced_folders

	def initialize(projects_path, hostname)

		@hostname = hostname
		@synced_folders = Array.new

        # I should change this to pick all elements added on projects path
		self.scanProjects(projects_path['www'], 'www')
		self.scanProjects(projects_path['laravel'], 'laravel')

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
    	return name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') + "." + @hostname
    end

	def getPath(directory)
		return (File.symlink?directory) ? File.readlink(directory) : directory
	end


	def writeMacroHosts(path)
		macrovhost = ""
		self.syncedFolders.each { |proj|  macrovhost += "Use " + ( ( proj[:type] == 'www') ? 'VHost' : 'laravel' ) + " " + proj[:hostname] + " 80 /var/www/html/" + proj[:name] + " \n" }
		File.open(path, 'w') { |file| file.write(macrovhost) }
	end
end 