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
import javax.sql.DataSource

@Configuration
class DataSourcesConfiguration(
  private val komgaProperties: KomgaProperties,
  private val environment: Environment,
) {
  @Bean("postgresDataSource")
  @Primary
  fun postgresDataSource(): DataSource {
    // Check if PostgreSQL is configured via standard Spring datasource properties
    val springDatasourceUrl = environment.getProperty("spring.datasource.url")

    return buildPostgresDataSource("PostgresMainPool")
  }

  private fun buildPostgresDataSource(poolName: String): HikariDataSource {
    val config = HikariConfig().apply {
      // Use Spring Boot's standard datasource properties
      jdbcUrl = "jdbc:postgresql://localhost:5432/komga"
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
}

