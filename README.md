# Laravel App

A Laravel 13 application with registration, sign-in, email verification, password recovery, and profile management. The repository also includes a Docker, Jenkins, Ansible, and Terraform setup for deployment on AWS.

## Requirements

- PHP 8.3 or later and Composer
- Node.js and npm
- SQLite for local development (the example environment uses SQLite)

## Local development

From the repository root, run the Composer setup script. It installs PHP and JavaScript dependencies, creates `.env` when needed, generates the application key, runs migrations, and builds the frontend assets.

```bash
composer run setup
```

Start the local development services with:

```bash
composer run dev
```

The app is served at `http://localhost:8000`. Adjust `.env` for your local database, mail, or other services as needed.

Run the automated test suite with:

```bash
composer test
```

## Application features

- Public welcome page and a verified-user dashboard
- Registration, login, logout, email verification, password reset, and password confirmation
- Profile editing, password changes, and account deletion
- Blade views styled with Tailwind CSS and built with Vite

## Repository layout

| Path | Purpose |
| --- | --- |
| `app/` | Models, controllers, requests, and view components |
| `routes/` | Web, authentication, and console routes |
| `resources/` | Blade templates, CSS, and JavaScript |
| `database/` | Migrations, factories, and seeders |
| `tests/` | Feature and unit tests |
| `Dockerfile`, `docker-compose.yml`, `vhost.conf` | Apache/PHP image and container services |
| `Jenkinsfile`, `playbook1.yml`, `playbook2.yml` | Jenkins pipeline and Ansible deployment steps |
| `terraform/` | AWS network, security group, EC2, and output configuration |

## Docker deployment

The Compose stack defines three services:

- `db`: MySQL 8, exposed on port `3306`
- `php-service`: the Laravel Apache container, exposed on port `5000`
- `phpmyadmin`: exposed on port `4000`

Compose reads `DB_ROOT_PASSWORD`, `DB_USERNAME`, `DB_PASSWORD`, and `DB_DATABASE` for MySQL. The application container uses MySQL at `db:3306`.

The checked-in `.env.example` is configured for SQLite. Before using Compose, set `DB_CONNECTION=mysql`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`, and `DB_ROOT_PASSWORD` in the deployment `.env` file.

The current Compose and Ansible configuration expects the checkout and `.env` file at `/var/lib/jenkins/workspace/laravel-app`. Use that Jenkins workspace for deployment, or update the hard-coded paths in `docker-compose.yml` and `playbook2.yml` before deploying from another location.

## Jenkins and Ansible deployment

The Jenkins pipeline uses a Jenkins username/password credential with the ID `dockerhub` to log in to Docker Hub. Its agent needs Docker, the Docker Compose plugin, and Ansible available.

1. `playbook1.yml` builds the `moaaz65/laravel-image` image and pushes it to Docker Hub.
2. `playbook2.yml` recreates the Compose services and runs Laravel database migrations.

The deployment expects the Jenkins workspace path described above and a populated `.env` file there.

## Terraform infrastructure

The `terraform/` directory describes an AWS EC2 host, its VPC, subnet, and security group, and outputs the host's public IP. It uses the AWS provider and references an existing AMI and existing network resource IDs. Provide the required Terraform variables and AWS credentials, and verify those resource IDs and the AMI for your account and region before applying the configuration.
