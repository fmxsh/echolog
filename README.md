# Echolog System

Echolog is a lightweight, Unix-domain-socket-based logging system composed of three parts:

- `echolog`: Command-line tool to send structured log messages.
- `el-server`: A Unix domain socket server that receives, timestamps, logs, and broadcasts messages.
- `el-monitor`: A colored log monitor that displays recent and live log entries.

This system is designed for efficient and real-time log handling within local environments using sockets instead of TCP/UDP.

## Components

### 1. `echolog`

A small command-line utility to send typed messages to the logging server.

**Usage:**

```bash
./echolog -t <type> -m <message>
# or
echo "message" | ./echolog -t <type>
```

- `-t <type>`: Message type (`info`, `error`, `debug`, etc.)
- `-m <message>`: Log message. If omitted, reads from stdin.

Connects to `/tmp/unix_incoming_socket` and sends a single line message in the format:

```
<type> <message>
```

### 2. `el-server`

The central server component. It:

- Listens on `/tmp/unix_incoming_socket` for messages from clients.
- Appends timestamped log entries to `/var/log/echolog`.
- Broadcasts all received messages to connected monitors via `/tmp/unix_outgoing_socket`.

Run:

```bash
./el-server
```

**Responsibilities:**

- Maintains up to 10 live monitor clients.
- Replaces newline characters in log messages with `[/n]` to ensure single-line log integrity.

### 3. `el-monitor`

Displays recent and live logs with color-coded message types.

Run:

```bash
./el-monitor
```

**Features:**

- Reads the last 100 entries from `/var/log/echolog`.
- Connects to `/tmp/unix_outgoing_socket` and displays incoming messages in real time.
- Uses color to visually distinguish log levels (`error`, `info`, `debug`, etc.).

## Setup

1. Ensure Python 3 is available.

2. Install `termcolor` for `el-monitor`:

   ```bash
   pip install termcolor
   ```

3. Create log file:

   ```bash
   sudo touch /var/log/echolog
   sudo chmod 666 /var/log/echolog
   ```

4. Make all scripts executable:

   ```bash
   chmod +x echolog el-server el-monitor
   ```

5. Start the server:

   ```bash
   ./el-server
   ```

6. In separate terminals, run monitors or send logs with `echolog`.

## Example Workflow

1. Start the server:

   ```bash
   ./el-server
   ```

2. Start a monitor:

   ```bash
   ./el-monitor
   ```

3. Send messages:

   ```bash
   ./echolog -t info -m "System initialized"
   ./echolog -t error -m "Something went wrong"
   ```

Monitor will display them in real time with timestamps and colors.

## Bugs

Bug: If no file, it will print so, instead of making a new one.
