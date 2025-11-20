# TFA Documentation

Welcome to the TFA project documentation.

## Infrastructure Setup

### Docker Installation on EC2

For deploying the TFA application on Amazon EC2, you need to install Docker and Docker Compose. We provide comprehensive documentation and an automated installation script:

- **[Docker Installation Guide](DOCKER_INSTALLATION.md)** - Complete guide for installing Docker and Docker Compose on EC2
- **[Installation Script](install-docker-ec2.sh)** - Automated installation script for quick setup

#### Quick Start

```bash
# Clone the repository
git clone https://github.com/Sarosh-Madara/tfa.git
cd tfa/docs

# Run the installation script
chmod +x install-docker-ec2.sh
./install-docker-ec2.sh
```

For more details, see the [complete Docker installation guide](DOCKER_INSTALLATION.md).

## Application Configuration

The application uses the following services (configured in `config.php`):
- **Redis** - Caching and session storage
- **RabbitMQ** - Message queuing
- **Soketi** - WebSocket server for real-time features
- **MySQL (AWS RDS)** - Database
- **Python Workers** - AI/OCR processing

## Getting Started

1. Install Docker and Docker Compose (see above)
2. Configure your environment variables in `config.php`
3. Start the application with Docker Compose
4. Access the application at your configured APP_URL

For more information, refer to the main project documentation.