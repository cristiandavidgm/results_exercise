[![Codeship Status for cristiandavidgm/results_exercise](https://app.codeship.com/projects/4aa4d530-267f-0137-ffc2-3e508df156a9/status?branch=master)](https://app.codeship.com/projects/330404)

# Results
Results is a purely academic exercise develop as a technical test. 
It is quite simple, takes a list of results from a CSV file, parses it and exposes a REST endpoint that allows getting division-seasons pairs and the results for every given division-season.

The main idea was to keep it simple to allow an easy review of the code, it is not production ready, it laking code instrumentation and more sophisticated orchestration. 

# Content table:
 - [Building for local development](#Building-for-local-development)

# Building for local development

In order to build the project locally, you should have Elixir ~> 1.8 installed. 
mix.lock file was attached to the project to guarantee dependencies will remain stable for later builds, feel free to remove it. 

```sh
$ git clone https://github.com/cristiandavidgm/results_exercise.git
$ cd results_exercise
$ mix deps.get
$ mix deps.compile
$ mix compile
$ iex -S mix
```
then go to <a href="http://127.0.0.1:8880/v1/json/leagues" target="_blank">http://127.0.0.1:8880/v1/json/leagues</a> and voilà


