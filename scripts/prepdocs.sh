#!/bin/sh

echo 'Activating Conda environment "azure-openai"...'

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

echo 'Running "prepdocs.py"'

# Pass additional arguments if provided
additionalArgs=""
if [ $# -gt 0 ]; then
  additionalArgs="$@"
fi

# Run the script using Conda's Python
python ./app/backend/prepdocs.py './data/*' --verbose $additionalArgs
