# Geplo Frontend

Front-end boiler plate with Docker, nginx, webpack, hotreload, react, less, boostrap

<!-- npm install -g readme-toc -->
<!-- toc -->
* [Dependencies](#dependencies)
  * [Geplo](#geplo)
  * [Node Dependencies](#node-dependencies)
* [Start development environment](#start-development-environment)
  * [Using Makefile / Docker (recommended)](#using-makefile-docker-recommended)
    * [Make tree](#make-tree)
  * [Using node](#using-node)
* [Start production environment](#start-production-environment)
  * [Using Makefile / Docker (recommended)](#using-makefile-docker-recommended)
    * [Make tree](#make-tree)
  * [Using node](#using-node)
* [Coding style](#coding-style)
  * [Using Makefile / Docker (recommended)](#using-makefile-docker-recommended)
  * [Using node](#using-node)
* [Troubleshooting](#troubleshooting)
  * [make error](#make-error)
  * [npm dependencies issue (without Docker)](#npm-dependencies-issue-without-docker)
* [TODOs (help needed)](#todos-help-needed)

<!-- toc stop -->

## Dependencies

### Geplo

In order to use this project, you will need:

- make
- docker (tested on v1.9.1)

Alternatevely, if you do not want to use Docker (not recommended), you can use node directly and will need:

- make (for npm dependencies)
- node.js (tested on v5.8.0) with npm (tested on v3.7.3)

### Node Dependencies

In order to speed up build time, we optimize the dependency to be split into multiple package.json.
npm does not support passing a file name so we need to mvove files around.

When running via the Makefile and Docker, you don't need to worry about it.

When running locally, outside docker, you need to run `make npminstall` instead of `npm install` in order
to install all the `package.json` files.

## Start development environment

### Using Makefile / Docker (recommended)

In order to start the development environment via Docker, simply run `make dev`.

This will build the docker images including the cached node dependencies and run `npm start` in a container
while mounting the local `app` directory inside it so change made locally are also in the container.
`npm start` uses webpack to watch the files and perform hot-reload.

#### Make tree

- trigger main `Dockerfile` build
  - build the main `Dockerfile`
    - run `npm run build` within a container and extract assets
  - cleanup previous instances if any
  - run `npm start` in a container with port exposed and local `app` directory mounted inside the container

### Using node

In order to start the development environment without Docker, you will need:

- `make npminstall`: Install node dependencies locally. Beware that interruption might require you to reset the `package.json` file.
- `npm start`

## Start production environment

### Using Makefile / Docker (recommended)

In order to start the production environment via Docker, simply run `make start`.

This will build the release docker image in production mode and run it. No local directory get mounted in the container.

#### Make tree

- trigger `make release`
  - trigger asset creation
    - trigger main `Dockerfile` build
      - build the main `Dockerfile`
	- run `npm run build` within a container and extract assets
  - build the release `Dockerfile`

### Using node

Currently we do not support a production runtime for node. One can build the assets running `npm run build` which is going to
populate the `static` directory.
NOTE: Make sure you installed the node dependcies prior via `make npminstall`.

## Coding style

This project uses the `airbnb` eslint config for `react`. With a few changes though that can be found in
the `.eslintrc.yaml` file. Namely:

- `no-multi-spaces`: only for the `ImportDeclaration`. This allow to have the imports aligned.
- `key-spacing`: forces the objects values to be aligned.

### Using Makefile / Docker (recommended)

In order to run the linter, simply run `make lint`.

### Using node

In order to run the linter with node, make sure you have installed all dependencies (`make npminstall`) then run `npm run lint`

## Troubleshooting

### make error

Most of the errors yielded by `make` (unless you changed the `Makefile`) are due to the cache being out
of sync with docker. Run `make clean` to start fresh.

### npm dependencies issue (without Docker)

As `npm` does not support target file name, we need to move file around. If something goes wrong or
if the process is interrupted, you might ended in a "corrupted" state. Revert the `package.json` should solve the issue.

### Misc

- `npm ERR! network getaddrinfo ENOTFOUND registry.npmjs.org registry.npmjs.org:443` This is due to a DNS issue with the Docker VM. Restart the VM should fix the issue: `docker-machine restart default` (where `default` is your machine name.

## TODOs (help needed)

Random thoughts on what I want to do in the (near) future:

- Geplo
  - promote the project
  - improve SEO (check the github tags, keywords in the readme, etc)
  - create a contributing.md with guide lines
  - test with docker 1.11
  - write a headline at the top of this file describing briefly what geplo is and why
  - dockerize npm readme-toc (do not add the deps to the regular mode, or maybe in the devDeps of package.base.json)
  - Move this file in something like `advanced.md` and keep only the basic info here.
  - Make sure to keep the TOC up to date
  - Create node and golang backends
- App
  - improve SEO for the app (server side rendering?)
  - add a data access layer (https://github.com/matthew-andrews/isomorphic-fetch maybe?)
  - change file structure, I don't like having .js and .jsx (but I might be off on that one)
  - add offline detection
  - make the boilerplate an auth'd app (and everything it implied: db, driver, models, tests, pool, hot reload change)
  - add a logger for frontend
  - The rendering is aweful, it takes forever for JS to apply the dom so we see the "raw" markup for a bit. Not sure why, maybe because of bootstrap? I don't have that issue with materialize using the same build process with a much more complex app.
  - add unit tests using jest? mocha?
  - add integration tests with cucumber? / selenium / phantomjs
  - add redux / react router when plugged with API
  - add sort props constraint to eslint
- API
  - create a generic api boilerplate and plug it with the frontend
  - support mongo, postgres and maybe other backend for auth
  - add redis cache (+ add support for other caches)
  - add make modules for supported tools
  - add service discovery with consul (and maybe etcd/redis/zk) support
  - add tests
  - add a load-balancer
  - add a logger for backend
  - add metrics
  - create docs
- Build
  - add a production server for node without requiring docker.
  - add ports configuration to the makefile
  - add makefile module framework
  - rework the webpack config
    - make sure minify / optimizations works for js and css
    - isolate compiled assets from user assets
  - find a better way to handle npm install
- Deployment
  - Create AWS cloud formation templates (or maybe can be done via docker-machine?)
  - Create docker-cloud config file
  - Maybe add support for kubernetes?
  - Use docker auto build / github pages to serve the app? (how to deal with the backend part?)
  - create a generator script to spinup am empty app shapped the way the user wants?
