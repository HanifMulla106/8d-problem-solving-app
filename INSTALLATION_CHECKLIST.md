# 8D Problem Solving App - Installation Checklist

## Pre-Installation
- [ ] PHP 8.1 or higher installed
- [ ] MySQL 8.0 or higher running
- [ ] Apache with mod_rewrite enabled (or Nginx)
- [ ] Web server access with write permissions

## Installation Steps

### Step 1: Extract Files
- [ ] Download the ZIP file
- [ ] Extract to web server root (htdocs, www, public_html)
- [ ] Folder structure created correctly

### Step 2: Database Setup
- [ ] Open MySQL command line or phpMyAdmin
- [ ] Run: `mysql -u root -p < db/schema.sql`
- [ ] Database `eightd_db` created successfully
- [ ] All tables created without errors

### Step 3: Configuration
- [ ] Edit `config/database.php`
  - [ ] Update DB_HOST if not localhost
  - [ ] Update DB_USER if not root
  - [ ] Update DB_PASS with your MySQL password
- [ ] (Optional) Edit `config/mail.php` for email features

### Step 4: Verify PHP Files
- [ ] Run: `php -l config/app.php`
- [ ] Run: `php -l src/Database.php`
- [ ] Run: `php -l src/Auth.php`
- [ ] Run: `php -l src/Models.php`
- [ ] Run: `php -l src/Controllers.php`
- [ ] Run: `php -l public/index.php`
- [ ] All files pass syntax check

### Step 5: Start Server

**Option A - PHP Built-in Server:**
```bash
cd path/to/8d-problem-solving-app/public
php -S localhost:8000
```

**Option B - Apache:**
- [ ] .htaccess enabled in project root
- [ ] DocumentRoot points to `public` folder
- [ ] mod_rewrite is active

### Step 6: Admin Setup
- [ ] Open browser: `http://localhost:8000/setup.php`
- [ ] Enter admin username
- [ ] Enter admin email
- [ ] Enter admin password
- [ ] Click "Create Admin"
- [ ] Confirmation message received

### Step 7: Login & Test
- [ ] Open `http://localhost:8000/login`
- [ ] Login with admin credentials
- [ ] Dashboard loads successfully
- [ ] All navigation links work

## Verification

### Dashboard
- [ ] KPI metrics display (Total Cases, Open Cases, etc.)
- [ ] Recent cases table shows (initially empty)

### Cases Module
- [ ] Navigate to `/cases` - shows empty list
- [ ] Click "New 8D Case" - create form loads
- [ ] Fill form and submit - case created
- [ ] Case appears in cases list
- [ ] Click case - detail view loads
- [ ] 8D steps table shows 9 steps (D0-D8)

### Authentication
- [ ] Click "Logout" - redirected to login
- [ ] Try accessing `/dashboard` without login - redirected to login
- [ ] Login works correctly

## Troubleshooting

### Database Connection Failed
- [ ] MySQL service is running
- [ ] Credentials are correct in `config/database.php`
- [ ] Database user has permissions on `eightd_db`
- [ ] Run: `mysql -u root -p -e "SHOW DATABASES;"`

### 404 Errors on Routes
- [ ] .htaccess is present in root folder
- [ ] Apache has mod_rewrite enabled
- [ ] DocumentRoot configured correctly
- [ ] Run: `a2enmod rewrite` on Linux

### Session/Login Issues
- [ ] Session directory is writable: `php -r "echo sys_get_temp_dir();"`
- [ ] PHP session.use_only_cookies = 1
- [ ] PHP session.save_path is configured

### Permission Denied
- [ ] On Linux/Mac: `chmod 755 8d-problem-solving-app`
- [ ] Web server user (www-data, apache) has read access

## First Time Usage

1. **Change Admin Password**
   - [ ] Login with default credentials
   - [ ] Update password immediately (database only, no UI yet)

2. **Add More Users** (via MySQL)
   ```sql
   INSERT INTO users (username, email, password_hash, role, full_name, is_active) 
   VALUES ('manager1', 'manager@example.com', PASSWORD('password'), 'manager', 'Manager Name', 1);
   ```

3. **Create Sample Case**
   - [ ] Dashboard > New Case
   - [ ] Fill in title, description, severity
   - [ ] Submit
   - [ ] Verify 9-step workflow created

## Security Checklist

- [ ] Change admin password after first login
- [ ] Use strong MySQL passwords
- [ ] Keep database credentials secure
- [ ] Enable HTTPS on production
- [ ] Restrict database user permissions
- [ ] Set up regular backups
- [ ] Update PHP to latest version
- [ ] Use environment variables for sensitive data

## Support

- Check SETUP_INSTRUCTIONS.md for detailed documentation
- Review database schema in db/schema.sql
- Examine Models.php for data access patterns
- Check Controllers.php for request handling

---

**Status**: Ready for installation
**Version**: 1.0
**Last Updated**: October 2026
