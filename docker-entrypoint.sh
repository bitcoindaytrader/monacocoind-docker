#!/bin/sh
set -e
MONACOCOIN_DATA=/home/monacocoin/.monacocoin
cd /home/monacocoin/monacocoind

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for monacoCoind"

  set -- monacoCoind "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "monacoCoind" ]; then
  mkdir -p "$MONACOCOIN_DATA"
  chmod 700 "$MONACOCOIN_DATA"
  chown -R monacocoin "$MONACOCOIN_DATA"

  echo "$0: setting data directory to $MONACOCOIN_DATA"

  set -- "$@" -datadir="$MONACOCOIN_DATA"
fi

if [ "$1" = "monacoCoind" ] || [ "$1" = "monacoCoin-cli" ] || [ "$1" = "monacoCoin-tx" ]; then
  echo
  exec gosu monacocoin "$@"
fi

echo
exec "$@"
