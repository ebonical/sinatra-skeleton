db = {
  development: {
    adapter: "mysql2",
    database: "skeleton_development",
    encoding: "utf8",
    pool: 5,
    username: "root",
    password: "master",
    socket: "/tmp/mysql.sock"
  }
}
set :database, db[settings.environment]
