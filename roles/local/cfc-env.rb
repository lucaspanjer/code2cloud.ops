name "cfc-env"

override_attributes \
:cfc => {
  :hosts => {
  },
  :mysql_pw => {
    "profile" => "LoCaL_profile",
    "tasks" => "LoCaL_tasks",
    "wiki" => "LoCaL_wiki",
  },
  :artifacts => {
    :http_user => "testuser",
    :http_password => "pr0dD3PL0Yu53r"
  },
  :github => {
    :consumer_key => "N/A",
    :consumer_secret => "N/A"
  }
}
