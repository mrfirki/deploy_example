defmodule DeployExampleWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :deploy_example

  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") ||
        raise("expected the PORT environment variable to be set")

      secret_key_base =
        System.get_env("SECRET_KEY_BASE") ||
          raise("expected the SECRET_KEY_BASE environment variable to be set")

      app_host =
        System.get_env("APP_DOMAIN") ||
          raise("expected the APP_DOMAIN environment variable to be set")

      config =
        config
        |> Keyword.put(:http, [port: port, transport_options: [socket_opts: [:inet6]]])
        |> Keyword.put(:secret_key_base, secret_key_base)
        |> Keyword.put(:url, host: app_host, scheme: "https", port: 443)

  # http: [
  #   port: String.to_integer(System.get_env("PORT") || "4000"),
  #   transport_options: [socket_opts: [:inet6]]
  # ],
      {:ok, config}
    else
      {:ok, config}
    end
  end



  socket "/socket", DeployExampleWeb.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :deploy_example,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_deploy_example_key",
    signing_salt: "OijcVHId"

  plug DeployExampleWeb.Router
end
