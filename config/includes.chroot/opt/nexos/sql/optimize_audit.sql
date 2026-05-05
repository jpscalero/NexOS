-- ============================================================
-- NexOS — Database Optimization and Audit Roles
-- Apply this to PostgreSQL and MariaDB after installation
-- ============================================================

-- ==========================================
-- PostgreSQL Configuration
-- ==========================================
-- Note: Buffer configurations usually go in postgresql.conf.
-- The following SQL demonstrates role creation.

-- Create an Audit Role (Read-Only across all tables)
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'nexos_audit') THEN
    CREATE ROLE nexos_audit WITH LOGIN PASSWORD 'Aud1t!N3x0s_S3cur3' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
  END IF;
END
$$;

-- Grant usage on schemas and select on all current/future tables in public schema
GRANT USAGE ON SCHEMA public TO nexos_audit;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO nexos_audit;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO nexos_audit;


-- ==========================================
-- MariaDB Configuration
-- ==========================================
-- Create Audit User
CREATE USER IF NOT EXISTS 'nexos_audit'@'localhost' IDENTIFIED BY 'Aud1t!N3x0s_S3cur3';

-- Grant SELECT privileges to the audit user globally
GRANT SELECT, SHOW VIEW ON *.* TO 'nexos_audit'@'localhost';
FLUSH PRIVILEGES;

-- MariaDB Buffer optimization (These are typically SET GLOBAL or in my.cnf, shown here for reference)
-- SET GLOBAL innodb_buffer_pool_size = 1073741824; -- 1GB
-- SET GLOBAL innodb_log_file_size = 268435456;    -- 256MB
-- SET GLOBAL query_cache_size = 0;                -- Disabled in modern configs
-- SET GLOBAL query_cache_type = 0;
