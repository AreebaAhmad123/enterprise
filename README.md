# Consulting Session Scheduler

A Ruby on Rails web application that enables consultants and clients to manage bookings, payments, and communication efficiently.

## Features

- User Authentication (Sign Up, Log In) using Devise
- Calendar Scheduling System with simple_calendar
- Real-time Comments using Turbo Streams
- Stripe Payment Integration
- Admin Dashboard with Analytics
- Email Notifications
- Responsive UI with Tailwind CSS

## Tech Stack

- Ruby on Rails 7.2
- PostgreSQL
- Tailwind CSS
- Devise (Authentication)
- Stripe (Payments)
- Turbo Streams (Real-time Updates)
- Sidekiq (Background Jobs)

## Prerequisites

- Ruby 3.2.0 or higher
- PostgreSQL
- Node.js and Yarn
- Stripe Account

## Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd consulting-session-scheduler
   ```

2. Install dependencies:
   ```bash
   bundle install
   yarn install
   ```

3. Set up the database:
   ```bash
   rails db:create db:migrate
   ```

4. Configure environment variables:
   ```bash
   cp .env.example .env
   ```
   Edit `.env` and add your configuration:
   - `STRIPE_PUBLISHABLE_KEY`
   - `STRIPE_SECRET_KEY`
   - `SMTP_USERNAME`
   - `SMTP_PASSWORD`

5. Start the server:
   ```bash
   ./bin/dev
   ```

## Usage

### User Roles

1. **Client**
   - Create and manage sessions
   - Make payments
   - Add comments to sessions

2. **Consultant**
   - View assigned sessions
   - Manage session status
   - Respond to comments

3. **Admin**
   - Access admin dashboard
   - Manage all sessions
   - View analytics
   - Manage users

### Session Management

1. Create a new session:
   - Click "New Session"
   - Fill in session details
   - Select consultant
   - Choose date and time

2. View sessions:
   - Calendar view shows all sessions
   - List view shows upcoming sessions
   - Filter by status or date

3. Manage sessions:
   - Edit session details
   - Cancel sessions
   - Add comments
   - Make payments

### Payments

1. Make a payment:
   - Select session
   - Enter payment details
   - Confirm payment

2. View payment history:
   - Access payment history in profile
   - View payment receipts
   - Request refunds (if applicable)

## Development

### Running Tests

```bash
rails test
```

### Code Style

```bash
rubocop
```

### Background Jobs

```bash
bundle exec sidekiq
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.


