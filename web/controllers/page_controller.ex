defmodule DeeplockApp.PageController do
  use DeeplockApp.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
