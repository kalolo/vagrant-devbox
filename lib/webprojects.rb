class WebProjects 
	@path
	@hostname
	@synced_folders

	def initialize(projects_path, hostname)
		@path = projects_path.sub(/(\/)+$/,'') + '/'
		@hostname = hostname

		@synced_folders = Array.new

		self.scanProjects

	end

    def hostnames

        names = Array.new

        @synced_folders.each { |proj| names.push proj[:hostname] }

        return names
    end

    def syncedFolders
    	return @synced_folders
    end
	 
	def scanProjects

        Dir.foreach(@path) do |item|
            next if item.start_with?(".") || !File.directory?(real_path = self.getPath(item))

            @synced_folders.push({name: item, path: real_path, hostname: slug(item)})
        end

	end

	def slug (name)
    	return name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') + "." + @hostname
    end

	def getPath(item)
		path = @path + item
		return (File.symlink?path) ? File.readlink(path) : path
	end


	def writeMacroHosts(path)
		macrovhost = ""

		puts ">> Writing macro hosts"


		self.syncedFolders.each { |proj|  macrovhost += "Use VHost " + proj[:hostname] + " 80 /var/www/html/" + proj[:name] + " \n" }
		File.open(path, 'w') { |file| file.write(macrovhost) }
	end
end 