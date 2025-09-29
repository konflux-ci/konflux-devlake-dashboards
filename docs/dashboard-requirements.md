# Dashboard Requirements

Technical specifications and requirements for Apache DevLake Grafana dashboards.

## 📋 JSON Structure Requirements

### Required Fields

Your dashboard JSON must include these essential fields:

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

### Data Source Configuration

All dashboards must use the MySQL data source:

```json
{
  "datasource": {
    "type": "mysql",
    "uid": "mysql"
  }
}
```

### Panel Requirements

Each panel should include:

```json
{
  "datasource": {
    "type": "mysql",
    "uid": "mysql"
  },
  "gridPos": {
    "h": 8,
    "w": 12,
    "x": 0,
    "y": 0
  },
  "id": 1,
  "options": {...},
  "targets": [
    {
      "datasource": {
        "type": "mysql",
        "uid": "mysql"
      },
      "rawSql": "SELECT ...",
      "refId": "A"
    }
  ],
  "title": "Panel Title",
  "type": "stat"
}
```

## 🗄️ Database Schema

### Common DevLake Tables

Use these tables for your queries:

- `cicd_deployments` - Deployment data
- `cicd_deployment_commits` - Deployment-commit relationships
- `pull_requests` - Pull request data
- `commits` - Commit data
- `issues` - Issue tracking data
- `incidents` - Incident data
- `project_mapping` - Project information
- `repos` - Repository data

### Time Macros

Use Grafana time macros in your SQL:

- `$__timeFrom()` - Start of time range
- `$__timeTo()` - End of time range
- `$__interval` - Auto-calculated interval
- `$__timeFilter(column)` - Time filter for specific column

### Example Queries

```sql
-- Deployment frequency
SELECT 
  DATE(finished_date) as date,
  COUNT(*) as deployments
FROM cicd_deployments 
WHERE result = 'SUCCESS'
  AND finished_date >= $__timeFrom()
  AND finished_date <= $__timeTo()
GROUP BY DATE(finished_date)
ORDER BY date

-- Lead time for changes
SELECT 
  pr.created_date,
  pr.merged_date,
  TIMESTAMPDIFF(HOUR, pr.created_date, pr.merged_date) as lead_time_hours
FROM pull_requests pr
WHERE pr.merged_date IS NOT NULL
  AND pr.created_date >= $__timeFrom()
  AND pr.created_date <= $__timeTo()
ORDER BY pr.created_date

-- Change failure rate
SELECT 
  DATE(d.finished_date) as date,
  COUNT(CASE WHEN d.result = 'FAILURE' THEN 1 END) as failed_deployments,
  COUNT(*) as total_deployments,
  (COUNT(CASE WHEN d.result = 'FAILURE' THEN 1 END) / COUNT(*)) * 100 as failure_rate
FROM cicd_deployments d
WHERE d.finished_date >= $__timeFrom()
  AND d.finished_date <= $__timeTo()
GROUP BY DATE(d.finished_date)
ORDER BY date
```

## 🎨 Visual Requirements

### Color Scheme

Use consistent colors for similar metrics:

- **Success/Positive**: Green (#7EB26D, #EAB839)
- **Warning**: Yellow (#EAB839, #F2CC0C)
- **Error/Negative**: Red (#BF1B00, #E24D42)
- **Info/Neutral**: Blue (#1F78D1, #508642)

### Panel Types

Choose appropriate panel types:

- **Time Series**: For trends over time
- **Stat**: For single values or KPIs
- **Table**: For detailed data lists
- **Bar Chart**: For comparisons
- **Pie Chart**: For distributions
- **Heatmap**: For density data

### Layout Guidelines

- Use 24-column grid system
- Maintain consistent spacing
- Group related panels together
- Use appropriate panel heights (6, 8, 12, 16, 20, 24)

## 🔧 Technical Specifications

### Performance Requirements

- Queries should complete within 30 seconds
- Use appropriate indexes
- Limit result sets when possible
- Use time-based filtering

### Error Handling

- Handle NULL values with `COALESCE()`
- Provide meaningful error messages
- Use fallback values for missing data

### Security

- Use parameterized queries
- Validate input variables
- Follow SQL injection prevention practices
