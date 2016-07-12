defmodule Openmaize.OnetimePass.Base do
  @moduledoc """
  Module to handle one-time passwords for use in two factor authentication.
  """

  import Plug.Conn
  alias Comeonin.Otp

  def check_key(user, %{"hotp" => hotp}, opts) do
    {user, Otp.check_hotp(hotp, user.otp_secret, opts)}
  end
  def check_key(user, %{"totp" => totp}, opts) do
    {user, Otp.check_totp(totp, user.otp_secret, opts)}
  end

  def handle_auth({_, false}, conn) do
    put_private(conn, :openmaize_error, "Invalid credentials")
  end
  def handle_auth({user, last}, conn) do
    conn
    |> put_private(:openmaize_info, last)
    |> put_session(:user_id, user.id)
  end
end