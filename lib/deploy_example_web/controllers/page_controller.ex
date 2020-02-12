defmodule DeployExampleWeb.PageController do
  use DeployExampleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
