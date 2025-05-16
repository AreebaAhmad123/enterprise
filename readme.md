# Consulting Session Scheduler

This is a Ruby on Rails app that lets consultants and clients book, manage, and pay for sessions online. Clients can sign up, book sessions, comment, pay with Stripe, and get emails. Admins can manage users and sessions from a dashboard.

## Features
- Clients: Sign up, log in, book or cancel sessions, see free time slots, add comments, pay with Stripe, get email confirmations.
- Admins: See a dashboard, manage users and sessions, cancel sessions, filter sessions.
- Tech used: Ruby on Rails, PostgreSQL, Devise, Tailwind CSS, Trix Editor, Stripe, simple_calendar, Sidekiq, Foreman.

## Done Tasks
All planned tasks are finished:

- Project Setup:
  - Started a Rails app with PostgreSQL.
  - Added Tailwind CSS for styling.
  - Set up a Git repo.

- User Login and Roles:
  - Added Devise for login and signup.
  - Made a User model with client and admin roles.
  - Added checks to block non-admins from admin pages.

- Booking Sessions:
  - Made a Meeting model to handle sessions.
  - Added simple_calendar for a calendar view.
  - Built monthly and weekly calendar views with free time slots.
  - Created a booking page for clients.
  - Made a dashboard for clients to see upcoming sessions.
  - Added a way for clients to cancel sessions.
  - Built a system for admins to see all sessions.
  - Gave admins power to cancel any session.
  - Added a calendar for admins to see all bookings.

- Comments:
  - Made a Comment model for session notes.
  - Added Trix Editor for rich text comments.
  - Built a comment system that updates without reloading.

- Payments:
  - Set up Stripe for testing.
  - Added a checkout page for clients to pay.
  - Linked payments to the Meeting model.
  - Saved card details safely (brand, last 4 digits).

- Emails:
  - Set up Action Mailer to send emails.
  - Made an email template for booking confirmations.
  - Made an email template for payment receipts.
  - Added a way to preview emails for testing.

- Admin Dashboard:
  - Built a dashboard for admins.
  - Added a page to manage users (edit or delete).
  - Added filters to sort sessions by date, user, or status.

- Quality Checks:
  - Added checks for inputs and access with Pundit.

## Future Tasks
Here are ideas to make the app better:

- Calendar:
  - Let users drag and drop to reschedule sessions.
  - Add support for different time zones.

- Admin Analytics:
  - Show charts for revenue and bookings with Chart.js.
  - Let admins download data as a CSV file.

- Payments:
  - Add Stripe webhooks to update payment status instantly.
  - Let admins issue refunds.

- Comments:
  - Add options to edit or delete comments.
  - Send email alerts for new comments.

- Emails:
  - Send emails when sessions are canceled.
  - Make email templates look nicer with HTML/CSS.

- Testing:
  - Write RSpec tests for models, controllers, and emails.
  - Use GitHub Actions for automatic testing.

- Deployment:
  - Put the app on Heroku or Render.
  - Optimize Sidekiq and PostgreSQL for live use.

- Security:
  - Check Pundit rules for rare cases.
  - Limit API requests to prevent abuse.

- User Experience:
  - Add a client profile page to see session and payment history.
  - Improve the look with animations and better Tailwind CSS.

## How to Set Up
1. Clone the Repo:
   ```bash
   git clone https://github.com/AreebaAhmad123/enterprise.git
   cd enterprise