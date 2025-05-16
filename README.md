# 💼 Consulting Session Scheduler

A full-featured **Ruby on Rails** web application that allows consultants and clients to seamlessly schedule, manage, and pay for sessions online. Clients can book sessions, leave comments, and make payments, while admins can oversee all activities through a powerful dashboard.

---

## 🚀 Features

### Clients

* Sign up and log in securely using Devise
* View available time slots through responsive calendar views
* Book and cancel consulting sessions
* Add real-time rich-text comments using Trix Editor
* Pay securely via Stripe
* Receive email confirmations and payment receipts

### Admins

* Access a dedicated admin dashboard
* View and manage all user sessions
* Cancel sessions and filter them by date, user, or status
* Manage users with options to edit or delete accounts
* Monitor payments and activity through a calendar interface

---

## 🧱 Technologies Used

* **Backend**: Ruby on Rails, PostgreSQL
* **Authentication**: Devise, Pundit
* **Styling**: Tailwind CSS
* **Calendar**: simple\_calendar gem
* **Comments**: Trix Editor with AJAX
* **Payments**: Stripe API
* **Background Jobs**: Sidekiq
* **Process Management**: Foreman
* **Email Handling**: Action Mailer

---

## ✅ Completed Tasks

### Project Setup

* Initialized Rails app with PostgreSQL
* Integrated Tailwind CSS for modern styling
* Set up version control with Git

### User Authentication & Roles

* Added Devise for user registration and login
* Implemented client and admin roles
* Restricted admin routes and views with Pundit

### Session Booking

* Created a Meeting model to manage consulting sessions
* Integrated simple\_calendar for interactive calendar views
* Built booking interfaces for clients
* Developed dashboards for both clients and admins
* Enabled session cancellation and filtering features

### Real-Time Comments

* Created a Comment model associated with sessions
* Integrated Trix Editor for rich-text input
* Enabled AJAX-based updates for seamless user experience

### Payments

* Connected Stripe Checkout for secure payments
* Linked transactions to Meeting records
* Safely stored non-sensitive card details (brand and last 4 digits)
* Sent confirmation emails after successful payments

### Email Notifications

* Configured Action Mailer
* Designed email templates for session confirmations and payment receipts
* Enabled email previews in development for testing

### Admin Dashboard

* Built an admin panel with full control over users and sessions
* Added filtering by date, user, and status
* Included user management tools

### Quality & Security

* Added input validations and role-based access control
* Used Pundit to secure sensitive routes and actions

---

## 🔮 Future Enhancements

### Calendar

* Implement drag-and-drop session rescheduling
* Add support for multiple time zones

### Admin Analytics

* Display revenue and session stats using Chart.js
* Enable CSV data exports

### Payments

* Add Stripe webhooks to update payment statuses in real time
* Allow admins to issue refunds directly

### Comments

* Add edit and delete functionality for comments
* Send notifications for new comments

### Emails

* Notify clients when sessions are canceled
* Improve visual design of email templates

### Testing & CI

* Write RSpec tests for models, controllers, and mailers
* Set up GitHub Actions for automated testing

### Deployment & Optimization

* Deploy to Heroku or Render
* Optimize Sidekiq and PostgreSQL for production

### User Experience

* Create a profile page showing session and payment history
* Add animations and polish styling with Tailwind CSS


