#!/usr/bin/env bash


# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Welcome to the Project Setup CLI!${NC}"
echo "This script will help you scaffold your project."

# 1. Ask for Project Name
while [ -z "$PROJECT_NAME" ]; do
  read -p "Enter your project name: " PROJECT_NAME
  if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}Project name cannot be empty.${NC}"
  fi
done

if [ -d "$PROJECT_NAME" ]; then
    echo -e "${RED}Warning: Directory '$PROJECT_NAME' already exists.${NC}"
    read -p "Do you want to continue? (y/N) " continue_choice
    if [[ ! "$continue_choice" =~ ^[Yy]$ ]]; then
        echo "Exiting..."
        exit 1
    fi
fi

# 2. Pick Stack
echo -e "\n${GREEN}Choose your tech stack:${NC}"
echo "1) Frontend (React, Vue, etc. via Vite)"
echo "2) Backend (Node.js, Laravel)"
read -p "Enter choice (1-2): " stack_choice

if [ "$stack_choice" -eq 1 ]; then
    echo -e "\n${BLUE}Setting up Frontend project...${NC}"
    # Let create-vite handle the framework selection interactively
    # We pass the project name so it doesn't ask for it
    npm create vite@latest "$PROJECT_NAME"
    
elif [ "$stack_choice" -eq 2 ]; then
    echo -e "\n${GREEN}Choose Backend Framework:${NC}"
    echo "1) Node.js (Express API Boilerplate)"
    echo "2) Laravel (PHP)"
    read -p "Enter choice (1-2): " backend_choice

    if [ "$backend_choice" -eq 1 ]; then
        echo -e "\n${BLUE}Setting up Node.js project...${NC}"
        # Execute the helper script
        # Ensure it's executable
        chmod +x ./setup-nodeJs.sh
        ./setup-nodeJs.sh "$PROJECT_NAME"
        
    elif [ "$backend_choice" -eq 2 ]; then
        echo -e "\n${BLUE}Setting up Laravel project...${NC}"
        # Composer might not be installed, check first? 
        # But assuming environment is ready as per previous script logic.
        composer create-project --prefer-dist laravel/laravel "$PROJECT_NAME"
        
    else
        echo -e "${RED}Invalid backend choice.${NC}"
        exit 1
    fi
else
    echo -e "${RED}Invalid stack choice.${NC}"
    exit 1
fi

echo -e "\n${GREEN}✅ Project setup process finished!${NC}"
if [ "$stack_choice" -eq 1 ] || [ "$backend_choice" -eq 2 ]; then
    echo -e "Navigate to your project:\n  cd $PROJECT_NAME"
fi
# setup-nodeJs.sh already prints instructions, so we are good.