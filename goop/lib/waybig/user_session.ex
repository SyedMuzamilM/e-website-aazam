defmodule WayBig.UserSession do
  use GenServer

  def start_link(%{user_id: user_id}) do
    GenServer.start_link(
      __MODULE__,
      %{
        pid: nil,
        user_id: user_id,
        atomic_op: nil
      },
      name: :"#{user_id}:user_session"
    )
  end

  def init(x) do
    {:ok, x}
  end

  @spec send_cast(String.t(), any) :: :ok
  def send_cast(user_id, params) do
    case GenRegistry.lookup(
           WayBig.UserSession,
           user_id
         ) do
      {:ok, session} ->
        GenServer.cast(session, params)

      err ->
        err
    end
  end

  def send_call!(user_id, params) do
    case send_call(user_id, params) do
      {:ok, x} ->
        x

      _ ->
        nil
    end
  end

  def send_call(user_id, params) do
    case GenRegistry.lookup(
           WayBig.UserSession,
           user_id
         ) do
      {:ok, session} ->
        {:ok, GenServer.call(session, params)}

      err ->
        {:error, err}
    end
  end

  def handle_cast(
        {:send_ws_msg, _platform, msg},
        state
      ) do
    if not is_nil(state.pid) do
      send(state.pid, {:remote_send, msg})
    end

    {:noreply, state}
  end

  def handle_cast({:new_tokens, tokens}, state) do
    if not is_nil(state.pid) do
      send(
        state.pid,
        {:remote_send,
         %{
           op: "new_tokens",
           d: tokens
         }}
      )
    end

    {:noreply, state}
  end

  def handle_cast({:done_with_atomic_op}, state) do
    {:noreply, %{state | atomic_op: nil}}
  end

  # def handle_cast({:set_current_order_session_id, current_order_session_id}, state) do
  #   {:noreply, %{state | current_order_session_id: current_order_session_id}}
  # end

  # TODO: CHANGE FROM HERE
  # def handle_call({:get_current_room_id}, _, state) do
  #   {:reply, state.current_room_id, state}
  # end

  # def handle_call({:get, key}, _, state) do
  #   {:reply, Map.get(state, key), state}
  # end

  # def handle_call({:start_atomic_op, op}, _, state) do
  #   if is_nil(state.atomic_op) do
  #     {:reply, :ok, %{state | atomic_op: op}}
  #   else
  #     {:reply, :err, state}
  #   end
  # end

  def handle_call({:set_pid, pid}, _, state) do
    if not is_nil(state.pid) do
      send(state.pid, {:kill})
    else
      # Kousa.Data.User.set_online(state.user_id)
      Rath.Access.Users.get(state.user_id)
    end

    #   Process.monitor(pid)
    #   {:reply, :ok, %{state | pid: pid}}
    # end

    # def handle_info({:reconnect_to_voice_server}, state) do
    #   if not is_nil(state.pid) do
    #     if not is_nil(state.current_room_id) do
    #       # Kousa.BL.Room.join_vc_room(state.user_id, state.current_room_id)
    #     end
    #   end

    #   {:noreply, state}
    # end

    # def handle_info({:DOWN, _ref, :process, pid, _reason}, state) do
    #   if state.pid === pid do
    #     # Kousa.Data.User.set_offline(state.user_id)

    #     if state.current_room_id do
    #       # Kousa.BL.Room.leave_room(state.user_id, state.current_room_id)
    #     end

    #     {:stop, :normal, state}
    #   else
    #     {:noreply, state}
    #   end
  end
end
