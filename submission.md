[link to .cursorignore](.cursorignore)
[link to AGENTS.md](AGENTS.md)
[link to rails-conventions.mdc](.cursor/rules/rails-conventions.mdc)
[link to security.mdc](.cursor/rules/security.mdc)

Part 3
command for windows is Shift + Tab

where in the codebase is the deletion of posts currently implemented? Cite the exact files and line numbers. Do not propose changes.

gave me [link to deletion implementation](app/controllers/todos_controller.rb)
lines 50-56

the citation is real


plan mode


Restrict Todo deletion to creator session

Goal

Only the session that created a Todo may delete it. Non-owners attempting delete should redirect with a flash alert for HTML requests.

Assumptions (based on repo)





There is no User model / login yet (only Todo exists).



Delete is currently implemented in [app/controllers/todos_controller.rb](app/controllers/todos_controller.rb) destroy and exposed via a button in [app/views/todos/show.html.erb](app/views/todos/show.html.erb).

Numbered list of changes





Add ownership column to todos (migration)





Create a migration adding owner_token (string) to todos.



Add a DB index on owner_token (and optionally compound index on [id, owner_token] if you prefer).



Files:





Add new migration under [db/migrate/](db/migrate/)



Generate and persist a per-session owner token





In TodosController, ensure there is a stable session identifier (e.g. session[:owner_token] ||= SecureRandom.hex(16) or similar) used to mark ownership.



Files:





Edit [app/controllers/todos_controller.rb](app/controllers/todos_controller.rb)



Set ownership when creating a Todo





In create, assign @todo.owner_token from the session token before saving.



Ensure this applies to both HTML and JSON create flows.



Files:





Edit [app/controllers/todos_controller.rb](app/controllers/todos_controller.rb)



Authorize deletion in destroy





Before @todo.destroy!, verify @todo.owner_token == session[:owner_token].



If not owner:





HTML: redirect back (prefer todos_path) with alert: "Not authorized to delete this todo." and an appropriate status (commonly :see_other).



JSON: return head :forbidden (403) or a small JSON error body with 403.



Files:





Edit [app/controllers/todos_controller.rb](app/controllers/todos_controller.rb)



Hide the “Destroy” button for non-owners (UI)





In the show view, only render the destroy button_to when the session token matches the todo’s owner_token.



Files:





Edit [app/views/todos/show.html.erb](app/views/todos/show.html.erb)



Update fixtures to include ownership





Add owner_token values to existing fixtures so controller/system tests remain deterministic.



Files:





Edit [test/fixtures/todos.yml](test/fixtures/todos.yml)



Add/adjust controller tests (authorization behavior)





Update TodosControllerTest to cover:





Owner can destroy: set session[:owner_token] to match the fixture’s owner_token, assert Todo.count decreases by 1 and redirects to todos_url.



Non-owner cannot destroy: set session[:owner_token] to a different token, assert no change in Todo.count, and assert redirect + flash alert.



(Optional) JSON: request delete todo_url(@todo, format: :json) as non-owner and assert :forbidden.



Files:





Edit [test/controllers/todos_controller_test.rb](test/controllers/todos_controller_test.rb)



Add/adjust system tests (UI behavior)





Update system test to ensure:





In the same session that visits/creates, the Destroy button is present and deletion succeeds.



In a different Capybara session (using_session), visiting the same todo does not show the Destroy button.



Files:





Edit [test/system/todos_test.rb](test/system/todos_test.rb)

Test plan





Run full suite: bin/rails db:test:prepare test test:system



Manually verify in browser:





Create a todo → Destroy button visible → delete works.



Open same todo in a different browser/profile → Destroy button hidden → direct DELETE attempt redirects with alert.

Agent mode

alright, i'd like you to just do a small slice of it. add the ownership setting part and hide the destroy button for non-owners, no need to actually make it do anything.

[here's the commit](https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-agirmai/commit/3e7095c5ab91324ea64747f8d8642cfeb9fba70b)

fix the bug in todos


good:
Context: db/schema.rb, app/views/todos/_form.html.erb, app/controllers/todos_controller.rb
Task: Add support to enter and save due_date when creating/updating a todo.
Expected vs actual: Expected: user can set a due date and it persists. Actual: due_date exists in DB but there’s no form field and it’s not permitted in todo_params, so it can’t be saved.
Constraints: Don’t add gems. Follow existing Rails patterns (params.expect, ERB forms, Minitest).
Done when: bin/rails db:test:prepare test test:system passes, and at least one test proves due_date is persisted on create or update.