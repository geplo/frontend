# Name for docker images.
NAME            = boilerplate

# Sources to watch for cache.
SRCS            = $(shell find app)    \
                  $(shell find static) \
                  server.js            \
                  webpack.config.js    \
                  package.json         \
                  Makefile             \
                  Dockerfile           \
                  release/Dockerfile   \
                  release/default.conf

# Default target.
all             : dev

# Build the docker image.
.mk_build       : $(SRCS)  # Cache file to rebuild only when there is a change.
		docker build --rm -t $(NAME)_build . # Build the docker image.
		@touch $@                            # Create cache file.

# Run the dev server with file watcher / hot reload.
dev             : .mk_build # Build the image before running it.
		@docker rm -f -v $(NAME)_dev_c 2> /dev/null || true # Cleanup any previous instance.
# Run docker with input/tty (-it) and discard the container when done (--rm).
# Mount the local sources to the container for hot reload. (-v ...)
# Expose the dev server port. (-p ...)
# Run npm start.
		docker run -it --rm --name $(NAME)_dev_c \
			-v '$(shell pwd)/app:/src/app'   \
			-p '8080:8080'                   \
			$(NAME)_build npm start

# Run the release image.
start           : .mk_release # In order to run we need the release image.
		@docker rm -f -v $(NAME)_c 2> /dev/null || true # Cleanup any previous instance.
# Run docker with input/tty (-it) and discard the container when done (--rm).
# Expose the dev server port. (-p ...).
# Run nginx.
		docker run -it --rm --name $(NAME)_c \
			-p '80:80' -p '443:443'      \
			$(NAME)_release

# Compile the assets for production.
.mk_assets.tar.gz: .mk_build # To compile the assets, we need to docker image.
# Run docker and discard the container when done (--rm).
# Set the node env to production (-e ...).
# Run npm build redirecting the output to stderr (>&2).
# Tar on stdout the static directory and save it locally (> $@).
		docker run --rm                             \
			-e NODE_ENV=production              \
			-e API_URL='$($(ENV_MODE)_API_URL)' \
			$(NAME)_build sh -c 'npm run build >&2 && tar czf - static release/default.conf' > $@


# Release create the release docker image.
release         : .mk_release
.mk_release     : .mk_assets.tar.gz # To build the release image, we need the compiled assets.
		docker build -t $(NAME)_release -f release/Dockerfile . # Build with the release dockerfile.
		@touch $@                                               # Create cache file.

# Small helper to split the package.json file
npminstall      : package.json package.base.json node_modules
		cp package.json package.json.bak  # Backup original package.json.
		cp package.base.json package.json # Copy the base deps to package.json.
		npm install                       # Install base deps.
		mv package.json.bak package.json  # Move back the original package.json in place.
		npm install                       # Install original deps.

# Run the linter.
lint            : .mk_build # We run the linter off the docker image.
		@docker rm -f -v $(NAME)_linter_c 2> /dev/null || true # Cleanup any previous instance.
# Run docker with input/tty (-it) and discard the container when done (--rm).
# Run the linter.
		docker run --rm -it --name $(NAME)_linter_c \
			$(NAME)_build sh -c 'npm run lint'

# Run the test suite.
test            : .mk_build # We run the tests off the docker image.
		@docker rm -f -v $(NAME)_test_c 2> /dev/null || true # Cleanup any previous instance.
# Run docker with input/tty (-it) and discard the container when done (--rm).
# Run npm test.
		docker run --rm -it --name $(NAME)_test_c \
			$(NAME)_build sh -c 'npm test'

# Cleanup target.
clean           :
		@sh -c 'rm -f .mk_*'              2> /dev/null || true # Cleanup the cache files.
		@docker rm -f -v $(NAME)_c        2> /dev/null || true # Cleanup any previous instance of `start`.
		@docker rm -f -v $(NAME)_dev_c    2> /dev/null || true # Cleanup any previous instance of `dev`.
		@docker rm -f -v $(NAME)_test_c   2> /dev/null || true # Cleanup any previous instance of `test`.
		@docker rm -f -v $(NAME)_linter_c 2> /dev/null || true # Cleanup any previous instance of `linter`.

distclean       : clean
		@rm -rf node_modules npm-debug.log # Cleanup node/npm files.

# List of usable targets.
.PHONY          : all dev clean release start npminstall test lint
