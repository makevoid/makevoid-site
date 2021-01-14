require 'pathname' # autodiscover

class Icon

  # ICONS_HOSTNAME_PATH = Config.icons_hostname
  # ICONS_HOSTNAME_PATH = "https://unpkg.com/simple-icons@v4" # CDN
  ICONS_HOSTNAME_PATH = "/img/vendor/ico" # Icons stored in local repository - same host
  ICON_NAMES = %w(
    facebook
    instagram
    twitter
  ) # etc. - insert icons here if you turn the autodiscover off
  ICONS_PATH = ICONS_HOSTNAME_PATH

  # autodiscover path = needs file system access
  ICONS_FS = Dir.glob "ICONS_PATH/*.svg"

  attr_reader :name
  alias :icon_name :name

  def initialize(name:)
    @icon_name = name
  end

  def to_html
    "<img class=\"icon\" height=\"32\" width=\"32\" src=\"#{ICONS_HOSTNAME_PATH}/#{@icon_name}.svg\" />"
  end

  def self.all
    file_basename = -> (file) { File.basename FilePath.new file }
    ICONS_FS.map &file_basename
  end

  def self.all_alt
    icons = -> (icon_name) {
      Icon.new name: icon_name
    }
    ICON_NAMES.map &icons
  end

end
