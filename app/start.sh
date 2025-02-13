#!/bin/sh

# cd into the parent directory of the script, 
# so that the script generates virtual environments always in the same path.
cd "${0%/*}" || exit 1

cd ../

echo 'Activating Conda environment "azure-openai"'

# Source the correct Conda initialization script
if [ -f "$HOME/opt/anaconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/opt/anaconda3/etc/profile.d/conda.sh"
else
    echo "Could not find conda.sh. Please check your Conda installation."
    exit 1
fi

# Activate the Conda environment
conda activate azure-openai || { echo "Failed to activate Conda environment"; exit 1; }

# ✅ Auto-detect resource group and load environment variables
RESOURCE_GROUP=$(ls .azure | head -n 1)
ENV_FILE=".azure/$RESOURCE_GROUP/.env"

if [ -f "$ENV_FILE" ]; then
    echo "Loading environment variables from $ENV_FILE"
    export $(grep -v '^#' "$ENV_FILE" | xargs)
else
    echo "⚠️ No .env file found in $ENV_FILE. Please check your .azure directory."
fi

echo ""
echo "Restoring backend python packages"
echo ""

pip install -r app/backend/requirements.txt
out=$?
if [ $out -ne 0 ]; then
    echo "Failed to restore backend python packages"
    exit $out
fi

echo ""
echo "Restoring frontend npm packages"
echo ""

cd app/frontend
npm install
out=$?
if [ $out -ne 0 ]; then
    echo "Failed to restore frontend npm packages"
    exit $out
fi

echo ""
echo "Building frontend"
echo ""

npm run build
out=$?
if [ $out -ne 0 ]; then
    echo "Failed to build frontend"
    exit $out
fi

echo ""
echo "Starting backend"
echo ""

cd ../backend

port=50505
host=localhost
quart --app main:app run --port "$port" --host "$host" --reload
out=$?
if [ $out -ne 0 ]; then
    echo "Failed to start backend"
    exit $out
fi
