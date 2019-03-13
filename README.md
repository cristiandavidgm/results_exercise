[![Codeship Status for cristiandavidgm/results_exercise](https://app.codeship.com/projects/4aa4d530-267f-0137-ffc2-3e508df156a9/status?branch=master)](https://app.codeship.com/projects/330404)

# Content table:
 - [Intro](#Intro)
 - [Building for local development](#Building-for-local-development)
 - [Building docker containers](#Building-docker-containers)
 - [Docker hub image](#Docker-hub-image)
 - [Public deploy](#Public-deploy)
-  [HTTP API](#HTTP-API)
-  [Code structure](#Code-structure)

# Intro

Results is a purely academic exercise developed as a technical test. 

It is quite simple, takes a list of results from a CSV file, parses it and exposes a REST endpoint that allows getting division-seasons pairs and the results for every given division-season.

The main idea was to keep it simple to allow an easy review of the code, it is not production ready, it lacks code instrumentation and more sophisticated orchestration. 


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

# Building docker containers

Two Docker files are shipped with the project:

 - ./Dockerfile will build a release of the project and pack it into a docker container using the latest tag.
 - ./haproxy/Dockerfile will just build an image using the provided configuration file in ./haproxy/haproxy.cfg

There is a very simple docker-compose file that will:

 - Create three containers of the result app.
 - Create a container of HAproxy that will distribute the load between the tree app nodes.

The stack is quite simple, there is not dynamic done configuration, just and HAproxy and 3 app nodes.

To build the docker image:
```sh
$ make build
```
Then you should have two images of the app:
```sh
$ docker image ls
REPOSITORY  TAG IMAGE ID  CREATED  SIZE
results 0.0.1-85bddd6 a0c275e205a3  48 seconds ago 56.9MB
results latest  a0c275e205a3  48 seconds ago 56.9MB
<none>  <none>  99381b43a570  About a minute ago 170MB
alpine  3.8 dac705114996  5 days ago 4.41MB
elixir  1.8.0-alpine  9b74d9066f05  5 weeks ago  87.6MB
 ```
 
The docker-compose file uses "results-latest" image, run:
```sh
$ docker-compose up --build
```

And it will pull HAproxy form docker hub, create a docker image with the provided configuration and start 1 HAproxy in front of 3 app nodes.

go to <a href="http://127.0.0.1:8881/v1/json/leagues" target="_blank">http://127.0.0.1:8881/v1/json/leagues</a>

# Docker hub image

A public docker image was pushed to https://hub.docker.com/r/cristiandavidgm/results and can be pulled using:
```sh
$ docker pull cristiandavidgm/results
```
Also, a different docker-compose file is provided, that file will use the 
public image so nothing hs to be built,  run: 
```sh
$ docker-compose -f docker-compose-public-image.yml up --build
```

# Public deploy
The app was deployed to Linode using a nanode with Centos 7 and is available at:

<a href="http://li294-74.members.linode.com:8881/v1/json/leagues " target="_blank">http://li294-74.members.linode.com:8881/v1/json/leagues</a>

Feel free to test it, try to not DDOS my server, it is just a Nanode 1GB: 1 CPU, 25GB Storage, 1GB RAM

# HTTP API

Results app provides 2 endpoints:

 - /v1/[protocol]/leagues
	 - Returns a list of league-season pairs for which results are available
 - /v1/[protocol]/results?league=[league]&season=[season]
	 - Returns all results related to the league-season pair requested inthe query params.

where protocol can be "json" or "proto", i.e:
 - /v1/json/leagues
	 - will return a list of league-season pairs in json format
 - /v1/proto/leagues
	 - will return a list of league-season pairs in Protocol Buffer format
 - /v1/json/results?league=D1&season=201617
	 - will return a list of results associated with leage D1 season 201617 in json format
- /v1/proto/results?league=D1&season=201617
	 - will return a list of results associated with leage D1 season 201617 in Protocol Buffer

# Code structure

Results codebase is very simple:

 - config/
	 - config.exs -> Contains only the config for maru framework
 - haproxy/
	 - Dockerfile -> To build HAproxy docker image
	 - haproxy.cfg -> very specific config to run 3 app nodes behind haproxy
 - lib/
	 - results/
		 - Results.Exprotobuf.Data.ex -> Uses exprotobuf library to parse the provided proto file and create the necessary structures to provide Protocol Buffer responses.
		 - db_loader.exs -> Defines a task that will take and parse the provided CSV file and  then will insert every row into de app db module
		 - http_server.ex -> defines the HTTP interface, the is no logic here, just adapters.
		 - league_season.ex -> data structure for league and seasson pairs
		 - league_season_db.ex -> Core module, it uses ETS tables to store the results. 
		 - result.ex -> data structure for results 
		 - results_api.ex -> This is the main module, **all interactions within the app should be made through this module, accessing the DB directly is highly discouraged** 
		 - supervisor.ex -> The one and only supervisor
		 - util.ex -> where I place funs that might be common to multiple modules .
	 - results.ex -> Application module
 - priv/
	 - Data.csv -> CSV file with the results for evey league-season pair.
	 - results.proto -> Defines Protocol buffer messages format.
 - rel/ -> created by "mix release.init", used mostly to configure different parameters for the stacks. 
 -  test/ -> unit tests files.
 
