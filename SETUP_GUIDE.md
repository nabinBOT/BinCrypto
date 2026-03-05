# Cryptographically Secure Document System - Complete Setup Guide

## Overview

This is a comprehensive ethical hacking cryptography tool that implements a complete Public Key Infrastructure (PKI) system with document signing, encryption, and audit capabilities. The system features a modern web interface built with React and Flask, providing all the functionality specified in the original documentation.

## Features

### Core Cryptographic Features
- **Certificate Authority Management**: Create and manage Root and Intermediate CAs
- **Certificate Lifecycle**: Issue, revoke, and manage X.509 certificates
- **Document Signing**: Digital signatures with detached signature support
- **Document Encryption**: Hybrid encryption using AES-256-GCM + RSA/ECC
- **Document Verification**: Signature and certificate validation
- **Hash Functions**: SHA-256, SHA-384, SHA-512 support
- **Audit Logging**: Tamper-evident audit trail with cryptographic integrity

### Web Interface Features
- **Professional Dashboard**: Real-time system overview with charts and statistics
- **Certificate Authority Management**: Complete CA operations through web UI
- **Document Operations**: Upload, sign, encrypt, decrypt, and verify documents
- **Audit Logs**: Browse, search, filter, and export audit events
- **Responsive Design**: Works on desktop and mobile devices
- **Real-time Updates**: Live status updates and notifications

## System Requirements

### Operating System
- Ubuntu 22.04 LTS (recommended)
- Other Linux distributions with Python 3.11+
- macOS 10.15+ (with Homebrew)
- Windows 10+ (with WSL2 recommended)

### Software Dependencies
- Python 3.11 or higher
- Node.js 20.x or higher
- SQLite 3.x (included with Python)
- Modern web browser (Chrome, Firefox, Safari, Edge)

### Hardware Requirements
- Minimum: 2GB RAM, 1GB disk space
- Recommended: 4GB RAM, 2GB disk space
- Network access for package installation

## Installation Guide

### Step 1: System Preparation

#### Ubuntu/Debian
```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install required system packages
sudo apt install -y python3.11 python3.11-venv python3.11-dev \
    build-essential libssl-dev libffi-dev pkg-config \
    nodejs npm git curl wget

# Install Node.js 20.x if not available
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### CentOS/RHEL/Fedora
```bash
# Update system packages
sudo dnf update -y

# Install required packages
sudo dnf install -y python3.11 python3.11-devel python3.11-pip \
    gcc gcc-c++ openssl-devel libffi-devel pkgconfig \
    nodejs npm git curl wget

# Install Node.js 20.x if needed
curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
sudo dnf install -y nodejs
```

#### macOS
```bash
# Install Homebrew if not installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required packages
brew install python@3.11 node@20 git

# Add to PATH
echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Step 2: Download and Setup

```bash
# Create project directory
mkdir -p ~/cryptography-tool
cd ~/cryptography-tool

# Download the tool files (assuming they're provided)
# Or clone from repository:
# git clone <repository-url> .

# Verify Python version
python3.11 --version  # Should show Python 3.11.x

# Verify Node.js version
node --version  # Should show v20.x.x
npm --version   # Should show 10.x.x
```


### Step 3: Backend Setup (Flask Application)

```bash
# Navigate to the backend directory
cd cryptography_tool

# Create Python virtual environment
python3.11 -m venv venv

# Activate virtual environment
source venv/bin/activate  # On Linux/macOS
# OR
venv\Scripts\activate     # On Windows

# Upgrade pip
pip install --upgrade pip

# Install Python dependencies
pip install -r requirements.txt

# If requirements.txt is not available, install manually:
pip install flask flask-cors flask-sqlalchemy \
    cryptography pycryptodome python-dateutil \
    werkzeug requests

# Initialize the database
python src/main.py --init-db  # If this option exists
# OR manually create database by running the app once
```

### Step 4: Frontend Setup (React Application)

```bash
# Navigate to frontend directory
cd ../crypto-frontend

# Install Node.js dependencies
npm install
# OR if using pnpm
pnpm install

# Build the production version
npm run build
# OR
pnpm run build

# Copy built files to Flask static directory
cp -r dist/* ../cryptography_tool/src/static/
```

### Step 5: Configuration

#### Database Configuration
The application uses SQLite by default. The database file will be created automatically at:
```
cryptography_tool/instance/certificates.db
```

#### Security Configuration
Create a `.env` file in the `cryptography_tool` directory:
```bash
# Create environment file
cat > .env << EOF
# Flask Configuration
FLASK_ENV=production
FLASK_DEBUG=false
SECRET_KEY=$(python -c "import secrets; print(secrets.token_hex(32))")

# Database Configuration
DATABASE_URL=sqlite:///instance/certificates.db

# Security Settings
CERTIFICATE_STORAGE_PATH=./certificates
PRIVATE_KEY_STORAGE_PATH=./private_keys
AUDIT_LOG_RETENTION_DAYS=365

# Web Server Configuration
HOST=0.0.0.0
PORT=5000
EOF
```

#### Directory Structure Setup
```bash
# Create necessary directories
mkdir -p cryptography_tool/certificates
mkdir -p cryptography_tool/private_keys
mkdir -p cryptography_tool/instance
mkdir -p cryptography_tool/logs

# Set proper permissions
chmod 700 cryptography_tool/private_keys
chmod 755 cryptography_tool/certificates
```

## Running the Application

### Development Mode

#### Start Backend Server
```bash
cd cryptography_tool
source venv/bin/activate
python src/main.py
```

The Flask server will start on `http://localhost:5000`

#### Start Frontend Development Server (Optional)
```bash
cd crypto-frontend
npm run dev
# OR
pnpm run dev
```

The React development server will start on `http://localhost:3000` (if running separately)

### Production Mode

#### Using Built-in Flask Server
```bash
cd cryptography_tool
source venv/bin/activate
python src/main.py
```

#### Using Gunicorn (Recommended for Production)
```bash
# Install Gunicorn
pip install gunicorn

# Run with Gunicorn
gunicorn --bind 0.0.0.0:5000 --workers 4 src.main:app
```

#### Using systemd Service (Linux)
Create a systemd service file:
```bash
sudo tee /etc/systemd/system/cryptography-tool.service << EOF
[Unit]
Description=Cryptography Tool Web Application
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/cryptography-tool/cryptography_tool
Environment=PATH=/home/ubuntu/cryptography-tool/cryptography_tool/venv/bin
ExecStart=/home/ubuntu/cryptography-tool/cryptography_tool/venv/bin/gunicorn --bind 0.0.0.0:5000 --workers 4 src.main:app
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable cryptography-tool
sudo systemctl start cryptography-tool

# Check status
sudo systemctl status cryptography-tool
```

## First-Time Setup and Usage

### Step 1: Access the Web Interface
Open your web browser and navigate to:
```
http://localhost:5000
```

### Step 2: Initialize Root Certificate Authority
1. Click on "Certificate Authority" in the navigation
2. Go to the "Root CA" tab
3. Fill in the form:
   - **Common Name**: Your organization's root CA name (e.g., "My Organization Root CA")
   - **Validity (days)**: 3650 (10 years, default)
   - **Key Password**: Leave empty for no password protection
4. Click "Initialize Root CA"
5. The system will generate a root certificate and private key

### Step 3: Create Intermediate CA (Optional but Recommended)
1. Go to the "Intermediate CA" tab
2. Fill in the form:
   - **Common Name**: Intermediate CA name (e.g., "My Organization Intermediate CA")
   - **Root CA Serial Number**: Copy from the root CA certificate details
   - **Validity (days)**: 1825 (5 years, default)
   - **Root CA Key Password**: Enter if you set one for the root CA
3. Click "Initialize Intermediate CA"

### Step 4: Generate User Certificates
1. Go to the "Certificates" tab
2. In the "Generate Certificate Signing Request" section:
   - **Common Name**: User identifier (e.g., "user@example.com")
   - **Key Type**: RSA (recommended) or ECC
   - **Key Size**: 2048 bits (recommended) or 4096 bits
3. Click "Generate CSR"
4. The system will download the CSR and private key files
5. In the "Issue Certificate" section:
   - Paste the CSR content
   - Enter the issuer serial number (from CA certificate)
   - Set validity period
   - Enter CA key password if required
6. Click "Issue Certificate"
7. The system will download the issued certificate

## Using the System

### Document Signing
1. Go to "Document Operations" → "Sign" tab
2. Upload the document to sign
3. Select a signing certificate from the dropdown
4. Paste the corresponding private key (PEM format)
5. Enter private key password if required
6. Choose between attached or detached signature
7. Click "Sign Document"
8. Download the signature file

### Document Verification
1. Go to "Document Operations" → "Verify" tab
2. Upload the original document
3. Either upload the signature file or paste the signature package
4. Click "Verify Signature"
5. View the verification result

### Document Encryption
1. Go to "Document Operations" → "Encrypt" tab
2. Upload the document to encrypt
3. Select recipient certificate(s)
4. Click "Encrypt Document"
5. Download the encrypted package

### Document Decryption
1. Go to "Document Operations" → "Decrypt" tab
2. Paste the encryption package (JSON)
3. Paste your private key (PEM format)
4. Enter private key password if required
5. Click "Decrypt Document"
6. Download the decrypted file

### Audit Log Management
1. Go to "Audit Logs"
2. Use filters to search specific events
3. Click on log entries to view details
4. Use "Verify All" to check log integrity
5. Export logs in JSON or CSV format

## Security Considerations

### Private Key Management
- **Never share private keys**: Keep private keys secure and never transmit them over insecure channels
- **Use strong passwords**: If encrypting private keys, use strong, unique passwords
- **Backup securely**: Store private key backups in secure, encrypted storage
- **Regular rotation**: Rotate certificates and keys according to your security policy

### Certificate Authority Security
- **Offline root CA**: Consider keeping root CA offline for maximum security
- **Hardware security modules**: Use HSMs for production environments
- **Access control**: Limit access to CA operations to authorized personnel only
- **Audit regularly**: Review audit logs regularly for suspicious activities

### Network Security
- **Use HTTPS**: Deploy behind a reverse proxy with SSL/TLS in production
- **Firewall rules**: Restrict access to necessary ports only
- **VPN access**: Consider VPN access for administrative functions
- **Regular updates**: Keep all software components updated

### Data Protection
- **Database encryption**: Consider encrypting the SQLite database file
- **File system permissions**: Set restrictive permissions on certificate and key directories
- **Backup encryption**: Encrypt all backups
- **Secure deletion**: Use secure deletion methods when removing sensitive data

## Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Find process using port 5000
sudo lsof -i :5000

# Kill the process
sudo kill -9 <PID>

# Or use a different port
export PORT=8080
python src/main.py
```

#### Permission Denied Errors
```bash
# Fix directory permissions
chmod 755 cryptography_tool
chmod 700 cryptography_tool/private_keys
chmod 755 cryptography_tool/certificates

# Fix file permissions
find cryptography_tool -name "*.py" -exec chmod 644 {} \;
```

#### Database Errors
```bash
# Remove and recreate database
rm cryptography_tool/instance/certificates.db
python src/main.py  # Will recreate database
```

#### Missing Dependencies
```bash
# Reinstall Python dependencies
cd cryptography_tool
source venv/bin/activate
pip install --upgrade -r requirements.txt

# Reinstall Node.js dependencies
cd ../crypto-frontend
rm -rf node_modules package-lock.json
npm install
```

### Log Files
Check application logs for detailed error information:
```bash
# Flask application logs
tail -f cryptography_tool/logs/app.log

# System service logs (if using systemd)
sudo journalctl -u cryptography-tool -f

# Audit logs
tail -f cryptography_tool/logs/audit.log
```

### Performance Optimization

#### Database Optimization
```bash
# For larger deployments, consider PostgreSQL
pip install psycopg2-binary
# Update DATABASE_URL in .env file
```

#### Caching
```bash
# Install Redis for caching
sudo apt install redis-server
pip install redis flask-caching
```

#### Load Balancing
For high-availability deployments, use multiple application instances behind a load balancer like Nginx or HAProxy.

## API Documentation

The system provides RESTful APIs for all operations:

### Certificate Authority APIs
- `POST /api/ca/initialize-root-ca` - Initialize root CA
- `POST /api/ca/initialize-intermediate-ca` - Initialize intermediate CA
- `POST /api/ca/generate-csr` - Generate certificate signing request
- `POST /api/ca/issue-certificate` - Issue certificate from CSR
- `POST /api/ca/revoke-certificate` - Revoke certificate
- `GET /api/ca/certificates` - List all certificates
- `GET /api/ca/certificate-status/<serial>` - Get certificate status

### Document Operations APIs
- `POST /api/document/sign` - Sign document
- `POST /api/document/sign-detached` - Create detached signature
- `POST /api/document/verify` - Verify signature
- `POST /api/document/verify-detached` - Verify detached signature
- `POST /api/document/encrypt` - Encrypt document
- `POST /api/document/encrypt-multi` - Encrypt for multiple recipients
- `POST /api/document/decrypt` - Decrypt document
- `POST /api/document/hash` - Calculate document hash

### Audit APIs
- `GET /api/audit/logs` - Get audit logs
- `POST /api/audit/logs/search` - Search audit logs
- `GET /api/audit/logs/statistics` - Get audit statistics
- `GET /api/audit/logs/verify` - Verify log integrity
- `GET /api/audit/logs/export` - Export audit logs

## Backup and Recovery

### Database Backup
```bash
# Backup SQLite database
cp cryptography_tool/instance/certificates.db backup/certificates_$(date +%Y%m%d_%H%M%S).db

# Restore database
cp backup/certificates_20240724_120000.db cryptography_tool/instance/certificates.db
```

### Certificate and Key Backup
```bash
# Create encrypted backup
tar -czf backup/crypto_backup_$(date +%Y%m%d).tar.gz \
    cryptography_tool/certificates \
    cryptography_tool/private_keys \
    cryptography_tool/instance

# Encrypt the backup
gpg --symmetric --cipher-algo AES256 backup/crypto_backup_*.tar.gz
```

### Automated Backup Script
```bash
#!/bin/bash
# backup.sh - Automated backup script

BACKUP_DIR="/backup/cryptography-tool"
DATE=$(date +%Y%m%d_%H%M%S)
APP_DIR="/home/ubuntu/cryptography-tool"

mkdir -p $BACKUP_DIR

# Backup database
cp $APP_DIR/cryptography_tool/instance/certificates.db \
   $BACKUP_DIR/certificates_$DATE.db

# Backup certificates and keys
tar -czf $BACKUP_DIR/crypto_files_$DATE.tar.gz \
    -C $APP_DIR/cryptography_tool \
    certificates private_keys

# Encrypt backups
gpg --batch --yes --passphrase-file /secure/backup_passphrase \
    --symmetric --cipher-algo AES256 \
    $BACKUP_DIR/certificates_$DATE.db

gpg --batch --yes --passphrase-file /secure/backup_passphrase \
    --symmetric --cipher-algo AES256 \
    $BACKUP_DIR/crypto_files_$DATE.tar.gz

# Remove unencrypted files
rm $BACKUP_DIR/certificates_$DATE.db
rm $BACKUP_DIR/crypto_files_$DATE.tar.gz

# Clean old backups (keep 30 days)
find $BACKUP_DIR -name "*.gpg" -mtime +30 -delete

echo "Backup completed: $DATE"
```

## Support and Maintenance

### Regular Maintenance Tasks
1. **Monitor disk space**: Ensure adequate space for certificates and logs
2. **Review audit logs**: Check for suspicious activities regularly
3. **Update dependencies**: Keep Python and Node.js packages updated
4. **Certificate expiry**: Monitor certificate expiration dates
5. **Backup verification**: Test backup and recovery procedures

### Updates and Upgrades
```bash
# Update Python dependencies
cd cryptography_tool
source venv/bin/activate
pip list --outdated
pip install --upgrade <package_name>

# Update Node.js dependencies
cd crypto-frontend
npm outdated
npm update
```

### Monitoring
Consider implementing monitoring solutions:
- **Application monitoring**: Use tools like Prometheus + Grafana
- **Log monitoring**: Use ELK stack (Elasticsearch, Logstash, Kibana)
- **Uptime monitoring**: Use tools like Nagios or Zabbix
- **Certificate monitoring**: Monitor certificate expiration dates

This completes the comprehensive setup guide for the Cryptographically Secure Document System. The system is now ready for deployment and use in ethical hacking and security testing scenarios.

