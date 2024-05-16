import Config
import Dotenvy
source!(["config/.env", System.get_env()])

config :todoist_elixir, TodoistElixir, todoist_token: env!("TODOIST_TOKEN", :string)
