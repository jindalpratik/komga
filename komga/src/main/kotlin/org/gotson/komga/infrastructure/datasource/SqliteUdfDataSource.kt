package org.gotson.komga.infrastructure.datasource

import io.github.oshai.kotlinlogging.KotlinLogging
import org.postgresql.ds.PGSimpleDataSource
import java.sql.Connection
import javax.sql.DataSource

private val log = KotlinLogging.logger {}

class SqliteUdfDataSource : PGSimpleDataSource() {
  companion object {
    const val UDF_STRIP_ACCENTS = "udf_strip_accents"
    const val REGEXP_FUNC = "regexp_match_func"
  }

  override fun getConnection(): Connection = super.getConnection().also { initializeCustomFunctions(it) }

  override fun getConnection(username: String?, password: String?): Connection =
    super.getConnection(username, password).also { initializeCustomFunctions(it) }

  private fun initializeCustomFunctions(connection: Connection) {
    try {
      // Enable required extensions
      enableExtensions(connection)
      // Create custom functions if they don't exist
      createCustomFunctions(connection)
    } catch (e: Exception) {
      log.warn(e) { "Failed to initialize custom PostgreSQL functions: ${e.message}" }
    }
  }

  private fun enableExtensions(connection: Connection) {
    log.debug { "Enabling PostgreSQL extensions" }
    connection.createStatement().use { stmt ->
      // Enable unaccent extension for accent removal
      stmt.execute("CREATE EXTENSION IF NOT EXISTS unaccent")
    }
  }

  private fun createCustomFunctions(connection: Connection) {
    log.debug { "Creating custom PostgreSQL functions" }
    connection.createStatement().use { stmt ->

      // Create strip accents function equivalent
      stmt.execute("""
        CREATE OR REPLACE FUNCTION $UDF_STRIP_ACCENTS(input_text text)
        RETURNS text AS $$
        BEGIN
            RETURN unaccent(input_text);
        END;
        $$ LANGUAGE plpgsql IMMUTABLE
      """.trimIndent())

      // Create regex function (though PostgreSQL's ~ operator is preferred)
      stmt.execute("""
        CREATE OR REPLACE FUNCTION $REGEXP_FUNC(pattern text, text_val text)
        RETURNS boolean AS $$
        BEGIN
            RETURN text_val ~* pattern;
        END;
        $$ LANGUAGE plpgsql IMMUTABLE
      """.trimIndent())

      log.debug { "Custom PostgreSQL functions created successfully" }
    }
  }
}
