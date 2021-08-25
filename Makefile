# Use bash instead of sh
SHELL := /usr/bin/env bash

.PHONY: app-infra
app-infra:
	@source scripts/5-app-infra/app-infra.sh
