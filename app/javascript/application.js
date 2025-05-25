import "@hotwired/turbo-rails"
import "controllers"
// import "trix"
import "./custom"

document.addEventListener('turbo:load', () => {
  const token = document.querySelector('meta[name="csrf-token"]')?.content
  if (token) {
    document.querySelectorAll('form').forEach(form => {
      const tokenInput = form.querySelector('input[name="authenticity_token"]')
      if (tokenInput) {
        tokenInput.value = token
      }
    })
  }
})

document.addEventListener('DOMContentLoaded', () => {
  const focused = document.querySelector(':focus');
  if (!focused) document.querySelector('input[autofocus]')?.focus();
});