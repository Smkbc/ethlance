# Makefile for Development and Production Builds

.PHONY: help
.PHONY: dev-server
.PHONY: fig-dev-server fig-dev-ui
.PHONY: build-server build-ui build-contracts build-dist build
.PHONY: test
.PHONY: clean

help:
	@echo "Ethlance Development and Production Build Makefile"
	@echo ""
	@echo "Development Commands:"
	@echo "  dev-server              :: Run Development Node Server for Figwheel Server Build"
	@echo "  repl                    :: Start CLJ Repl."
	@echo "  fig-dev-server          :: Start and watch Figwheel Server Build."
	@echo "  fig-dev-ui              :: Start and watch Figwheel UI Build."
	@echo "  watch-contracts         :: Start and watch Solidity Contracts."
	@echo ""
	@echo "Production Commands:"
	@echo "  build                   :: Perform Production Build of Ethlance."
	@echo "  build-ui                :: Perform Production Build of Browser UI Only."
	@echo "  build-server            :: Perform Production Build of Node Server Only."
	@echo "  build-contracts         :: Build Solidity Contracts Once."
	@echo ""
	@echo "Testing Commands:"
	@echo "  test                    :: Run Server Tests."

	@echo "Misc Commands:"
	@echo "  clean                   :: Clean out build artifacts"
	@echo "  help                    :: Display this help message"


dev-server:
	node target/node/ethlance_server.js


fig-dev-server:
	lein figwheel dev-server


fig-dev-ui:
	lein figwheel dev-ui


clean:
	lein clean
	rm -rf dist


clean-all: clean
	rm -rf node_modules


deps:
	lein deps


build-ui:
	lein cljsbuild once prod-ui


build-server:
	lein cljsbuild once prod-server


build-contracts:
	lein solc once


build-dist: deps
	cp -R ./resources ./dist/
	cp -R node_modules ./dist/
	sed -i s/ethlance_ui.js/ethlance_ui.min.js/g dist/resources/public/index.html


build: clean-all deps build-ui build-server build-contracts build-dist


test:
	lein doo node "test-server" once
