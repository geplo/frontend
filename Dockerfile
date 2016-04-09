FROM    node:5.8

RUN     mkdir src
WORKDIR src

# Install and cache base deps.
ADD     package.base.json     package.json
RUN     npm install --progress=false --loglevel=error

## # Install and cache testing deps.
## ADD     package.cucumber.json package.json
## RUN     npm install --progress=false --loglevel=error

# Install and cache app deps.
ADD     package.json          package.json
RUN     npm install --progress=false --loglevel=error

# Add the app.
ADD     . ./
