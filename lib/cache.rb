
module Cache

  CACHE_TIME = 86400 # seconds (1 day)

  def cache(key, &block)
    if cache_fresh? key
      cache_read key
    else
      value = block.call
      cache_write key, block.call
    end
  end

  def cache_read(key)
    key.new Oj.load File.read cache_file key
  end

  def cache_write(key, value)
    File.open cache_file(key), "w" do |f|
      f.write Oj.dump value.to_h
    end
    value
  end

  private

  def cache_fresh?(key)
    path = cache_file key
    File.exists?(path) && Time.now < File.mtime(path) + CACHE_TIME
  end

  def cache_file(key)
    "#{APP_PATH}/tmp/cache/#{key}.json"
  end

end
