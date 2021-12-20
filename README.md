# Termato

Termato is a terminal based countdown timer for the Pomodoro system.

Pomodoro is a time management system that encourages people to work with the
time they have - rather than against it. Using this method, you break your
workday into 25-minute chunks separated by five-minute breaks. These intervals
are referred to as pomodoros.  After about four pomodoros, you take a longer
break of about 15 to 20 minutes.

Termato is written in Elixir, tested only on Linux, used in my personal work.

To get this working, you'll have to have Elixir 1.13+. To get the elixir client
working, you'll need a Ruby environment (for `getch` - see `Util.Kb` for more
info.

## Installation

You can run Termato from an executable script...

```bash
#!/usr/bin/env elixir

Mix.install([{:termato, github: "andyl/termato"}])

Termato.Application.start_run()
```

## Using SystemD

Get started...

- edit the SystemD service file in `rel/termato.service`
- `sudo cp rel/termato.service /etc/systemd/system`
- `sudo chmod 644 /etc/systemd/system/termato.service`

Start the service with SystemD

- `sudo systemctl start termato`
- `sudo systemctl status termato`
- `sudo systemctl restart termato`
- `sudo systemctl stop termato`
- `sudo journalctl -u termato -f`

Make sure your service starts when the system reboots

- `sudo systemctl enable termato`

Reboot and test!

## Websocket Client 

The Termato server has a websocket listener.  There is a client script
`termato_rb` that interacts over websockets. (Ping me if you want access to the
source!)

## Multi Termato

You can run many Termato processes concurrently.  All processes on a
machine will keep in sync with the same time.

With Multi Termato, the leader process runs an HTTP server, and the follower
processes pull their countdown time from the leader.  If the leader dies, the
first follower that successfully starts an HTTP server becomes the new leader.

Check out the `loop` function in the module `Termato.Zookeeper` to see how the
failover works.  Just a few lines of code!

## Contributing

This is mostly for my personal use, not maintained for community access.  But
if you want to use it, go for it. Fork it, submit PRs and issues!
