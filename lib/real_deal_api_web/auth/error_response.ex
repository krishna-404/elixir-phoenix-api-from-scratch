defmodule RealDealApiWeb.Auth.ErrorResponse.Unauthorised do
  defexception [message: "Unauthorised", plug_status: 401]
end
