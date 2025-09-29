# Troubleshooting Guide

Common issues and solutions for Apache DevLake Grafana dashboards.

## 🔍 Common Issues

### Dashboard Not Loading

**Symptoms:**
- Dashboard shows "Failed to load dashboard"
- Error messages in browser console
- Blank dashboard screen

**Solutions:**
1. **Check JSON syntax**: Validate your dashboard JSON
   ```bash
   # Use online JSON validator or jq
   jq . your-dashboard.json
   ```

2. **Verify data source**: Ensure MySQL data source is configured
   ```json
   {
     "datasource": {
       "type": "mysql",
       "uid": "mysql"
     }
   }
   ```

3. **Check MySQL connection**: Verify database connectivity
   ```bash
   # Test MySQL connection
   mysql -h your-mysql-host -u merico -p devlake
   ```

### No Data Showing

**Symptoms:**
- Panels show "No data"
- Empty charts and tables
- "Query returned no data" messages

**Solutions:**
1. **Verify SQL queries**: Test queries directly in MySQL
   ```sql
   -- Test your query
   SELECT COUNT(*) FROM cicd_deployments 
   WHERE finished_date >= '2024-01-01';
   ```

2. **Check time range**: Ensure data exists in selected time range
   ```sql
   -- Check data availability
   SELECT 
     MIN(finished_date) as earliest,
     MAX(finished_date) as latest,
     COUNT(*) as total
   FROM cicd_deployments;
   ```

3. **Validate variables**: Check if template variables are populated
   ```sql
   -- Test variable query
   SELECT DISTINCT name FROM project_mapping;
   ```

4. **Check data permissions**: Ensure user has access to required tables

### Performance Issues

**Symptoms:**
- Slow dashboard loading
- Timeout errors
- High CPU usage

**Solutions:**
1. **Optimize SQL queries**:
   ```sql
   -- Add indexes
   CREATE INDEX idx_finished_date ON cicd_deployments(finished_date);
   CREATE INDEX idx_result ON cicd_deployments(result);
   
   -- Use LIMIT for large datasets
   SELECT * FROM large_table LIMIT 1000;
   ```

2. **Reduce data range**: Use shorter time periods
3. **Simplify queries**: Break complex queries into simpler ones
4. **Use sampling**: Sample data for large datasets
5. **Increase refresh interval**: Reduce query frequency

### Variable Issues

**Symptoms:**
- Variables show "No options found"
- Variables don't update
- Wrong variable values

**Solutions:**
1. **Check variable queries**:
   ```sql
   -- Test variable query
   SELECT DISTINCT name FROM project_mapping ORDER BY name;
   ```

2. **Verify data source**: Ensure variable uses correct data source
3. **Check refresh settings**: Set appropriate refresh intervals
4. **Handle NULL values**: Use COALESCE for missing data

## 🔧 Debugging Steps

### 1. Check Grafana Logs
```bash
# Docker logs
docker logs <grafana-container-id>

# Kubernetes logs
kubectl logs deployment/grafana -n grafana
```

### 2. Test Queries
Use Grafana's query inspector:
1. Open dashboard
2. Click on panel
3. Go to "Query" tab
4. Click "Query Inspector"
5. Check for errors and execution time

### 3. Validate Data
```sql
-- Check table structure
DESCRIBE cicd_deployments;

-- Check data availability
SELECT COUNT(*) FROM cicd_deployments;

-- Check time range
SELECT 
  MIN(finished_date) as earliest,
  MAX(finished_date) as latest
FROM cicd_deployments;
```

### 4. Test Variables
```sql
-- Test each variable query individually
SELECT DISTINCT name FROM project_mapping;
SELECT DISTINCT result FROM cicd_deployments;
```

## 🛠️ Advanced Troubleshooting

### Database Connection Issues

**Check connection string:**
```yaml
# In datasource.yml
datasources:
  - name: mysql
    type: mysql
    url: $MYSQL_URL
    database: $MYSQL_DATABASE
    user: $MYSQL_USER
    secureJsonData:
      password: $MYSQL_PASSWORD
```

**Test connection:**
```bash
# Test MySQL connection
mysql -h $MYSQL_URL -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "SELECT 1;"
```

### Memory Issues

**Symptoms:**
- Out of memory errors
- Slow performance
- Crashes

**Solutions:**
1. **Increase memory limits**:
   ```yaml
   # Docker Compose
   services:
     grafana:
       deploy:
         resources:
           limits:
             memory: 2G
   ```

2. **Optimize queries**: Reduce data volume
3. **Use pagination**: Limit result sets
4. **Enable caching**: Use Grafana's query caching

### Permission Issues

**Check user permissions:**
```sql
-- Check user permissions
SHOW GRANTS FOR 'merico'@'%';

-- Grant necessary permissions
GRANT SELECT ON devlake.* TO 'merico'@'%';
FLUSH PRIVILEGES;
```

## 📊 Performance Monitoring

### Query Performance
```sql
-- Check slow queries
SHOW PROCESSLIST;

-- Check query execution time
EXPLAIN SELECT * FROM cicd_deployments WHERE finished_date >= '2024-01-01';
```

### Dashboard Performance
- Monitor panel load times
- Check query execution times
- Monitor memory usage
- Track error rates

## 🆘 Getting Help

### Before Asking for Help
1. Check this troubleshooting guide
2. Verify your configuration
3. Test queries independently
4. Check logs for errors
5. Try with sample data

### When Reporting Issues
Include:
- Dashboard JSON (if applicable)
- Error messages
- Steps to reproduce
- Environment details
- Log excerpts

### Community Resources
- [DevLake Documentation](https://devlake.apache.org/docs/)
- [Grafana Community](https://community.grafana.com/)
- [GitHub Issues](https://github.com/apache/incubator-devlake/issues)

## 🔄 Maintenance

### Regular Checks
- Monitor dashboard performance
- Update queries for schema changes
- Review and optimize slow queries
- Update documentation

### Backup and Recovery
- Export dashboard configurations
- Backup MySQL data
- Document custom configurations
- Test recovery procedures
