class Env
  def self.load!
    @@env = {}
    # TODO: load .env.local and .env and populate @@env
  end

  def self.[](key)
    env = ENV[key]
    return env if env && !env.empty?
    paths = ["#{APP_PATH}/.#{key.downcase}", "~/.#{key.downcase}"]
    find_path paths
  end

  private

  def self.find_path(paths)
    paths.each do |path|
      file = File.expand_path path
      return File.read(file).strip if File.exist? file
    end
  end


end
