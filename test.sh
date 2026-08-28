#!/bin/sh

echo "======================================"
echo " Render → Supabase connectivity test"
echo "======================================"

HOST="aws-1-ap-southeast-1.pooler.supabase.com"
PORT="5432"

echo ""
echo "[1] DNS lookup"
getent hosts "$HOST" || true

echo ""
echo "[2] TCP connectivity"
nc -vz -w 10 "$HOST" "$PORT"

echo ""
echo "[3] PostgreSQL readiness"
pg_isready -h "$HOST" -p "$PORT"

echo ""
echo "======================================"
echo "Test finished"
echo "======================================"

# Keep Render Web Service alive
node -e "require('http').createServer((req,res)=>res.end('network-test')).listen(3000,'0.0.0.0')"