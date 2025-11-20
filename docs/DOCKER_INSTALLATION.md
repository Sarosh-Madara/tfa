# Docker & Docker Compose Installation Guide for EC2

This guide provides instructions for installing Docker and Docker Compose on Amazon EC2 instances.

## Supported Operating Systems

- Amazon Linux 2
- Amazon Linux 2023
- Ubuntu (18.04, 20.04, 22.04, 24.04)

## Quick Installation (Automated)

### Option 1: Using the Installation Script

We provide an automated installation script that handles everything for you:

```bash
# Download and run the installation script
curl -o install-docker-ec2.sh https://raw.githubusercontent.com/Sarosh-Madara/tfa/main/docs/install-docker-ec2.sh
chmod +x install-docker-ec2.sh
./install-docker-ec2.sh
```

Or if you have cloned the repository:

```bash
cd docs
chmod +x install-docker-ec2.sh
./install-docker-ec2.sh
```

**After installation, log out and log back in** for group changes to take effect, or run:
```bash
newgrp docker
```

### Option 2: Manual Installation

If you prefer to install manually, follow the instructions below for your specific OS.

---

## Manual Installation Instructions

### Amazon Linux 2 / Amazon Linux 2023

1. **Update system packages:**
   ```bash
   sudo yum update -y
   ```

2. **Install Docker:**
   ```bash
   sudo yum install -y docker
   ```

3. **Start Docker service:**
   ```bash
   sudo systemctl start docker
   sudo systemctl enable docker
   ```

4. **Add your user to the docker group:**
   ```bash
   sudo usermod -aG docker $USER
   ```

5. **Install Docker Compose:**
   ```bash
   # Get the latest version
   DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
   
   # Download Docker Compose
   sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   
   # Make it executable
   sudo chmod +x /usr/local/bin/docker-compose
   
   # Create symlink
   sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
   ```

6. **Log out and log back in** for group changes to take effect.

---

### Ubuntu (18.04, 20.04, 22.04, 24.04)

1. **Update package index:**
   ```bash
   sudo apt-get update -y
   ```

2. **Install required packages:**
   ```bash
   sudo apt-get install -y \
       ca-certificates \
       curl \
       gnupg \
       lsb-release
   ```

3. **Add Docker's official GPG key:**
   ```bash
   sudo install -m 0755 -d /etc/apt/keyrings
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   sudo chmod a+r /etc/apt/keyrings/docker.gpg
   ```

4. **Set up the Docker repository:**
   ```bash
   echo \
     "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```

5. **Update package index again:**
   ```bash
   sudo apt-get update -y
   ```

6. **Install Docker Engine and Docker Compose:**
   ```bash
   sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
   ```

7. **Start Docker service:**
   ```bash
   sudo systemctl start docker
   sudo systemctl enable docker
   ```

8. **Add your user to the docker group:**
   ```bash
   sudo usermod -aG docker $USER
   ```

9. **Log out and log back in** for group changes to take effect.

---

## Verification

After installation, verify that Docker and Docker Compose are installed correctly:

1. **Check Docker version:**
   ```bash
   docker --version
   ```
   Expected output: `Docker version 24.x.x, build ...`

2. **Check Docker Compose version:**
   ```bash
   docker-compose --version
   ```
   Expected output: `Docker Compose version v2.x.x`

3. **Check Docker service status:**
   ```bash
   sudo systemctl status docker
   ```
   Should show "active (running)"

4. **Test Docker installation:**
   ```bash
   docker run hello-world
   ```
   This should download and run a test container.

---

## Post-Installation Configuration

### Enable Docker to Start on Boot

```bash
sudo systemctl enable docker
```

### Configure Docker for Production Use

1. **Limit log file size** (recommended for production):
   
   Create or edit `/etc/docker/daemon.json`:
   ```bash
   sudo mkdir -p /etc/docker
   sudo tee /etc/docker/daemon.json > /dev/null <<EOF
   {
     "log-driver": "json-file",
     "log-opts": {
       "max-size": "10m",
       "max-file": "3"
     }
   }
   EOF
   ```

2. **Restart Docker to apply changes:**
   ```bash
   sudo systemctl restart docker
   ```

### Security Considerations

1. **Always use the latest versions** of Docker and Docker Compose
2. **Limit access** to the Docker socket
3. **Use Docker Content Trust** for image verification in production
4. **Configure firewall rules** appropriately for your EC2 security group

---

## Running the TFA Application

Once Docker and Docker Compose are installed, you can run the TFA application with the required services:

1. **Ensure you have a docker-compose.yml file** configured with:
   - Redis
   - RabbitMQ
   - Soketi (WebSocket server)
   - PHP application

2. **Start the application:**
   ```bash
   docker-compose up -d
   ```

3. **Check running containers:**
   ```bash
   docker ps
   ```

4. **View logs:**
   ```bash
   docker-compose logs -f
   ```

---

## Troubleshooting

### Permission Denied Error

If you get a permission denied error when running docker commands:

1. Make sure you're in the docker group:
   ```bash
   groups
   ```

2. If docker is not listed, add yourself again:
   ```bash
   sudo usermod -aG docker $USER
   ```

3. Log out and log back in, or run:
   ```bash
   newgrp docker
   ```

### Docker Service Won't Start

1. Check service status:
   ```bash
   sudo systemctl status docker
   ```

2. Check Docker logs:
   ```bash
   sudo journalctl -u docker
   ```

3. Restart the service:
   ```bash
   sudo systemctl restart docker
   ```

### Docker Compose Command Not Found

If `docker-compose` command is not found:

1. Check if it's installed:
   ```bash
   which docker-compose
   ```

2. If not found, reinstall using the installation script or manual steps above.

3. For Ubuntu with Docker Compose plugin, you can use:
   ```bash
   docker compose version  # Note: no hyphen
   ```

---

## Uninstallation (if needed)

### Amazon Linux

```bash
sudo yum remove docker
sudo rm -rf /var/lib/docker
sudo rm -rf /usr/local/bin/docker-compose
```

### Ubuntu

```bash
sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
```

---

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)

---

## Support

For issues or questions related to this installation guide, please open an issue in the TFA repository.
