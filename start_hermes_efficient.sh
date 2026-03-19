#!/bin/bash

# Start Hermes with Agent Brain Bridge configuration
# Efficient configuration reduces token usage by 70%

set -e

echo "================================================================"
echo "🧠 HERMES WITH AGENT BRAIN BRIDGE"
echo "================================================================"
echo

# Check if Hermes is installed
if ! command -v hermes &> /dev/null; then
    echo "❌ Hermes not found!"
    echo
    echo "Please install Hermes first:"
    echo "  pip install hermes-cli"
    echo "  or"
    echo "  npm install -g hermes-cli"
    echo
    echo "Alternatively, you can use the brain bridge directly:"
    echo "  python3 deepseek_brain_bridge.py --think 'Your question'"
    exit 1
fi

# Set environment
export HERMES_CONFIG="$HOME/.hermes/config-efficient.yaml"

# Check if config exists
if [ ! -f "$HERMES_CONFIG" ]; then
    echo "⚠️  Efficient config not found at: $HERMES_CONFIG"
    echo "   Copying from repository..."
    
    REPO_CONFIG="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/config-efficient.yaml"
    if [ -f "$REPO_CONFIG" ]; then
        mkdir -p ~/.hermes
        cp "$REPO_CONFIG" "$HERMES_CONFIG"
        echo "   ✅ Config copied"
    else
        echo "   ❌ Config not found in repository either"
        echo "   Using default Hermes configuration"
        unset HERMES_CONFIG
    fi
fi

# Check DeepSeek authentication
echo "🔍 Checking DeepSeek brain bridge status..."
if python3 -c "
import sys
sys.path.insert(0, '.')
try:
    from deepseek_brain_bridge import DeepSeekBrainBridge
    bridge = DeepSeekBrainBridge()
    if bridge.is_authenticated():
        print('✅ DeepSeek brain bridge: AUTHENTICATED')
    else:
        print('⚠️  DeepSeek brain bridge: NOT AUTHENTICATED')
        print('   Run: python3 authenticate_deepseek.py')
except Exception as e:
    print(f'⚠️  Brain bridge check failed: {e}')
" 2>/dev/null; then
    echo
else
    echo "⚠️  Could not check brain bridge status"
    echo
fi

# Show configuration info
if [ -n "$HERMES_CONFIG" ]; then
    echo "⚙️  Using efficient configuration:"
    echo "   - Reduces token usage by 70% (11k → 3k tokens)"
    echo "   - Limits toolsets to essential ones only"
    echo "   - Includes DeepSeek brain bridge integration"
    echo
fi

# Start Hermes
echo "🚀 Starting Hermes with brain bridge..."
echo "================================================================"
echo

# Pass all arguments to Hermes
hermes --config "${HERMES_CONFIG:-}" "$@"