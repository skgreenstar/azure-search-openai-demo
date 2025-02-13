#!/bin/sh

echo "Checking if authentication should be set up..."

AZURE_USE_AUTHENTICATION=$(azd env get-value AZURE_USE_AUTHENTICATION)

if [ "$AZURE_USE_AUTHENTICATION" != "true" ]; then
  echo "AZURE_USE_AUTHENTICATION is not set, skipping authentication setup."
  exit 0
fi

echo "AZURE_USE_AUTHENTICATION is set, proceeding with authentication setup..."

# Automatically source Conda's initialization script
if [ -f "$HOME/opt/anaconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/opt/anaconda3/etc/profile.d/conda.sh"
elif [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/miniconda3/etc/profile.d/conda.sh"
elif [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
    source "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
else
    echo "Could not find conda.sh. Please check your Conda installation."
    exit 1
fi

# Activate Conda environment
conda activate azure-openai || { echo "Failed to activate Conda environment"; exit 1; }

echo "Running authentication script 'auth_init.py'"

# Run authentication script using Conda's Python
python ./scripts/auth_init.py
