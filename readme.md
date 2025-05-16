# Consulting Session Scheduler

A Ruby on Rails web application for consultants and clients to schedule, manage, and pay for consulting sessions.

## Task Status

### Completed Tasks
- **Project Setup**:
  - Created Rails app with PostgreSQL.
  - Added gems: `devise`, `simple_calendar`, `stripe`, `sidekiq`, `foreman`, `trix-rails`, `tailwindcss-rails`.
  - Set up Tailwind CSS and Foreman.
- **Authentication**:
  - Configured Devise for user registration/login.
  - Added User model with `client` and `admin` roles.
  - Generated Devise views.
- **Models and Relationships**:
  - Created `User`, `Meeting`, `Comment`, `Payment` models.
  - Defined relationships and validations.
- **Routes**:
  - Set up nested routes for users, meetings, comments, payments.
  - Added admin namespace routes.
- **Controllers**:
  - Implemented `MeetingsController` (index, show, new, create, destroy).
  - Implemented `CommentsController` (create with Ajax).
  - Implemented `PaymentsController` (new, create with Stripe).
  - Implemented `Admin::DashboardController` (index).
- **Views**:
  - Created application layout with Tailwind CSS.
  - Added meetings index with `simple_calendar`.
  - Added meeting show page with Trix Editor for comments.
  - Set up admin dashboard view.
- **Stripe Integration**:
  - Configured Stripe Checkout.
  - Stored card brand and last 4 digits in `Payment` model.
- **Email Notifications**:
  - Set up `MeetingMailer` for booking confirmations and payment receipts.
  - Added mailer views and previews.
- **Background Jobs**:
  - Configured Sidekiq with Redis.
- **Initial Testing**:
  - Provided instructions to run app and create admin user.

### Remaining Tasks
- **Calendar Enhancements**:
  - Customize `simple_calendar` for dynamic time slots.
  - Ensure responsive, mobile-first calendar UI.
- **Admin Dashboard Analytics**:
  - Add analytics for bookings and revenue.
  - Implement charts (e.g., Chart.js).
- **Session Filtering for Admin**:
  - Add filters for upcoming, past, canceled sessions.
  - Implement filter UI.
- **Payment Enhancements**:
  - Display payment status in admin dashboard.
  - Add refund functionality (optional).
- **Real-Time Comments**:
  - Test Ajax comment submission.
  - Add comment editing/deletion (optional).
- **Email Notifications**:
  - Add cancellation notifications.
  - Style email templates.
- **Testing**:
  - Write RSpec tests for models and controllers.
  - Test mailers.
- **Deployment**:
  - Deploy to Heroku/Render.
  - Configure production environment variables.
- **Security and Optimization**:
  - Add authorization (e.g., Pundit).
  - Optimize database queries.
  - Handle Stripe webhooks.
- **User Experience**:
  - Polish UI with Tailwind CSS.
  - Add client profile page.
  - Implement session rescheduling (optional).

## Setup Instructions
1. Clone the repository: `git clone https://github.com/areeba/enterprise.git`
2. Install dependencies: `bundle install`
3. Set up environment variables in `.env` (e.g., Stripe keys).
4. Create and migrate database: `rails db:create db:migrate`
5. Start Redis: `redis-server`
6. Run the app: `foreman start`
7. Access at `http://localhost:3000`