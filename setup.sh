#!/bin/bash

# Agent Brain Bridge - Setup Script
# Complete setup for the brain bridge system

set -e

echo "================================================================"
echo "🧠 AGENT BRAIN BRIDGE SETUP"
echo "================================================================"
echo

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Functions
success() { echo -e "${GREEN}✅ $1${NC}"; }
info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; }

# Check if running from repo directory
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ ! -f "$REPO_DIR/README.md" ]; then
    error "Please run this script from the agent-brain-bridge directory"
    exit 1
fi

cd "$REPO_DIR"

# Parse arguments
AUTHENTICATE=false
TEST=false
UPDATE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --authenticate|-a)
            AUTHENTICATE=true
            shift
            ;;
        --test|-t)
            TEST=true
            shift
            ;;
        --update|-u)
            UPDATE=true
            shift
            ;;
        *)
            warning "Unknown option: $1"
            shift
            ;;
    esac
done

# Step 1: Update if requested
if [ "$UPDATE" = true ]; then
    info "Updating repository..."
    if git pull; then
        success "Repository updated"
    else
        warning "Failed to update repository"
    fi
fi

# Step 2: Install dependencies
info "Installing dependencies..."

# Python dependencies
if [ -f "requirements.txt" ]; then
    info "Installing Python packages..."
    if pip3 install -r requirements.txt; then
        success "Python dependencies installed"
    else
        warning "Failed to install some Python dependencies"
    fi
else
    # Install basic dependencies
    pip3 install requests beautifulsoup4 || warning "Python install failed"
fi

# Node.js dependencies
info "Checking agent-browser..."
if ! command -v agent-browser &> /dev/null; then
    info "Installing agent-browser..."
    if npm install -g @vercel-labs/agent-browser; then
        success "agent-browser installed"
    else
        warning "Failed to install agent-browser via npm"
        info "Trying alternative installation..."
        if curl -fsSL https://raw.githubusercontent.com/vercel-labs/agent-browser/main/install.sh | sh; then
            success "agent-browser installed via alternative method"
        else
            error "Failed to install agent-browser"
            echo "   You may need to install it manually:"
            echo "   npm install -g @vercel-labs/agent-browser"
        fi
    fi
else
    success "agent-browser already installed"
fi

echo

# Step 3: Set up configuration
info "Setting up configuration..."

# Create directories
mkdir -p ~/.hermes
mkdir -p ~/.agent-browser

# Copy config files
if [ -f "config-efficient.yaml" ]; then
    cp config-efficient.yaml ~/.hermes/
    success "Hermes config copied"
fi

# Make scripts executable
for script in *.py *.sh; do
    if [ -f "$script" ]; then
        chmod +x "$script" 2>/dev/null || true
    fi
done
success "Scripts made executable"

echo

# Step 4: Set environment variables
info "Configuring environment..."

ENV_VARS_SET=false

# Check bashrc
if ! grep -q "AGENT_BROWSER_ARGS" ~/.bashrc; then
    cat >> ~/.bashrc << 'EOF'

# Agent Brain Bridge Configuration
export AGENT_BROWSER_ARGS="--no-sandbox --disable-blink-features=AutomationControlled"
export AGENT_BROWSER_USER_AGENT="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
export HERMES_CONFIG="$HOME/.hermes/config-efficient.yaml"
export PATH="$PATH:'"$REPO_DIR"'"

EOF
    ENV_VARS_SET=true
fi

# Check zshrc
if [ -f ~/.zshrc ] && ! grep -q "AGENT_BROWSER_ARGS" ~/.zshrc; then
    cat >> ~/.zshrc << 'EOF'

# Agent Brain Bridge Configuration
export AGENT_BROWSER_ARGS="--no-sandbox --disable-blink-features=AutomationControlled"
export AGENT_BROWSER_USER_AGENT="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
export HERMES_CONFIG="$HOME/.hermes/config-efficient.yaml"
export PATH="$PATH:'"$REPO_DIR"'"

EOF
    ENV_VARS_SET=true
fi

if [ "$ENV_VARS_SET" = true ]; then
    success "Environment variables configured"
else
    info "Environment variables already set"
fi

echo

# Step 5: Create aliases
info "Creating aliases..."

# Create brain-bridge command
cat > /tmp/brain-bridge-alias.sh << EOF
#!/bin/bash
cd "$REPO_DIR"
python3 deepseek_brain_bridge.py "\$@"
EOF

sudo mv /tmp/brain-bridge-alias.sh /usr/local/bin/brain-bridge 2>/dev/null || \
mv /tmp/brain-bridge-alias.sh ~/.local/bin/brain-bridge 2>/dev/null || \
cp /tmp/brain-bridge-alias.sh "$REPO_DIR/brain-bridge"

chmod +x "$REPO_DIR/brain-bridge" 2>/dev/null || true
success "Command aliases created"

echo

# Step 6: Authenticate if requested
if [ "$AUTHENTICATE" = true ]; then
    info "Starting DeepSeek authentication..."
    echo
    echo "================================================================"
    echo "🔐 DEEPSEEK AUTHENTICATION"
    echo "================================================================"
    echo
    echo "This will open a browser for you to login to DeepSeek."
    echo "Please use these credentials:"
    echo "   Email: cryptoforex36963@gmail.com"
    echo "   Password: CosmicEnergy369!"
    echo
    echo "After login, the session will be saved for agent use."
    echo "You only need to do this once!"
    echo
    read -p "Press Enter to continue... "
    
    python3 authenticate_deepseek.py
fi

# Step 7: Test if requested
if [ "$TEST" = true ]; then
    info "Running tests..."
    echo
    if python3 test_complete_system.py; then
        success "Tests passed!"
    else
        warning "Some tests failed, but system may still work"
    fi
fi

# Step 8: Summary
echo
echo "================================================================"
echo "🎉 SETUP COMPLETE!"
echo "================================================================"
echo
echo "Your Agent Brain Bridge is ready!"
echo
echo "Quick start:"
echo "1. ${YELLOW}Authenticate DeepSeek (if not done):${NC}"
echo "   python3 authenticate_deepseek.py"
echo
echo "2. ${YELLOW}Test the system:${NC}"
echo "   python3 test_complete_system.py"
echo
echo "3. ${YELLOW}Use the brain bridge:${NC}"
echo "   python3 deepseek_brain_bridge.py --think 'Hello DeepSeek!'"
echo
echo "4. ${YELLOW}Use Research Agent:${NC}"
echo "   python3 research_agent.py 'Analyze some data'"
echo
echo "5. ${YELLOW}Extract Slack data:${NC}"
echo "   python3 slack_data_extractor.py --channel your-channel"
echo
echo "Available commands:"
echo "   ${GREEN}brain-bridge${NC}      - Use DeepSeek brain bridge directly"
echo "   ${GREEN}research-agent${NC}    - Use Research Agent (with DeepSeek)"
echo "   ${GREEN}slack-extract${NC}     - Extract data from Slack"
echo
echo "For Hermes integration:"
echo "   Use config: ~/.hermes/config-efficient.yaml"
echo "   Or run: hermes --config ~/.hermes/config-efficient.yaml"
echo
echo "Need to restart terminal? Run:"
echo "   source ~/.bashrc"
echo
echo "================================================================"
echo "📚 Full documentation: $REPO_DIR/README.md"
echo "🐛 Report issues: https://github.com/leviathan-devops/agent-brain-bridge/issues"
echo "================================================================"

# Clean up
cd "$REPO_DIR"

echo
info "Setup complete! Your agents now have super intelligence! 🧠🚀"