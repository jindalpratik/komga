package org.gotson.komga.infrastructure.datasource

import com.zaxxer.hikari.HikariConfig
import com.zaxxer.hikari.HikariDataSource
import org.gotson.komga.infrastructure.configuration.KomgaProperties
import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties
import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.boot.jdbc.DataSourceBuilder
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Primary
import org.springframework.core.env.Environment
import org.sqlite.SQLiteDataSource
import javax.sql.DataSource

@Configuration
class DataSourcesConfiguration(
  private val komgaProperties: KomgaProperties,
  private val environment: Environment,
) {
  @Bean("sqliteDataSource")
  @Primary
  fun sqliteDataSource(): DataSource {
    // Check if PostgreSQL is configured via standard Spring datasource properties
    val springDatasourceUrl = environment.getProperty("spring.datasource.url")

    return buildPostgresDataSource("PostgresMainPool")
  }

  @Bean("tasksDataSource")
  fun tasksDataSource(): DataSource =
    buildSqliteDataSource("SqliteTasksPool", SQLiteDataSource::class.java, komgaProperties.tasksDb)
      .apply {
        // force pool size to 1 for tasks datasource
        this.maximumPoolSize = 1
      }

  private fun buildPostgresDataSource(poolName: String): HikariDataSource {
    val config = HikariConfig().apply {
      // Use Spring Boot's standard datasource properties
      jdbcUrl = environment.getProperty("spring.datasource.url") ?: "jdbc:postgresql://localhost:5432/komga"
      username = environment.getProperty("spring.datasource.username") ?: "postgres"
      password = environment.getProperty("spring.datasource.password") ?: "password"
      driverClassName = "org.postgresql.Driver"

      // Pool configuration from Spring Boot Hikari properties or defaults
      this.poolName = poolName
      this.maximumPoolSize = environment.getProperty("spring.datasource.hikari.maximum-pool-size", Int::class.java)
        ?: komgaProperties.database.maxPoolSize.coerceAtLeast(10)
      this.minimumIdle = environment.getProperty("spring.datasource.hikari.minimum-idle", Int::class.java)
        ?: (this.maximumPoolSize * 0.25).toInt().coerceAtLeast(2)

      // Connection timeout settings
      connectionTimeout = environment.getProperty("spring.datasource.hikari.connection-timeout", Long::class.java) ?: 30000
      idleTimeout = environment.getProperty("spring.datasource.hikari.idle-timeout", Long::class.java) ?: 600000
      maxLifetime = environment.getProperty("spring.datasource.hikari.max-lifetime", Long::class.java) ?: 1800000

      // PostgreSQL-specific optimizations[7][9]
      addDataSourceProperty("cachePrepStmts", "true")
      addDataSourceProperty("prepStmtCacheSize", "250")
      addDataSourceProperty("prepStmtCacheSqlLimit", "2048")
      addDataSourceProperty("useServerPrepStmts", "true")
      addDataSourceProperty("rewriteBatchedStatements", "true")

      // Additional performance settings
      leakDetectionThreshold = environment.getProperty("spring.datasource.hikari.leak-detection-threshold", Long::class.java) ?: 300000
    }

    return HikariDataSource(config)
  }

  private fun buildSqliteDataSource(
    poolName: String,
    dataSourceClass: Class<out SQLiteDataSource>,
    databaseProps: KomgaProperties.Database,
  ): HikariDataSource {
    val extraPragmas =
      databaseProps.pragmas.let {
        if (it.isEmpty())
          ""
        else
          "?" + it.map { (key, value) -> "$key=$value" }.joinToString(separator = "&")
      }

    val dataSource =
      DataSourceBuilder
        .create()
        .driverClassName("org.sqlite.JDBC")
        .url("jdbc:sqlite:${databaseProps.file}$extraPragmas")
        .type(dataSourceClass)
        .build()

    with(dataSource) {
      setEnforceForeignKeys(true)
      setGetGeneratedKeys(false)
    }
    with(databaseProps) {
      journalMode?.let { dataSource.setJournalMode(it.name) }
      busyTimeout?.let { dataSource.config.busyTimeout = it.toMillis().toInt() }
    }

    val poolSize =
      if (databaseProps.file.contains(":memory:") || databaseProps.file.contains("mode=memory"))
        1
      else if (databaseProps.poolSize != null)
        databaseProps.poolSize!!
      else
        Runtime.getRuntime().availableProcessors().coerceAtMost(databaseProps.maxPoolSize.coerceAtLeast(10))

    return HikariDataSource(
      HikariConfig().apply {
        this.dataSource = dataSource
        this.poolName = poolName
        this.maximumPoolSize = poolSize
      },
    )
  }
}
