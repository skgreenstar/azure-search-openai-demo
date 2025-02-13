 #!/bin/sh

# echo 'Creating Python virtual environment "app/backend/.venv"...'
echo 'Activating Conda environment "azure-openai"...'

# python3 -m venv .venv

# echo 'Installing dependencies from "requirements.txt" into virtual environment (in quiet mode)...'
# .venv/bin/python -m pip --quiet --disable-pip-version-check install -r app/backend/requirements.txt


# Automatically detect Conda installation and source conda.sh
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

# Activate the Conda environment
conda activate azure-openai || { echo "Failed to activate Conda environment"; exit 1; }

echo 'Installing dependencies from "requirements.txt" into Conda environment...'
pip install --quiet --disable-pip-version-check -r app/backend/requirements.txt
pip install azure-core azure-ai-textanalytics azure-storage-blob azure-identity

echo "✅ Setup complete. Conda environment 'azure-openai' is ready!"
