defmodule RealDealApiWeb.Auth.AuthorizedPlug do
  alias RealDealApiWeb.Auth.ErrorResponse.Forbidden

  def is_authorised(%{params: %{"account" => params}} = conn, _opts) do

    if conn.assigns[:account].id == params.id, do: conn, else: raise Forbidden
  end

  def is_authorised(%{params: %{"user" => params}} = conn, _opts) do

    if conn.assigns[:account].user.id == params.id, do: conn, else: raise Forbidden
  end
end
