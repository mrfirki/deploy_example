defmodule DeployExample.Repo do
  use Ecto.Repo,
    otp_app: :deploy_example,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Callback invoked for dynamically configuring the repo.
  It receives the repo configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_type, config) do
    if config[:load_from_system_env] do
      db_url =
        System.get_env("DATABASE_URL") ||
          raise("expected the DATABASE_URL environment variable to be set")

      config = Keyword.put(config, :url, db_url)

      {:ok, config}
    else
      {:ok, config}
    end
  end
end
