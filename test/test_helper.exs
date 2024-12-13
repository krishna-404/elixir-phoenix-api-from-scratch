ExUnit.start()

# Set sandbox mode before anything else
Ecto.Adapters.SQL.Sandbox.mode(RealDealApi.Repo, {:shared, self()})

# Stop the sweeper if it's running and restart it
if sweeper_pid = Process.whereis(Guardian.DB.Sweeper) do
  Process.exit(sweeper_pid, :normal)
end
