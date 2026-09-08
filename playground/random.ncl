let UserSchema = {
  name
    | String
    | doc "User's full name",

  is-admin
    | Bool
    | default = false
    | doc "Whether user has admin privileges",

  ssh-keys
    | Array String
    | optional
    | doc "List of SSH public keys",

  extra-groups
    | Array String
    | optional
    | default = []
    | doc "Additional group memberships"
} in

let users = {
  users | Array UserSchema = [
    {
      name = "Aisha",
      is-admin = true,
      ssh-keys = [
        "AAAAApqCA8oKAB5S/47f...... aisha@work",
        "AAAAA26vx+AqGIPZd/NT...... aisha@home"
      ],
      extra-groups = ["support", "engineering"]
    },
    {
      name = "Bob",
      extra-groups = ["pentester"],
      ssh-keys = ["AAAAAe4QAAAAAB5OLAo1...... bob@work"]
    },
    {
      name = "Charlie",
      ssh-keys = []
    },
    {
      name = "Diana",
      is-admin = true,
      ssh-keys = ["AAAAA26vx+AqGIPZd/NT...... diana@work"],
      extra-groups = ["administrative"]
    },
    {
      name = "Eve",
      is-admin = false,
      extra-groups = ["audit"]
    },
    {
      name = "Frank",
      ssh-keys = ["AAAAAe4QAAAAAB5OLAo1...... frank@work"]
    },
    {
      name = "Grace",
      is-admin = true,
      extra-groups = ["administrative", "hr"]
    },
    {
      name = "Heidi",
      ssh-keys = []
    },
    {
      name = "Ivan",
      extra-groups = ["devops"],
      ssh-keys = ["AAAAAe4QAAAAAB5OLAo1...... ivan@work"]
    },
    {
      name = "Judy",
      ssh-keys = ["AAAAAe4QAAAAAB5OLAo1...... judy@work"]
    }
  ]
} in

let ServerConfig = {
  hostname | String | doc "Server hostname",
  port | Number | default = 8080 | doc "Listening port",
  enable-ssl | Bool | default = true | doc "Enable SSL",
  max-connections | Number | default = 100 | doc "Max concurrent connections",
  timeout-seconds | Number | default = 30 | doc "Request timeout in seconds"
} in

let server = {
  server | ServerConfig = {
    hostname = "api.example.com",
    port = 443,
    enable-ssl = true,
    max-connections = 250,
    timeout-seconds = 60
  }
} in

let Application = {
  name | String,
  version | String,
  environment | [| 'development, 'staging, 'production |],
  users | Array UserSchema,
  server | ServerConfig
} in

let app = {
  app | Application = {
    name = "User Management API",
    version = "2.1.0",
    environment = 'production,
    users = users.users,
    server = server.server
  }
} in

let validate-users = fun users-list =>
  std.array.fold_left
    (fun acc user =>
      if std.string.length user.name == 0 then
        acc @ ["User has empty name"]
      else if user.is-admin && std.array.length user.ssh-keys == 0 then
        acc @ ["Admin user %{user.name} has no SSH keys"]
      else
        acc
    )
    []
    users-list in

let validation-result = validate-users users.users in

if std.array.length validation-result > 0 then
  throw "Validation errors: %{std.string.join "," validation-result}"
else
  app
