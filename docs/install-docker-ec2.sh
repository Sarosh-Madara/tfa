#!/bin/bash

# Docker & Docker Compose Installation Script for EC2
# Supports Amazon Linux 2, Amazon Linux 2023, and Ubuntu
# Author: TFA Project
# Description: Automated installation of Docker and Docker Compose on EC2 instances

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VERSION=$VERSION_ID
    else
        log_error "Cannot detect OS. /etc/os-release not found."
        exit 1
    fi
    
    log_info "Detected OS: $OS $VERSION"
}

# Install Docker on Amazon Linux 2
install_docker_amazon_linux_2() {
    log_info "Installing Docker on Amazon Linux 2..."
    
    # Update system packages
    sudo yum update -y
    
    # Install Docker
    sudo yum install -y docker
    
    # Start Docker service
    sudo systemctl start docker
    sudo systemctl enable docker
    
    # Add current user to docker group
    sudo usermod -aG docker $USER
    
    log_info "Docker installed successfully on Amazon Linux 2"
}

# Install Docker on Amazon Linux 2023
install_docker_amazon_linux_2023() {
    log_info "Installing Docker on Amazon Linux 2023..."
    
    # Update system packages
    sudo yum update -y
    
    # Install Docker
    sudo yum install -y docker
    
    # Start Docker service
    sudo systemctl start docker
    sudo systemctl enable docker
    
    # Add current user to docker group
    sudo usermod -aG docker $USER
    
    log_info "Docker installed successfully on Amazon Linux 2023"
}

# Install Docker on Ubuntu
install_docker_ubuntu() {
    log_info "Installing Docker on Ubuntu..."
    
    # Update package index
    sudo apt-get update -y
    
    # Install required packages
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    
    # Add Docker's official GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    
    # Set up the repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Update package index again
    sudo apt-get update -y
    
    # Install Docker Engine
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Start Docker service
    sudo systemctl start docker
    sudo systemctl enable docker
    
    # Add current user to docker group
    sudo usermod -aG docker $USER
    
    log_info "Docker installed successfully on Ubuntu"
}

# Install Docker Compose
install_docker_compose() {
    log_info "Installing Docker Compose..."
    
    # Get latest version of Docker Compose
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    
    if [ -z "$DOCKER_COMPOSE_VERSION" ]; then
        log_warn "Could not fetch latest Docker Compose version. Using v2.24.0"
        DOCKER_COMPOSE_VERSION="v2.24.0"
    fi
    
    log_info "Installing Docker Compose version: $DOCKER_COMPOSE_VERSION"
    
    # Download Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    
    # Make it executable
    sudo chmod +x /usr/local/bin/docker-compose
    
    # Create symlink for compatibility
    sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
    
    log_info "Docker Compose installed successfully"
}

# Verify installation
verify_installation() {
    log_info "Verifying Docker installation..."
    
    # Check Docker version
    if command -v docker &> /dev/null; then
        DOCKER_VERSION=$(docker --version)
        log_info "Docker version: $DOCKER_VERSION"
    else
        log_error "Docker is not installed or not in PATH"
        exit 1
    fi
    
    # Check Docker Compose version
    if command -v docker-compose &> /dev/null; then
        DOCKER_COMPOSE_VERSION=$(docker-compose --version)
        log_info "Docker Compose version: $DOCKER_COMPOSE_VERSION"
    else
        log_error "Docker Compose is not installed or not in PATH"
        exit 1
    fi
    
    # Check Docker service status
    if sudo systemctl is-active --quiet docker; then
        log_info "Docker service is running"
    else
        log_error "Docker service is not running"
        exit 1
    fi
}

# Main installation function
main() {
    log_info "Starting Docker and Docker Compose installation on EC2..."
    
    # Detect OS
    detect_os
    
    # Install Docker based on OS
    case "$OS" in
        amzn)
            if [[ "$VERSION" == "2" ]]; then
                install_docker_amazon_linux_2
            elif [[ "$VERSION" == "2023" ]]; then
                install_docker_amazon_linux_2023
            else
                log_error "Unsupported Amazon Linux version: $VERSION"
                exit 1
            fi
            ;;
        ubuntu)
            install_docker_ubuntu
            ;;
        *)
            log_error "Unsupported OS: $OS"
            log_error "This script supports Amazon Linux 2, Amazon Linux 2023, and Ubuntu"
            exit 1
            ;;
    esac
    
    # Install Docker Compose
    install_docker_compose
    
    # Verify installation
    verify_installation
    
    log_info "==================================================================="
    log_info "Docker and Docker Compose installation completed successfully!"
    log_info "==================================================================="
    log_warn "IMPORTANT: You need to log out and log back in for group changes to take effect"
    log_warn "           OR run: newgrp docker"
    log_info "==================================================================="
    log_info "Quick test: docker run hello-world"
    log_info "==================================================================="
}

# Run main function
main
