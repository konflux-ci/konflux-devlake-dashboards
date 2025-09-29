# Contributing Guide

This guide explains how to add new dashboards to the Apache DevLake Grafana dashboards collection.

## 📝 Adding New Dashboards

### Step 1: Create Dashboard JSON

1. **Export from Grafana**: Create your dashboard in Grafana UI and export as JSON
2. **Place in `dashboards/` folder**: Save as `YourDashboardName.json`
3. **Follow naming convention**: Use PascalCase (e.g., `MyNewDashboard.json`)

### Step 2: Dashboard Requirements

Your dashboard JSON must include:

```json
{
  "annotations": {
    "list": [...]
  },
  "editable": true,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 0,
  "id": null,
  "links": [],
  "liveNow": false,
  "panels": [...],
  "refresh": "30s",
  "schemaVersion": 39,
  "style": "dark",
  "tags": ["devlake"],
  "templating": {
    "list": [...]
  },
  "time": {
    "from": "now-30d",
    "to": "now"
  },
  "timepicker": {...},
  "timezone": "",
  "title": "Your Dashboard Title",
  "uid": "unique-dashboard-id",
  "version": 1,
  "weekStart": ""
}
```

### Step 3: Data Source Configuration

Ensure your dashboard uses the correct data source:

```json
{
  "datasource": {
    "type": "mysql",
    "uid": "mysql"
  }
}
```

### Step 4: SQL Queries

Use DevLake's domain layer schema for queries. Common patterns:

```sql
-- Example: Get deployment frequency
SELECT 
  DATE(finished_date) as date,
  COUNT(*) as deployments
FROM cicd_deployments 
WHERE result = 'SUCCESS'
  AND finished_date >= $__timeFrom()
  AND finished_date <= $__timeTo()
GROUP BY DATE(finished_date)
ORDER BY date
```

### Step 5: Variables and Templating

Add useful variables for filtering:

```json
{
  "templating": {
    "list": [
      {
        "name": "project",
        "type": "query",
        "query": "SELECT DISTINCT name FROM project_mapping",
        "datasource": {"type": "mysql", "uid": "mysql"},
        "refresh": 1,
        "includeAll": true,
        "multi": true
      }
    ]
  }
}
```

### Step 6: Testing

1. **Validate JSON**: Ensure your JSON is valid
2. **Test queries**: Verify SQL queries work with your data
3. **Check variables**: Test all templating variables
4. **Verify layout**: Ensure panels display correctly

## 🤝 Contributing Process

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/my-new-dashboard`
3. **Add your dashboard**: Follow the guidelines above
4. **Test thoroughly**: Ensure it works with sample data
5. **Submit a pull request**: Include description and screenshots

### Pull Request Guidelines

- **Clear description**: Explain what the dashboard does
- **Screenshots**: Include dashboard screenshots
- **Documentation**: Update this README if needed
- **Testing**: Confirm it works with DevLake data

### Review Process

- **Code review**: Dashboard JSON and queries
- **Testing**: Verify with sample data
- **Documentation**: Ensure clear naming and comments
- **Approval**: Maintainer approval required

## 📚 Resources

### DevLake Documentation
- [DevLake Official Website](https://devlake.apache.org/)
- [Data Models & Schema](https://devlake.apache.org/docs/DataModels/DevLakeDomainLayerSchema)
- [Engineering Metrics](https://devlake.apache.org/docs/Metrics)
- [Grafana User Guide](https://devlake.apache.org/docs/Configuration/Dashboards/GrafanaUserGuide)

### Grafana Resources
- [Grafana Documentation](https://grafana.com/docs/)
- [Dashboard Best Practices](https://grafana.com/docs/grafana/latest/best-practices/)
- [Panel Types](https://grafana.com/docs/grafana/latest/panels/)
