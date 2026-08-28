echo ""
echo "[5] Node.js pg test"

node <<'NODE'
const { Client } = require('pg');

const client = new Client({
  host: 'aws-1-ap-southeast-1.pooler.supabase.com',
  port: 5432,
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