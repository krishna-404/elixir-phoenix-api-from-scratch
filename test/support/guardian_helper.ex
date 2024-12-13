defmodule RealDealApi.Support.GuardianHelper do
  def stop_sweeper do
    # Stop the sweeper if it's running
    case Process.whereis(Guardian.DB.Sweeper) do
      nil -> :ok
      pid -> Process.exit(pid, :normal)
    end
  end
end
