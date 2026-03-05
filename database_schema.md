# Database Schema Design for Cryptography Tool

## 1. Overview
This document outlines the database schema for the Cryptographically Secure Multi-Factor Document Signing and Encryption System. SQLite will be used for lightweight deployments, with a potential upgrade path to PostgreSQL for larger-scale applications. The schema focuses on storing metadata related to certificates and audit logs.

## 2. Table: `certificates`
This table will store information about all issued X.509 certificates, including Root CAs, Intermediate CAs, and user certificates.

- **`id`**: INTEGER PRIMARY KEY AUTOINCREMENT
    - Unique identifier for each certificate entry.
- **`serial_number`**: TEXT NOT NULL UNIQUE
    - The unique serial number of the X.509 certificate. This will be used as a primary lookup key.
- **`subject`**: TEXT NOT NULL
    - The Distinguished Name (DN) of the certificate subject (e.g., `CN=User Name, O=Organization, C=Country`).
- **`issuer`**: TEXT NOT NULL
    - The Distinguished Name (DN) of the certificate issuer.
- **`public_key_pem`**: TEXT NOT NULL
    - The public key of the certificate in PEM (Privacy-Enhanced Mail) format.
- **`private_key_pem_encrypted`**: TEXT
    - The private key associated with the certificate, stored in encrypted PEM format. This field will primarily be used for CA private keys, and potentially for user keys if they are managed by the system (though the documentation suggests user keys might be kept in encrypted keystores). For user keys, this might be null if the key is not stored by the system.
- **`issue_date`**: TEXT NOT NULL
    - The date and time when the certificate was issued (ISO 8601 format).
- **`expiry_date`**: TEXT NOT NULL
    - The date and time when the certificate expires (ISO 8601 format).
- **`status`**: TEXT NOT NULL DEFAULT 'active'
    - Current status of the certificate (e.g., 'active', 'revoked', 'expired').
- **`revocation_date`**: TEXT
    - The date and time when the certificate was revoked, if applicable (ISO 8601 format). NULL if not revoked.
- **`type`**: TEXT NOT NULL
    - Type of certificate (e.g., 'root_ca', 'intermediate_ca', 'user').

## 3. Table: `audit_logs`
This table will store a tamper-evident record of all significant system activities.

- **`id`**: INTEGER PRIMARY KEY AUTOINCREMENT
    - Unique identifier for each log entry.
- **`timestamp`**: TEXT NOT NULL
    - The date and time when the event occurred (ISO 8601 format).
- **`event_type`**: TEXT NOT NULL
    - Categorization of the event (e.g., 'certificate_issued', 'document_signed', 'document_encrypted', 'login_attempt', 'ca_initialized', 'crl_generated').
- **`user_identifier`**: TEXT
    - An identifier for the user or entity performing the action. This could be a certificate serial number, a username, or an IP address, depending on the context of the event. NULL if not directly attributable to a user.
- **`details`**: TEXT
    - A JSON string or plain text field containing event-specific details. This can include information like file names, certificate subjects, operation results, error messages, etc.
- **`previous_log_hash`**: TEXT
    - The cryptographic hash of the immediately preceding log entry. This creates a blockchain-like chain for tamper-evidence.
- **`current_log_hash`**: TEXT NOT NULL UNIQUE
    - The cryptographic hash of the current log entry (calculated from `timestamp`, `event_type`, `user_identifier`, `details`, and `previous_log_hash`). This ensures the integrity of the log entry itself.

## 4. Relationships
- `audit_logs.user_identifier` could potentially reference `certificates.serial_number` for events related to certificate holders, though it's not a strict foreign key constraint to allow for other types of identifiers.

## 5. Indexes
- `certificates.serial_number`: UNIQUE INDEX for fast lookups and uniqueness enforcement.
- `audit_logs.timestamp`: INDEX for efficient time-based queries.
- `audit_logs.event_type`: INDEX for filtering by event type.

## 6. Security Considerations for Database
- Private keys stored in `private_key_pem_encrypted` will be encrypted using a strong symmetric key derived from a passphrase, which will not be stored in the database.
- The `audit_logs` table implements a chaining hash mechanism to detect tampering. Any modification to a log entry would invalidate its `current_log_hash` and subsequent `previous_log_hash` entries.
- Access to the database will be restricted to the Flask application only.

This schema provides a robust foundation for managing certificates and maintaining a secure, tamper-evident audit trail within the application.

