FROM centos:8

RUN dnf clean all && \
	dnf update -y && dnf upgrade -y && \
	dnf install -y --setopt=install_weak_deps=false \
		npm \
		bash \
		sqlite \
		python3 \
		make \
		automake \
		gcc \
		gcc-c++ \
		git \
		sqlite

# RUN yum module install -y nodejs/development

ENV SERVER_PORT=8081

EXPOSE ${SERVER_PORT}:${SERVER_PORT}

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN useradd -m app

COPY --chown=app ./app /graphql

WORKDIR /graphql

RUN npm install sqlite3

RUN npm install

RUN npm run tsc

RUN npm run sequelize db:migrate

RUN npm run sequelize db:seed:all

RUN chown app /graphql

USER app

ENTRYPOINT [ "docker-entrypoint.sh" ]
