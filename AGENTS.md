Stack: 
Rails version is 8.1.3 on ruby 3.4.1
Using SQLite3
View layer: ERB, Hotwire(turbo-rails, stimulus-rails), importmap-rails, Propshaft CSS(no Bootstrap)
JSON: jbuilder templates
Tests: Minitest, Cabybara + Selenium for system tests
Background jobs:Solid Queue gem

Commands:
Setup: bin/setup (bundle install, db:prepare, optional bin/dev).
Run dev server: bin/dev (alias for bin/rails server).
Test: bin/rails db:test:prepare test test:system (matches CI).
Lint: bin/rubocop (or bin/rubocop -f github)
Security: bin/brakeman --no-pager, bin/importmap audit.
Other: bin/rails db:seed, bin/rails console.

Conventions:
Naming - Rails defaults, Todo model, TodosController
partials prefixed with _
Authorization: none yet, bcrypt commented out in Gemfile
Controllers use respond_to with format.html and format.json, no Turbo Streams in current code
Shared partials live in app/view/<controller>/

Donts
Do not add gems without course/instructor approval
Do not commit secrets, sample data only via db/seeds.rb
Do not put inline <script> in ERB, use Stimulus under app/javascript/controllers/
