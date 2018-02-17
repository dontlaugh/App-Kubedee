bash_files="kubedee"
bash_files+="lib.bash"
bash_files+="scripts/configure-service-route"

all: lint

lint:
	shfmt -i 2 -w $(bash_files)
	shellcheck $(bash_files)

.PHONY: all lint
