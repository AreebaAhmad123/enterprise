Tailwindcss.configure do |config|
  # Use the Node-installed tailwindcss executable instead of the embedded one
  config.cmd = "./node_modules/.bin/tailwindcss"
end
