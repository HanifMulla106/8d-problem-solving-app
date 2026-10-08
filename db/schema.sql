CREATE DATABASE IF NOT EXISTS eightd_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE eightd_db;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'manager', 'engineer', 'approver', 'viewer') NOT NULL DEFAULT 'viewer',
    department VARCHAR(100) NULL,
    full_name VARCHAR(150) NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cases (
    id INT AUTO_INCREMENT PRIMARY KEY,
    case_number VARCHAR(50) NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    severity ENUM('critical', 'high', 'medium', 'low') NOT NULL,
    status ENUM('open', 'in_progress', 'closed', 'on_hold') NOT NULL DEFAULT 'open',
    reported_by INT NOT NULL,
    assigned_to INT NULL,
    product_line VARCHAR(100) NULL,
    department VARCHAR(100) NULL,
    detected_date DATE NOT NULL,
    closed_date DATE NULL,
    customer_impact TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_cases_reported_by FOREIGN KEY (reported_by) REFERENCES users(id),
    CONSTRAINT fk_cases_assigned_to FOREIGN KEY (assigned_to) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS case_steps (
    id INT AUTO_INCREMENT PRIMARY KEY,
    case_id INT NOT NULL,
    step_number INT NOT NULL,
    step_name VARCHAR(120) NOT NULL,
    description TEXT NULL,
    status ENUM('not_started', 'in_progress', 'completed', 'approved') NOT NULL DEFAULT 'not_started',
    owner_id INT NULL,
    due_date DATE NULL,
    completed_date DATE NULL,
    notes TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uniq_case_step (case_id, step_number),
    CONSTRAINT fk_steps_case FOREIGN KEY (case_id) REFERENCES cases(id) ON DELETE CASCADE,
    CONSTRAINT fk_steps_owner FOREIGN KEY (owner_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS actions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    case_id INT NOT NULL,
    step_id INT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    owner_id INT NOT NULL,
    due_date DATE NOT NULL,
    completion_date DATE NULL,
    status ENUM('open', 'in_progress', 'completed', 'overdue') NOT NULL DEFAULT 'open',
    priority ENUM('low', 'medium', 'high', 'critical') NOT NULL DEFAULT 'medium',
    evidence TEXT NULL,
    verified_by INT NULL,
    verification_date DATE NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_actions_case FOREIGN KEY (case_id) REFERENCES cases(id) ON DELETE CASCADE,
    CONSTRAINT fk_actions_step FOREIGN KEY (step_id) REFERENCES case_steps(id),
    CONSTRAINT fk_actions_owner FOREIGN KEY (owner_id) REFERENCES users(id),
    CONSTRAINT fk_actions_verifier FOREIGN KEY (verified_by) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS attachments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    case_id INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size INT NULL,
    file_type VARCHAR(80) NULL,
    uploaded_by INT NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_att_case FOREIGN KEY (case_id) REFERENCES cases(id) ON DELETE CASCADE,
    CONSTRAINT fk_att_user FOREIGN KEY (uploaded_by) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    case_id INT NOT NULL,
    user_id INT NOT NULL,
    comment TEXT NOT NULL,
    is_internal TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_comment_case FOREIGN KEY (case_id) REFERENCES cases(id) ON DELETE CASCADE,
    CONSTRAINT fk_comment_user FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS audit_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    case_id INT NOT NULL,
    user_id INT NOT NULL,
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(100) NULL,
    record_id INT NULL,
    old_value TEXT NULL,
    new_value TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_audit_case FOREIGN KEY (case_id) REFERENCES cases(id) ON DELETE CASCADE,
    CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS approvals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    case_id INT NOT NULL,
    step_id INT NULL,
    approver_id INT NOT NULL,
    approval_status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
    comments TEXT NULL,
    approved_at TIMESTAMP NULL,
    CONSTRAINT fk_approve_case FOREIGN KEY (case_id) REFERENCES cases(id) ON DELETE CASCADE,
    CONSTRAINT fk_approve_step FOREIGN KEY (step_id) REFERENCES case_steps(id),
    CONSTRAINT fk_approve_user FOREIGN KEY (approver_id) REFERENCES users(id)
);
