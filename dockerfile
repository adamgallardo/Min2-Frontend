# Stage 1 - Install dependencies and build the app
FROM debian:bookworm AS build-env

# Install flutter dependencies
RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3
RUN apt-get clean

# Clone the flutter repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter path and install specific versions
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN /usr/local/flutter/bin/flutter --version
RUN /usr/local/flutter/bin/flutter --version

# Run flutter doctor
RUN /usr/local/flutter/bin/flutter doctor -v

RUN /usr/local/flutter/bin/flutter channel master
RUN /usr/local/flutter/bin/flutter upgrade 3.13.0
RUN /usr/local/flutter/bin/flutter config --enable-web

# Copy files to container and build
RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN /usr/local/flutter/bin/flutter build web

EXPOSE 80

# Stage 2 - Create the run-time image
FROM nginx:latest
COPY --from=build-env /app/build/web /usr/share/nginx/html

#docker build -t frontend:0.1.1 .
#docker run -p 7070:80 frontend:0.1.1
#docker tag frontend:0.1.2 jordipie/frontend:0.1.2
#docker push jordipie/frontend:0.1.2
