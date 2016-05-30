p 'STARTING'
ActiveRecord::Base.connection.execute('
DROP TABLE schema_migrations;
CREATE TABLE schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp without time zone
);
ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);
INSERT INTO "schema_migrations" (version) VALUES (20160513070604);
')
p 'FINISHED'

# RAILS_ENV=development bin/rails runner lib/schema_migrations_change.rb
