defmodule StarLoader.Loader do
    use Task, restart: :permanent
    require Logger
    require Jason

    @host 'eddn.edcd.io'
    @port 9500
    @journalSchema "https://eddn.edcd.io/schemas/journal/1"

    def start_link(opts \\ []) do
        Task.start_link(__MODULE__, :run, opts)
    end

    def run() do
        Application.start(:chumak)
        {:ok, socket} = :chumak.socket(:sub)
        :chumak.subscribe(socket, '')
        case :chumak.connect(socket, :tcp, @host, @port) do
            {:ok, _pid} ->
                Logger.info("Binding OK with Pid: #{inspect socket}");
            {:error, reason} ->
                Logger.error("Connection Failed for this reason: #{reason}");
            x ->
                Logger.error("Unhandled reply for bind #{x}")
        end

        loop(socket)
    end

    def loop(socket) do
        {:ok, compressed_data} = :chumak.recv(socket)
        zlib = :zlib.open()
        :zlib.inflateInit(zlib)
        data = :zlib.inflate(zlib, compressed_data)
        :zlib.close(zlib)
        Enum.join(data) |> process
        loop(socket)
    end

    def process(item) do
        case Jason.decode(item) do
            {:ok, message} ->
                case message["$schemaRef"] do
                    @journalSchema ->
                        if approved_publisher(message) and valid_event(message) do
                            case message["message"] do
                                %{
                                    "StarPos" => [x_position, y_position, z_position],
                                    "StarSystem" => system_name,
                                    "SystemAddress" => system_address
                                } -> store_star(x_position, y_position, z_position, system_name, system_address)
                                _ -> Logger.error(inspect message)
                            end
                        end
                    _ -> nil
                end
            {:error, error} -> Logger.error(error)
        end
    end

    def store_star(x_position, y_position, z_position, system_name, system_address) do
        case StarChart.Data.create_system(%{
            x: x_position,
            y: y_position,
            z: z_position,
            name: system_name,
            system_address: system_address
        }) do
            {:ok, _} -> Logger.info("Successfully stored star \"#{}\"!")
            {:error, changeset} ->
                case changeset.errors do
                    [system_address: {_, [constraint: :unique, constraint_name: _]}] -> Logger.info("star already stored")
                    _ -> Logger.error(inspect changeset.errors)
                end
        end
    end

    def approved_publisher(_message) do
        true
    end

    def valid_event(_message) do
        true
    end
end
