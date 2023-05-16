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
    # reset_cache!
    repositories_query = cache ReposQuery do
      GH::Client.query(ReposQuery).data
    end
    # repositories_query = GH::Client.query(ReposQuery).data
    user = repositories_query.user
    repositories = user.repositories
    repositories.edges.map &:node
  end

  def self.reset_cache!
    `rm -f #{APP_PATH}/tmp/cache/GH::ReposQuery.json`
  end

end
