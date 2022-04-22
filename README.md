# ksql-migrations-testing-demo
A repo to showcase how to manage ksqlDB in a CI/CD pipeline with testing

The repo gets integrated and deployed through TravisCI onto Confluent Confluent Cloud via a docker build.

## Execution

The execution folder contains all queries that should be posted onto the ksqlDB server to be ran continuously.
All queries are contained within the `migrations` folder as per the structure required by [ksql-migrations](https://docs.ksqldb.io/en/latest/operate-and-deploy/migrations-tool/).

The `ksql-migrations.properties` file contains all necessary connectivity settings.
All state for the tool is maintained server-side, and therefore it is not necessary to see which queries have been previously posted -- ksqlDB will handle finding the difference and applying it. 

Migrations files are *immutable* ksqlDB will not allow changes to previous migration files and will refuse applying such updates; therefore, when an update is needed a new migration file should be created via `ksql-migrations create`.

## Testing

The testing folder contains the necessary files to test topologies. It is organized to test specific migration files and their transformations, with a helper script to run on-PR opening.
The naming convention matters for testing. All testing must occur within folders named as the migration file version, as well as the corresponding inputs to `ksql-test-runner`:

- `${MIGRATIONS_VERSION}_inputs.json` for test inputs to the ksqlDB queries
- `${MIGRATIONS_VERSION}_outputs.json` for test outputs to the ksqlDB queries
- `${MIGRATIONS_VERSION}_SQL.ksql` for test ksqlDB queries

Keep in mind, `ksql-test-runner` is a bit of a pain, and the testing format is limited. The ksqlDB project has planned a new testing tool (YATT) that is planned for release shortly: [KLIP-32](https://github.com/confluentinc/ksql/blob/master/design-proposals/klip-32-sql-testing-tool.md).
