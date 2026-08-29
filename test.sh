#!/bin/sh

HOST="aws-1-ap-southeast-1.pooler.supabase.com"
PORT="6543"
USER="postgres.okbnccxznsjmmpfrzxlh"
DATABASE="postgres"

echo "======================================"
echo " Render → Supabase PostgreSQL test"
echo "======================================"

echo ""
echo "[1/5] DNS lookup"
getent hosts "$HOST"

echo ""
echo "[2/5] TCP connectivity"
nc -vz -w 10 "$HOST" "$PORT"

echo ""
echo "[3/5] PostgreSQL readiness"
pg_isready \
  -h "$HOST" \
  -p "$PORT" \
  -U "$USER" \
  -d "$DATABASE"

echo ""
echo "[4/5] PostgreSQL authentication"

psql \
  "host=$HOST port=$PORT dbname=$DATABASE user=$USER sslmode=require" \
  -c "SELECT current_database(), current_user, version();"

echo ""
echo "[5/5] Node.js pg test"

node <<'NODE'
const { Client } = require('pg');

const client = new Client({
  host: 'aws-1-ap-southeast-1.pooler.supabase.com',
  port: 6543,
  database: 'postgres',
  user: 'postgres.okbnccxznsjmmpfrzxlh',
  password: process.env.PGPASSWORD,
  ssl: {
    rejectUnauthorized: false
  },
  connectionTimeoutMillis: 10000
});

(async () => {
  try {
    await client.connect();

    const result = await client.query(
      'SELECT current_database(), current_user, version()'
    );

    console.log(result.rows);

    await client.end();

    console.log('NODE PG CONNECTION: SUCCESS');
  } catch (err) {
    console.error('NODE PG CONNECTION: FAILED');
    console.error(err);
    process.exit(1);
  }
})();
NODE

echo ""
echo "======================================"
echo "All tests finished"
echo "======================================"

node -e "require('http').createServer((req,res)=>res.end('network-test')).listen(3000,'0.0.0.0')"