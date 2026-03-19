#!/usr/bin/env python3
"""
Basic Usage Examples for Agent Brain Bridge

This file shows how to use the DeepSeek brain bridge in different ways.
"""

import os
import sys
import subprocess

# Add parent directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

def example_direct_import():
    """Example 1: Direct import and usage."""
    print("=" * 60)
    print("Example 1: Direct Import")
    print("=" * 60)
    
    try:
        from deepseek_brain_bridge import DeepSeekBrainBridge
        
        # Initialize the bridge
        bridge = DeepSeekBrainBridge()
        
        # Check if authenticated
        if bridge.is_authenticated():
            print("✅ DeepSeek session is authenticated")
        else:
            print("⚠️  Not authenticated. Run authenticate_deepseek.py first")
            return
        
        # Think with DeepSeek
        response = bridge.think("What is artificial intelligence in simple terms?")
        print(f"\n🤔 Question: What is artificial intelligence in simple terms?")
        print(f"🧠 DeepSeek Response: {response[:200]}...")
        
    except ImportError as e:
        print(f"❌ Import error: {e}")
        print("Make sure you're in the agent-brain-bridge directory")

def example_cli_usage():
    """Example 2: CLI usage."""
    print("\n" + "=" * 60)
    print("Example 2: Command Line Interface")
    print("=" * 60)
    
    # Method 1: Using the brain-bridge command
    print("Method 1: brain-bridge command")
    print("  brain-bridge --think 'Explain quantum computing'")
    print("  brain-bridge --chat 'Hello, how are you?'")
    print("  brain-bridge --status")
    
    # Method 2: Direct Python script
    print("\nMethod 2: Direct Python script")
    print("  python3 deepseek_brain_bridge.py --think 'What is machine learning?'")
    print("  echo 'What is Python?' | python3 deepseek_brain_bridge.py --stdin")
    
    # Method 3: Batch processing
    print("\nMethod 3: Batch processing")
    print("  python3 -c \"")
    print("  from deepseek_brain_bridge import DeepSeekBrainBridge")
    print("  bridge = DeepSeekBrainBridge()")
    print("  print(bridge.think('Hello DeepSeek!'))")
    print("  \"")

def example_research_agent():
    """Example 3: Using Research Agent."""
    print("\n" + "=" * 60)
    print("Example 3: Research Agent")
    print("=" * 60)
    
    try:
        from research_agent import ResearchAgent
        
        # Initialize Research Agent with DeepSeek
        agent = ResearchAgent(use_deepseek=True)
        
        # Analyze some data
        print("Analyzing sample data with DeepSeek...")
        analysis = agent.analyze_data(
            "Twitter discussions about AI safety, GitHub repos for ML models, "
            "and research papers on transformer architectures",
            data_type="mixed"
        )
        
        print(f"\n📊 Analysis complete!")
        print(f"   Data type: {analysis['data_type']}")
        print(f"   Insights found: {len(analysis['insights'])}")
        print(f"   Recommendations: {len(analysis['recommendations'])}")
        
        # Show first insight
        if analysis['insights']:
            print(f"\n💡 First insight: {analysis['insights'][0]}")
        
    except ImportError as e:
        print(f"❌ Import error: {e}")

def example_slack_integration():
    """Example 4: Slack integration."""
    print("\n" + "=" * 60)
    print("Example 4: Slack Data Integration")
    print("=" * 60)
    
    print("Extracting and analyzing Slack data:")
    print("\n1. Extract data from Slack channel:")
    print("   python3 slack_data_extractor.py --channel ai-discussions --limit 50")
    
    print("\n2. Prepare for Research Agent:")
    print("   python3 slack_data_extractor.py --channel ai-discussions --prepare-for-agent")
    
    print("\n3. Analyze with Research Agent:")
    print("   python3 research_agent.py 'Analyze Slack data in slack_extracted_data.json'")
    
    print("\n4. Create training dataset:")
    print("   # After analysis, use Research Agent to create dataset")

def example_hermes_integration():
    """Example 5: Hermes agent integration."""
    print("\n" + "=" * 60)
    print("Example 5: Hermes Agent Integration")
    print("=" * 60)
    
    print("With Hermes configuration (~/.hermes/config-efficient.yaml):")
    print("\nIn Hermes, you can now use commands like:")
    print("  'Analyze this data using DeepSeek'")
    print("  'Think about this problem with DeepSeek'")
    print("  'Research this topic using the brain bridge'")
    print("  'Extract and analyze Slack data from #ai-discussions'")
    
    print("\nHermes will automatically:")
    print("  1. Use efficient configuration (70% fewer tokens)")
    print("  2. Access DeepSeek through the brain bridge")
    print("  3. Use Research Agent for complex analysis")
    print("  4. Create training datasets from analyzed data")

def example_troubleshooting():
    """Example 6: Troubleshooting common issues."""
    print("\n" + "=" * 60)
    print("Example 6: Troubleshooting")
    print("=" * 60)
    
    print("Common issues and solutions:")
    print("\n1. 'agent-browser not found':")
    print("   npm install -g @vercel-labs/agent-browser")
    
    print("\n2. 'DeepSeek authentication failed':")
    print("   python3 authenticate_deepseek.py")
    
    print("\n3. 'Session expired':")
    print("   rm -rf ~/.agent-browser/sessions/deepseek-agent")
    print("   python3 authenticate_deepseek.py")
    
    print("\n4. 'Hermes rate limiting':")
    print("   Use: hermes --config ~/.hermes/config-efficient.yaml")
    
    print("\n5. 'Python import errors':")
    print("   pip3 install -r requirements.txt")
    print("   Or: pip3 install requests beautifulsoup4")

def main():
    """Run all examples."""
    print("🧠 AGENT BRAIN BRIDGE - USAGE EXAMPLES")
    print("=" * 60)
    print()
    
    examples = [
        example_direct_import,
        example_cli_usage,
        example_research_agent,
        example_slack_integration,
        example_hermes_integration,
        example_troubleshooting
    ]
    
    for i, example in enumerate(examples, 1):
        try:
            example()
            print()
        except Exception as e:
            print(f"❌ Example {i} failed: {e}")
            print()
    
    print("=" * 60)
    print("🎯 QUICK START COMMANDS")
    print("=" * 60)
    print()
    print("1. Authenticate DeepSeek (one-time):")
    print("   python3 authenticate_deepseek.py")
    print()
    print("2. Test the brain bridge:")
    print("   python3 deepseek_brain_bridge.py --think 'Hello DeepSeek!'")
    print()
    print("3. Use Research Agent:")
    print("   python3 research_agent.py 'Analyze AI trends'")
    print()
    print("4. Extract Slack data:")
    print("   python3 slack_data_extractor.py --channel your-channel")
    print()
    print("5. Start Hermes with brain bridge:")
    print("   hermes --config ~/.hermes/config-efficient.yaml")
    print()
    print("📚 For more details, see README.md")
    print("🐛 Report issues: https://github.com/leviathan-devops/agent-brain-bridge/issues")

if __name__ == "__main__":
    main()