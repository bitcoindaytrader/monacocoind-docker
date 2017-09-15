#!/bin/sh
set -e
MONACOCOIN_DATA=/home/monacocoin/.monacocoin
cd /home/monacocoin/monacocoind

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for monacocoind"

  set -- monacocoind "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "monacocoind" ]; then
  mkdir -p "$MONACOCOIN_DATA"
  chmod 700 "$MONACOCOIN_DATA"
  chown -R monacocoin "$MONACOCOIN_DATA"

  echo "$0: setting data directory to $MONACOCOIN_DATA"

  set -- "$@" -datadir="$MONACOCOIN_DATA"
fi

if [ "$1" = "monacocoind" ] || [ "$1" = "monacocoin-cli" ] || [ "$1" = "monacocoin-tx" ]; then
  echo
  exec gosu monacocoin "$@"
fi

echo
exec "$@"
