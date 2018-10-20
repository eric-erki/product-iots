ALTER TABLE IDN_OAUTH2_SCOPE RENAME NAME TO DISPLAY_NAME;
ALTER TABLE IDN_OAUTH2_SCOPE RENAME SCOPE_KEY TO NAME;
ALTER TABLE IDN_OAUTH2_SCOPE ALTER COLUMN NAME TYPE VARCHAR(255);
ALTER TABLE IDN_OAUTH2_SCOPE ALTER COLUMN NAME SET NOT NULL;
ALTER TABLE IDN_OAUTH2_SCOPE ALTER COLUMN DISPLAY_NAME TYPE VARCHAR(255);
ALTER TABLE IDN_OAUTH2_SCOPE ALTER COLUMN DISPLAY_NAME SET NOT NULL;
ALTER TABLE IDN_OAUTH2_SCOPE DROP COLUMN ROLES;
UPDATE IDN_OAUTH2_SCOPE SET TENANT_ID = -1 WHERE TENANT_ID = 0;
ALTER TABLE IDN_OAUTH2_SCOPE ALTER COLUMN TENANT_ID TYPE INTEGER;
ALTER TABLE IDN_OAUTH2_SCOPE ALTER COLUMN TENANT_ID SET NOT NULL;
ALTER TABLE IDN_OAUTH2_SCOPE ALTER COLUMN TENANT_ID SET DEFAULT -1;
CREATE UNIQUE INDEX SCOPE_INDEX ON IDN_OAUTH2_SCOPE (NAME, TENANT_ID);

DO $$ DECLARE con_name varchar(200); BEGIN SELECT 'ALTER TABLE idn_oauth2_resource_scope DROP CONSTRAINT ' || tc .constraint_name || ';' INTO con_name FROM information_schema.table_constraints AS tc JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name WHERE constraint_type = 'FOREIGN KEY' AND tc.table_name = 'idn_oauth2_resource_scope' AND ccu.table_name='idn_oauth2_scope' LIMIT 1; EXECUTE con_name; END $$;

ALTER TABLE IDN_OAUTH2_RESOURCE_SCOPE ALTER COLUMN SCOPE_ID TYPE INTEGER;
ALTER TABLE IDN_OAUTH2_RESOURCE_SCOPE ALTER COLUMN SCOPE_ID SET NOT NULL;
ALTER TABLE IDN_OAUTH2_RESOURCE_SCOPE ADD FOREIGN KEY (SCOPE_ID) REFERENCES IDN_OAUTH2_SCOPE(SCOPE_ID) ON DELETE CASCADE;
