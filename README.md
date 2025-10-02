# Apache DevLake Grafana Dashboards

A comprehensive collection of Grafana dashboards for [Apache DevLake](https://devlake.apache.org/), providing insights into software development metrics, DORA metrics, and engineering productivity.

## 🚀 Quick Start

### Using Podman

```bash
# Build and run the Grafana container with all dashboards
podman build -t devlake-grafana .
podman run -p 3000:3000 devlake-grafana
```

Access Grafana at `http://localhost:3000` (admin/admin)

### Using Docker Compose

```yaml
version: '3.8'
services:
  grafana:
    build: .
    ports:
      - "3000:3000"
    environment:
      - MYSQL_URL=your-mysql-host:3306
      - MYSQL_DATABASE=devlake
      - MYSQL_USER=merico
      - MYSQL_PASSWORD=merico
```

## 📊 Available Dashboards

### Core Dashboards

- **Homepage** - Main landing page with overview
- **DORA** - DORA metrics (Deployment Frequency, Lead Time, Change Failure Rate, MTTR)
- **Engineering Overview** - High-level engineering metrics

### Data Source Specific

- **GitHub** - GitHub-specific metrics and insights
- **GitLab** - GitLab CI/CD and repository metrics
- **Jira** - Issue tracking and project management
- **Jenkins** - Build and deployment metrics

### Specialized Dashboards

- **Contributor Experience** - Developer productivity metrics
- **Weekly Bug Retro** - Bug tracking and analysis
- **SonarQube** - Code quality and security metrics

## 🔧 Configuration

Set these environment variables for your MySQL connection:

```bash
export MYSQL_URL=your-mysql-host:3306
export MYSQL_DATABASE=devlake
export MYSQL_USER=merico
export MYSQL_PASSWORD=merico
```

## 📝 Adding New Dashboards

1. **Create your dashboard** in Grafana UI and export as JSON
2. **Place in `dashboards/` folder** as `YourDashboardName.json`
3. **Follow naming convention**: Use PascalCase (e.g., `MyNewDashboard.json`)
4. **Test thoroughly** with your DevLake data

For detailed instructions, see [Contributing Guide](docs/contributing.md).

## 📚 Documentation

- [Contributing Guide](docs/contributing.md) - How to add new dashboards
- [Dashboard Requirements](docs/dashboard-requirements.md) - Technical specifications
- [Best Practices](docs/best-practices.md) - Design and development guidelines
- [Troubleshooting](docs/troubleshooting.md) - Common issues and solutions

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](docs/contributing.md) for details.

1. Fork the repository
2. Create a feature branch
3. Add your dashboard following our guidelines
4. Submit a pull request

## 📄 License

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

- [Apache DevLake](https://devlake.apache.org/) - The core platform
- [Grafana](https://grafana.com/) - Visualization platform
- Community contributors who created these dashboards