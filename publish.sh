#!/bin/bash

mkdir -p builds/html5
godot --export HTML5 builds/html5/index.html
npx surge builds/html5 luser.surge.sh