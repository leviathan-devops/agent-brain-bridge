# 🧠 Agent Brain Bridge

**Free DeepSeek Web Chat Access for AI Agents - One-Click Installation**

> **🚀 V2 NOW AVAILABLE:** Complete Hermes optimization with **95.6% token reduction** and **6x productivity improvement**!  
> See [README_V2.md](README_V2.md) for details or run `./setup.sh --v2`

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![Hermes Compatible](https://img.shields.io/badge/Hermes-Compatible-green.svg)](https://github.com/saoudrizwan/Hermes)

> Give your AI agents FREE access to DeepSeek R1 reasoning through your personal web chat. No API keys needed!

## 🎯 What is This?

**Agent Brain Bridge** is a complete system that allows AI agents (like Hermes) to "think" using your personal DeepSeek web chat account. It solves three critical problems:

1. **Free Super Intelligence**: Agents get FREE access to DeepSeek R1 reasoning (normally $0.14/M tokens)
2. **Web Chat Access**: Uses your existing DeepSeek web chat (no API keys needed)
3. **Efficiency**: Reduces Hermes token usage by 70% (11k → 3k tokens per prompt)

## ✨ Features

- ✅ **One-Click Installation**: `curl -sSL https://raw.githubusercontent.com/leviathan-devops/agent-brain-bridge/main/install.sh | bash`
- ✅ **Free DeepSeek Access**: Uses your personal DeepSeek web chat account
- ✅ **Hermes Integration**: Works seamlessly with Hermes AI agents
- ✅ **Research Agent**: Built-in agent for data analysis and synthesis
- ✅ **Slack Integration**: Extract and analyze Slack channel data
- ✅ **Efficiency Optimized**: Reduces token waste by 70%
- ✅ **Persistent Sessions**: One-time authentication, lifetime access
- ✅ **Backup Sessions**: Multiple agent chat terminals supported

## 🚀 Quick Start

### One-Line Installation
```bash
# Install everything with one command
curl -sSL https://raw.githubusercontent.com/leviathan-devops/agent-brain-bridge/main/install.sh | bash
```

### Manual Installation
```bash
# Clone the repository
git clone https://github.com/leviathan-devops/agent-brain-bridge.git
cd agent-brain-bridge

# Run setup
./setup.sh
```

## 📋 Prerequisites

- **Linux/macOS** (Windows via WSL)
- **Python 3.8+**
- **Node.js 16+** (for agent-browser)
- **DeepSeek Account** (free at [chat.deepseek.com](https://chat.deepseek.com))

## 🔧 How It Works

### Architecture
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Your Agent    │───▶│  Brain Bridge   │───▶│  DeepSeek Web   │
│   (Hermes/etc)  │    │   (Python)      │    │     Chat        │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Reduced Tokens │    │  Auth Session   │    │  Free R1 Access │
│   (70% less)    │    │   (Persistent)  │    │  ($0 saved)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Key Components

1. **DeepSeek Brain Bridge** (`deepseek_brain_bridge.py`)
   - Python module that connects agents to DeepSeek web chat
   - Uses `agent-browser` for web automation
   - Handles authentication and session management

2. **Research Agent** (`research_agent.py`)
   - Specialized agent for data analysis
   - Uses DeepSeek for advanced reasoning
   - Creates training datasets from analyzed data

3. **Slack Data Extractor** (`slack_data_extractor.py`)
   - Extracts data from Slack channels
   - Prepares data for Research Agent analysis
   - Categorizes links, code, and discussions

4. **Efficient Hermes Config** (`config-efficient.yaml`)
   - Reduces token usage from 11k+ to ~3k
   - Limits toolsets to essential ones only
   - Prevents rate limiting

## 🛠️ Installation

### Step 1: One-Click Install
```bash
curl -sSL https://raw.githubusercontent.com/leviathan-devops/agent-brain-bridge/main/install.sh | bash
```

### Step 2: Authenticate DeepSeek
```bash
# This opens a browser for one-time login
python3 authenticate_deepseek.py

# Login with your DeepSeek credentials:
# Email: YOUR_DEEPSEEK_EMAIL_HERE
# Password: YOUR_DEEPSEEK_PASSWORD_HERE
```

### Step 3: Start Using
```bash
# Start Hermes with efficient configuration
./start_hermes_efficient.sh

# Or use directly in Python
python3 -c "from deepseek_brain_bridge import DeepSeekBrainBridge; bridge = DeepSeekBrainBridge(); print(bridge.think('Hello DeepSeek!'))"
```

## 📖 Usage Examples

### 1. Basic Brain Bridge Usage
```python
from deepseek_brain_bridge import DeepSeekBrainBridge

# Initialize the bridge
bridge = DeepSeekBrainBridge()

# Think with DeepSeek
response = bridge.think("What are the key trends in AI for 2026?")
print(response)
```

### 2. Research Agent for Data Analysis
```python
from research_agent import ResearchAgent

# Initialize Research Agent with DeepSeek thinking
agent = ResearchAgent(use_deepseek=True)

# Analyze data
analysis = agent.analyze_data(
    "Twitter links about AI, GitHub repos for ML, and research papers",
    data_type="mixed"
)

# Create training dataset
dataset_path = agent.create_training_dataset([analysis], output_format="json")
```

### 3. Slack Data Extraction
```bash
# Extract data from Slack channel
python3 slack_data_extractor.py --channel ai-discussions --limit 100 --prepare-for-agent

# Analyze extracted data
python3 research_agent.py "Analyze the Slack data in slack_extracted_data.json"
```

### 4. Hermes Integration
```bash
# Start Hermes with brain bridge enabled
./start_hermes_efficient.sh

# In Hermes, you can now:
# - "Analyze this data using DeepSeek"
# - "Think about this problem with DeepSeek"
# - "Research this topic using the brain bridge"
```

## 🔌 Integration with AI Agents

### Hermes Agent
```yaml
# In your Hermes config (config-efficient.yaml)
deepseek_bridge:
  enabled: true
  session_name: "deepseek-agent"
  command: "python3 /path/to/deepseek_brain_bridge.py"
```

### Custom Python Agent
```python
import subprocess
import json

def think_with_deepseek(prompt):
    """Use DeepSeek brain bridge from any Python script."""
    result = subprocess.run(
        ['python3', 'deepseek_brain_bridge.py', '--think', prompt],
        capture_output=True,
        text=True
    )
    return result.stdout

# Usage
deepseek_response = think_with_deepseek("Help me debug this code...")
```

### CLI Usage
```bash
# Direct CLI access
python3 deepseek_brain_bridge.py --think "Explain quantum computing"

# Batch processing
echo "What is AI?" | python3 deepseek_brain_bridge.py --stdin
```

## 📁 Project Structure
```
agent-brain-bridge/
├── README.md                 # This file
├── install.sh               # One-click installer
├── setup.sh                 # Complete setup script
├── deepseek_brain_bridge.py # Core brain bridge module
├── authenticate_deepseek.py # One-time authentication
├── research_agent.py        # Research Agent with DeepSeek
├── slack_data_extractor.py  # Slack data extraction
├── config-efficient.yaml    # Efficient Hermes configuration
├── start_hermes_efficient.sh # Hermes startup script
├── test_complete_system.py  # System verification
├── requirements.txt         # Python dependencies
├── package.json            # Node.js dependencies
└── examples/               # Usage examples
    ├── basic_usage.py
    ├── hermes_integration.md
    └── slack_analysis.md
```

## ⚙️ Configuration

### Environment Variables
```bash
# Add to ~/.bashrc or ~/.zshrc
export AGENT_BROWSER_ARGS="--no-sandbox --disable-blink-features=AutomationControlled"
export AGENT_BROWSER_USER_AGENT="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
export HERMES_CONFIG="$HOME/.hermes/config-efficient.yaml"
```

### DeepSeek Credentials
Create `~/.deepseek_credentials` (optional):
```json
{
  "email": "YOUR_DEEPSEEK_EMAIL_HERE",
  "password": "YOUR_DEEPSEEK_PASSWORD_HERE"
}
```

## 🚨 Troubleshooting

### Common Issues

1. **"agent-browser not found"**
   ```bash
   npm install -g @vercel-labs/agent-browser
   ```

2. **DeepSeek authentication failed**
   ```bash
   # Re-authenticate
   python3 authenticate_deepseek.py
   ```

3. **Hermes rate limiting**
   ```bash
   # Use efficient configuration
   ./start_hermes_efficient.sh
   ```

4. **Session expired**
   ```bash
   # Clear and re-authenticate
   rm -rf ~/.agent-browser/sessions/deepseek-agent
   python3 authenticate_deepseek.py
   ```

### Debug Mode
```bash
# Enable debug logging
export DEEPSEEK_DEBUG=1
python3 deepseek_brain_bridge.py --debug
```

## 🔄 Maintenance

### Update the Brain Bridge
```bash
cd agent-brain-bridge
git pull
./setup.sh --update
```

### Create Backup Sessions
```bash
# Use different session names for backup
python3 authenticate_deepseek.py --session deepseek-agent-2
python3 authenticate_deepseek.py --session deepseek-agent-3
```

### Monitor Usage
```bash
# Check session status
python3 deepseek_brain_bridge.py --status

# View token usage
python3 deepseek_brain_bridge.py --stats
```

## 📊 Performance

- **Token Reduction**: 11,356 → ~3,200 tokens (70% savings)
- **Response Time**: 5-10 seconds for DeepSeek responses
- **Session Lifetime**: Weeks to months (persistent cookies)
- **Concurrent Agents**: Multiple agents can share same session

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Vercel Labs](https://github.com/vercel-labs/agent-browser) for the agent-browser
- [DeepSeek](https://www.deepseek.com) for free AI access
- [Hermes](https://github.com/saoudrizwan/Hermes) for the agent framework

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/leviathan-devops/agent-brain-bridge/issues)
- **Discussions**: [GitHub Discussions](https://github.com/leviathan-devops/agent-brain-bridge/discussions)
- **Email**: leviathan.devops@example.com

---

**⭐ Star this repo if it helps your agents think better!**

> "Free super intelligence for every agent." - Agent Brain Bridge