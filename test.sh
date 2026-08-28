#!/bin/sh

HOST="aws-1-ap-southeast-1.pooler.supabase.com"
PORT="5432"
USER="postgres.okbnccxznsjmmpfrzxlh"
DATABASE="postgres"

echo "======================================"
echo " Render → Supabase PostgreSQL test"
echo "======================================"

echo ""
echo "[1] DNS lookup"
getent hosts "$HOST"

echo ""
echo "[2] TCP connectivity"
nc -vz -w 10 "$HOST" "$PORT"

echo ""
echo "[3] PostgreSQL readiness"
pg_isready \
  -h "$HOST" \
  -p "$PORT" \
  -U "$USER" \
  -d "$DATABASE"

echo ""
echo "[4] PostgreSQL authentication"

psql \
  "host=$HOST port=$PORT dbname=$DATABASE user=$USER sslmode=require" \
  -c "SELECT current_database(), current_user, version();"

echo ""
echo "======================================"
echo "Test finished"
echo "======================================"

node -e "require('http').createServer((req,res)=>res.end('network-test')).listen(3000,'0.0.0.0')"