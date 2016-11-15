#!/usr/bin/env bash

echo "Running the bisect testing script..."

if [ -f lib/cache.js ]; then

    echo "🚫 File still exists in the repository..."
    exit 1
fi

echo "✅ File not found!"
exit 0
