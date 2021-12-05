# Termato

Termato is a terminal based countdown timer for the Pomodoro system.

Pomodoro is a time management system that encourages people to work with the
time they have - rather than against it. Using this method, you break your
workday into 25-minute chunks separated by five-minute breaks. These intervals
are referred to as pomodoros.  After about four pomodoros, you take a longer
break of about 15 to 20 minutes.

Termato is written in Elixir, tested only on Linux, used daily in my personal
work.

## Installation

I run Termato from an executable script...

```bash
#!/usr/bin/env elixir

Mix.install([{:termato, github: "andyl/termato"}])

Termato.Application.start_run()
```

Simple!

## Multi Termato

You can run many Termato processes concurrently.  All processes on a
machine will keep in sync with the same time.

With Multi Termato, the leader process runs an HTTP server, and the follower
processes pull their countdown time from the leader.  If the leader dies, the
first follower that successfully starts an HTTP server becomes the new leader.

Check out the `loop` function in the module `Termato.Zookeeper` to see how the
failover works.  Just a few lines of code!

Ambient, ubiquitous Pomodoro!

## Notes

Termato is a nice fit for OTP. It uses a collection of server processes -
Agents, GenServers and Tasks.  To get Termato into shape for wide distribution,
you'd need to find a portable solution for reading single-characters from the
keyboard, which caused me some difficulty.  See my hack in `Util.Kb.getch`.  

## Contributing

PRs and issue welcome!
