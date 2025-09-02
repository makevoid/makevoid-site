class GH
  GQLClient = GraphQL::Client

  GITHUB_API = "https://api.github.com/graphql"
  HTTP = GQLClient::HTTP.new(GITHUB_API) do
    def headers(context)
      { "Authorization": "bearer #{GITHUB_TOKEN}" }
    end
  end

  SchemaFilePath = "data/github_schema.json"
  Schema = if File.exist? SchemaFilePath
    GQLClient.load_schema SchemaFilePath
  else
    GQLClient.load_schema HTTP
  end

  Client = GQLClient.new schema: Schema, execute: HTTP

  # TODO: extract in separate file
  ReposQuery = Client.parse <<-'GRAPHQL'
    query {
      user(login: "makevoid") {
        repositories(
          first: 100,
          privacy: PUBLIC,
          isFork: false,
          orderBy: {
            field: CREATED_AT,
            direction: DESC,
          },
          affiliations: OWNER,
          ownerAffiliations: OWNER,
        ) {
          edges {
            node {
              name
              description
              createdAt
              updatedAt
              stargazers {
                totalCount
              }
              languages(first: 2) {
                edges {
                  node {
                    name
                  }
                }
              }
              repositoryTopics(first: 10) {
                edges {
                  node {
                    topic {
                      name
                    }
                  }
                }
              }
              content:object(expression: "master:screenshots/main.jpg") {
                oid
              }
            }
          }
        }
      }
    }
  GRAPHQL

  extend Cache

  def self.repos
    # Check if GitHub token is set
    if GITHUB_TOKEN.nil? || GITHUB_TOKEN.empty?
      raise "GitHub token not found! Please set GITHUB_TOKEN in one of these locations:\n" +
            "1. Environment variable: GITHUB_TOKEN=your_token\n" +
            "2. .env file: GITHUB_TOKEN=your_token\n" +
            "3. ~/.github_token_readonly file containing your token"
    end

    # reset_cache!
    repositories_query = cache ReposQuery do
      result = GH::Client.query(ReposQuery)
      if result.errors.any?
        error_messages = result.errors.inspect
        if error_messages.include?("401 Unauthorized")
          raise "GitHub API Authentication Failed: Invalid or expired token. Please check your GITHUB_TOKEN."
        else
          raise "GitHub API Error: #{error_messages}"
        end
      end
      result.data
    end
    
    # repositories_query = GH::Client.query(ReposQuery).data
    user = repositories_query.user
    
    if user.nil?
      raise "GitHub user 'makevoid' not found. Please check the username in the GraphQL query."
    end
    
    repositories = user.repositories
    repositories.edges.map &:node
  end

  def self.reset_cache!
    `rm -f #{APP_PATH}/tmp/cache/GH::ReposQuery.json`
  end

end
