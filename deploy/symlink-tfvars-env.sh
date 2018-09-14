#!/bin/bash
ln -sf ../postgres/.env postgres.auto.tfvars
ln -sf ../data2paper/.env data2paper.auto.tfvars
ln -sf ../data2paper/.env.default data2paper.default.auto.tfvars
ln -sf ../fedora.env fedora.auto.tfvars
