# Access your teaching profile

A service which enables teachers to manage their own teaching profile.

Currently in development.

### Application dependencies

- Ruby 3.x
- Node.js 16.x
- Yarn 1.22.x
- PostgreSQL 13.x

See [asdf tool versions](.tool-versions) for specific dependency versions.

## How the application works

We keep track of architecture decisions in [Architecture Decision Records
(ADRs)](/adr/).

We use `rladr` to generate the boilerplate for new records:

```bash
bin/bundle exec rladr new title
```

## Setup

Install dependencies using your preferred method, using `asdf` or `rbenv` or
`nvm`. Example with `asdf`:

```bash
# The first time
brew install asdf # Mac-specific
asdf plugin add ruby
asdf plugin add nodejs
asdf plugin add yarn
asdf plugin add postgres

# To install (or update, following a change to .tool-versions)
asdf install
```

### Database setup

If installing PostgreSQL via asdf, you may need to set up the postgres user:

```
pg_ctl start
createdb default
psql -d default
> CREATE ROLE postgres LOGIN SUPERUSER;
```

If the install step created the postgres user already, it won't have created one matching your username, and you'll see errors like:

```
FATAL: role "username" does not exist
```

So instead run:

```
pg_ctl start
createdb -U postgres default
```

You might also need to install postgresql-libs:

```
sudo apt install libpq-dev
sudo pacman -S postgresql-libs
sudo pamac install postgres-libs
sudo yum install postgresql-devel
sudo zypper in postgresql-devel
```

### Linting

To run the linters:

```bash
bin/lint
```

### Intellisense

[solargraph](https://github.com/castwide/solargraph) is bundled as part of the
development dependencies. You need to [set it up for your
editor](https://github.com/castwide/solargraph#using-solargraph), and then run
this command to index your local bundle (re-run if/when we install new
dependencies and you want completion):

```sh
bin/bundle exec yard gems
```

You'll also need to configure your editor's `solargraph` plugin to
`useBundler`:

```diff
+  "solargraph.useBundler": true,
```

## Licence

[MIT Licence](LICENCE).
