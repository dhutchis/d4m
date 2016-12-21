#!/bin/bash
set -e #command fail -> script fail
set -u #unset variable reference causes script fail

cd ~/gits/d4m
if output=$(git status --untracked-files=no --porcelain) && [ -z "$output" ]; then
  # Working directory clean

	cd ~/gits/graphulo
	if output=$(git status --untracked-files=no --porcelain) && [ -z "$output" ]; then
		# clean
		ghash=$(git rev-parse HEAD)
		gline=$(git log -1 --oneline)
		mvn clean package -DskipTests
		./deploy.sh
		echo "$ghash"
		echo "$gline"
		cd ~/gits/d4m
		git add "./lib/graphulo-1.0.0-SNAPSHOT.jar"
		git add "./matlab_src/DBinit.m"
		git commit -m "Update Graphulo

Accla/graphulo@$ghash
$gline"
	else
		# Uncommitted changes
		echo "You appear to have uncommitted changes in Graphulo:"
		git status --untracked-files=no  --porcelain
	fi
else 
	# Uncommitted changes
	echo "You appear to have uncommitted changes in D4M:"
	git status --untracked-files=no  --porcelain
fi

