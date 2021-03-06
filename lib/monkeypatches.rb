class GraphQL::Client::Schema::ObjectClass

  def repository_topics_all
    repository_topics.edges.map(&:node).map &:topic
  end

  def stars_count
    stargazers.total_count
  end

  def image_exists?
    content && content.oid
  end

  def screenshot_url
    "https://raw.githubusercontent.com/makevoid/#{name}/master/screenshots/main.jpg"
  end
  
end
