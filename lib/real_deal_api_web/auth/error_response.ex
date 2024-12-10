defmodule RealDealApiWeb.Auth.ErrorResponse.Unauthorised do
  defexception [message: "Unauthorised", plug_status: 401]
end

defmodule RealDealApiWeb.Auth.ErrorResponse.Forbidden do
  defexception [message: "You do not have access to this resource", plug_status: 403]
end
