#!/bin/bash

# Agent Brain Bridge - One-Click Installer
# Installs everything needed for DeepSeek brain bridge in one command

set -e

echo "================================================================"
echo "🧠 AGENT BRAIN BRIDGE - ONE-CLICK INSTALLER"
echo "================================================================"
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

check_command() {
    if command -v $1 &> /dev/null; then
        print_success "$1 installed"
        return 0
    else
        print_warning "$1 not found"
        return 1
    fi
}

# Step 1: Check system
echo "1. Checking system requirements..."
echo "   ========================================="

check_command "python3"
check_command "pip3"
check_command "node"
check_command "npm"
check_command "git"
check_command "curl"

echo

# Step 2: Install dependencies
echo "2. Installing dependencies..."
echo "   ========================================="

# Python dependencies
print_info "Installing Python packages..."
pip3 install --upgrade pip || print_warning "pip upgrade failed, continuing..."

PYTHON_DEPS="requests beautifulsoup4"
if pip3 install $PYTHON_DEPS; then
    print_success "Python dependencies installed"
else
    print_warning "Some Python dependencies failed, continuing..."
fi

# Node.js dependencies
print_info "Installing agent-browser..."
if npm install -g @vercel-labs/agent-browser; then
    print_success "agent-browser installed"
else
    print_error "Failed to install agent-browser"
    echo "   Trying alternative installation..."
    if curl -fsSL https://raw.githubusercontent.com/vercel-labs/agent-browser/main/install.sh | sh; then
        print_success "agent-browser installed via alternative method"
    else
        print_warning "agent-browser installation failed, some features may not work"
    fi
fi

echo

# Step 3: Clone or update repository
echo "3. Setting up repository..."
echo "   ========================================="

REPO_DIR="$HOME/agent-brain-bridge"
REPO_URL="https://github.com/leviathan-devops/agent-brain-bridge.git"

if [ -d "$REPO_DIR" ]; then
    print_info "Repository exists, updating..."
    cd "$REPO_DIR"
    if git pull; then
        print_success "Repository updated"
    else
        print_warning "Failed to update repository, using existing files"
    fi
else
    print_info "Cloning repository..."
    if git clone "$REPO_URL" "$REPO_DIR"; then
        print_success "Repository cloned"
        cd "$REPO_DIR"
    else
        print_error "Failed to clone repository"
        echo "   Creating directory manually..."
        mkdir -p "$REPO_DIR"
        cd "$REPO_DIR"
    fi
fi

echo

# Step 4: Copy files to home directory
echo "4. Setting up files..."
echo "   ========================================="

# Create necessary directories
mkdir -p ~/.hermes
mkdir -p ~/.agent-browser

# Copy configuration files
print_info "Copying configuration files..."

if [ -f "config-efficient.yaml" ]; then
    cp config-efficient.yaml ~/.hermes/
    print_success "Hermes config copied"
else
    print_warning "Hermes config not found in repo"
fi

# Make scripts executable
for script in *.sh; do
    if [ -f "$script" ]; then
        chmod +x "$script"
        print_success "Made executable: $script"
    fi
done

for script in *.py; do
    if [ -f "$script" ]; then
        chmod +x "$script" 2>/dev/null || true
    fi
done

echo

# Step 5: Set environment variables
echo "5. Configuring environment..."
echo "   ========================================="

print_info "Setting up environment variables..."

# Check if variables already exist in bashrc
if ! grep -q "AGENT_BROWSER_ARGS" ~/.bashrc; then
    cat >> ~/.bashrc << 'EOF'

# Agent Brain Bridge Configuration
export AGENT_BROWSER_ARGS="--no-sandbox --disable-blink-features=AutomationControlled"
export AGENT_BROWSER_USER_AGENT="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
export HERMES_CONFIG="$HOME/.hermes/config-efficient.yaml"
export PATH="$PATH:$HOME/agent-brain-bridge"

EOF
    print_success "Environment variables added to ~/.bashrc"
else
    print_info "Environment variables already configured"
fi

# Source bashrc to apply changes
source ~/.bashrc 2>/dev/null || true

echo

# Step 6: Create startup scripts
echo "6. Creating startup scripts..."
echo "   ========================================="

# Create Hermes startup script
cat > ~/start_brain_bridge.sh << 'EOF'
#!/bin/bash
# Start Hermes with Agent Brain Bridge configuration

echo "🧠 Starting Agent Brain Bridge..."
echo "================================================================"

# Set environment
export HERMES_CONFIG="$HOME/.hermes/config-efficient.yaml"

# Check if Hermes is installed
if command -v hermes &> /dev/null; then
    echo "Starting Hermes with brain bridge configuration..."
    hermes --config "$HERMES_CONFIG" "$@"
else
    echo "Hermes not found. Starting brain bridge directly..."
    cd ~/agent-brain-bridge
    python3 deepseek_brain_bridge.py "$@"
fi
EOF

chmod +x ~/start_brain_bridge.sh
print_success "Created startup script: ~/start_brain_bridge.sh"

# Create quick test script
cat > ~/test_brain_bridge.sh << 'EOF'
#!/bin/bash
# Quick test for Agent Brain Bridge

echo "🧪 Testing Agent Brain Bridge..."
echo "================================================================"

cd ~/agent-brain-bridge

# Test Python module
echo "1. Testing Python module..."
if python3 -c "import sys; sys.path.insert(0, '.'); from deepseek_brain_bridge import DeepSeekBrainBridge; print('✅ Python module imports successfully')"; then
    echo "   ✅ Python module OK"
else
    echo "   ❌ Python module failed"
fi

# Test agent-browser
echo "2. Testing agent-browser..."
if agent-browser --version &> /dev/null; then
    echo "   ✅ agent-browser OK"
else
    echo "   ❌ agent-browser not working"
fi

# Test configuration
echo "3. Testing configuration..."
if [ -f ~/.hermes/config-efficient.yaml ]; then
    echo "   ✅ Hermes config exists"
else
    echo "   ❌ Hermes config missing"
fi

echo
echo "================================================================"
echo "Quick test complete!"
echo "Next: Run 'python3 authenticate_deepseek.py' to authenticate DeepSeek"
EOF

chmod +x ~/test_brain_bridge.sh
print_success "Created test script: ~/test_brain_bridge.sh"

echo

# Step 7: Create aliases
echo "7. Creating command aliases..."
echo "   ========================================="

if ! grep -q "alias brain-bridge" ~/.bashrc; then
    cat >> ~/.bashrc << 'EOF'

# Agent Brain Bridge Aliases
alias brain-bridge="~/start_brain_bridge.sh"
alias deepseek-auth="python3 ~/agent-brain-bridge/authenticate_deepseek.py"
alias research-agent="python3 ~/agent-brain-bridge/research_agent.py"
alias slack-extract="python3 ~/agent-brain-bridge/slack_data_extractor.py"
alias test-bridge="~/test_brain_bridge.sh"

EOF
    print_success "Command aliases created"
else
    print_info "Aliases already exist"
fi

echo

# Step 8: Final setup
echo "8. Finalizing setup..."
echo "   ========================================="

# Create requirements.txt if it doesn't exist
if [ ! -f "requirements.txt" ]; then
    cat > requirements.txt << 'EOF'
requests>=2.28.0
beautifulsoup4>=4.11.0
EOF
    print_success "Created requirements.txt"
fi

# Create package.json if it doesn't exist
if [ ! -f "package.json" ]; then
    cat > package.json << 'EOF'
{
  "name": "agent-brain-bridge",
  "version": "1.0.0",
  "description": "DeepSeek brain bridge for AI agents",
  "dependencies": {
    "@vercel-labs/agent-browser": "^0.21.0"
  }
}
EOF
    print_success "Created package.json"
fi

echo

# Step 9: Summary
echo "================================================================"
echo "🎉 INSTALLATION COMPLETE!"
echo "================================================================"
echo
echo "What was installed:"
echo "✅ Python dependencies"
echo "✅ agent-browser (web automation)"
echo "✅ Repository files"
echo "✅ Environment configuration"
echo "✅ Startup scripts"
echo "✅ Command aliases"
echo
echo "Files location:"
echo "📁 Repository: $REPO_DIR"
echo "⚙️  Config: ~/.hermes/config-efficient.yaml"
echo "🚀 Startup: ~/start_brain_bridge.sh"
echo "🧪 Test: ~/test_brain_bridge.sh"
echo
echo "Next steps:"
echo "1. ${YELLOW}Authenticate DeepSeek (one-time):${NC}"
echo "   deepseek-auth"
echo "   or"
echo "   python3 ~/agent-brain-bridge/authenticate_deepseek.py"
echo
echo "2. ${YELLOW}Test the installation:${NC}"
echo "   test-bridge"
echo
echo "3. ${YELLOW}Start using:${NC}"
echo "   brain-bridge"
echo "   or"
echo "   research-agent 'Analyze some data'"
echo
echo "4. ${YELLOW}Extract Slack data:${NC}"
echo "   slack-extract --channel your-channel"
echo
echo "Command aliases available:"
echo "   brain-bridge     - Start Hermes with brain bridge"
echo "   deepseek-auth    - Authenticate DeepSeek"
echo "   research-agent   - Use Research Agent"
echo "   slack-extract    - Extract Slack data"
echo "   test-bridge      - Test installation"
echo
echo "Need to restart terminal? Run:"
echo "   source ~/.bashrc"
echo
echo "================================================================"
echo "📚 Documentation: https://github.com/leviathan-devops/agent-brain-bridge"
echo "🐛 Issues: https://github.com/leviathan-devops/agent-brain-bridge/issues"
echo "================================================================"

# Clean up
cd ~

echo
print_info "Installation complete! Your agents now have a brain bridge to DeepSeek! 🧠"