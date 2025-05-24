import "@hotwired/turbo-rails"
import "controllers"
import "trix"
import "@rails/actiontext"
import Rails from '@rails/ujs'
import "./custom"

Rails.start()

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