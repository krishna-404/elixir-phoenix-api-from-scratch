defmodule RealDealApiWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :real_deal_api,
    module: RealDealApiWeb.Auth.Guardian,
    error_handler: RealDealApiWeb.Auth.GuardianErrorHandler

  # Check for token in session
  plug Guardian.Plug.VerifySession
  # Check for token in header
  plug Guardian.Plug.VerifyHeader
  # Ensure token is valid & hence authenticated
  plug Guardian.Plug.EnsureAuthenticated
  # Load resource
  plug Guardian.Plug.LoadResource
end
