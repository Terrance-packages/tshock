#!/usr/bin/env sh

HOME='/var/lib/tshock'
CONFDIR='/etc/conf.d/tshock'

INSTANCE="${2:-default}"
if [ -r ${CONFDIR}/${INSTANCE}.conf ]; then
    . ${CONFDIR}/${INSTANCE}.conf
fi

TMUX_CONSOLE=tshock-console-${INSTANCE}

## The following parameters can be added to TShock to alter the way a server initializes.
## Options set via the command line will override all configuration options regardless.
## These can be used either for personal use or in a GSP environment for easier hosting without hassle:
## Terraria Server API Command Line:
##   -ip <ipv4>          - Starts the server bound to a given IPv4 address
##   -port <port>        - Starts the server bound to a given port
##   -maxplayers <count> - Starts the server with a given player count
##   -world <file.wld>   - Starts the server and immediately loads a given
##                         world file
##   -worldpath <path>   - Starts the server and changes the world path to a
##                         given path
##   -autocreate <1/2/3> - Starts the server and, if a world file isn't found,
##                         automatically create the world file with a given
##                         size, 1-3, 1 being small.
##   -config <file>      - Starts the server with a given config file
##   -connperip <n>      - Allows n number of connections per IP.
##   -killinactivesocket - Kills connections which have not started the
##                         protocol handshake.
##   -lang <type>        - Sets the server's language.
##   -ignoreversion      - Ignores API version checks for plugins allowing for
##                         old plugins to run.
##   -forceupdate        - Forces the server to continue running, and not
##                         hibernating when no players are on. This results in
##                         time passing, grass growing, and cpu running.
## TShock Command Line:
##   -configpath <path>     - The path tshock uses to resolve configs, log
##                            files, and sqlite db.
##   -worldpath <path>      - The path that Terraria Server uses to find all
##                            world files.
##   -logpath <path>        - Overrides the default log path and saves logs
##                            here.
##   -logformat <format>    - Format the name of log files, subject to C# date
##                            standard abbreviations,
##   -logclear <true/false> - Overwrites old config if it exists.
##   -dump                  - Dumps permissions and config file descriptions for
##                            wiki use.

case "$1" in
    start)
        if tmux has-session -t ${TMUX_CONSOLE} &> /dev/null ; then
            echo "TShock instance '$INSTANCE' is already running"
            exit 1
        fi
        mkdir -p "${BASEDIR:=$HOME/servers/$INSTANCE}"
        tmux new-session -d -s ${TMUX_CONSOLE} -c "${BASEDIR}" \
            /opt/tshock/TShock.Server \
                -port "${PORT:-7777}" \
                -world "${WORLDDIR:=$HOME/.local/share/Terraria/Worlds}/${WORLD:-$INSTANCE}.wld" \
                -autocreate "${SIZE:-2}"
        if [ $? -gt 0 ]; then
            echo "Could not start instance"
            exit 1
        fi
        ;;

    stop)
        if ! tmux has-session -t ${TMUX_CONSOLE} &> /dev/null ; then
            echo "TShock instance '$INSTANCE' is not running"
            exit 1
        fi
        tmux send-keys -t ${TMUX_CONSOLE} 'broadcast NOTICE: Server shutting down in 5 seconds!' C-m
        echo 'Server shutting down in 5 seconds'
        sleep 5
        tmux send-keys -t ${TMUX_CONSOLE} 'exit' C-m
        ;;

    console)
        if ! tmux has-session -t ${TMUX_CONSOLE} &> /dev/null ; then
            echo "TShock instance '$INSTANCE' is not running"
            exit 1
        fi
        tmux attach -t ${TMUX_CONSOLE}
        ;;

    *)
        echo "usage: $0 {start|backup|console} [instance]"
esac

exit 0
