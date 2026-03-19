#!/usr/bin/env python3
"""
REAL TOKEN TEST: Capture actual Hermes token usage from verbose output
"""

import subprocess
import os
import re
import json

def extract_tokens_from_output(output):
    """Extract token information from Hermes verbose output"""
    
    # Look for token patterns
    patterns = [
        r'Request size:.*?~([\d,]+) tokens',
        r'~([\d,]+) tokens',
        r'Tokens:\s*([\d,]+)',
        r'(\d+)\s*tokens'
    ]
    
    for pattern in patterns:
        match = re.search(pattern, output)
        if match:
            tokens = int(match.group(1).replace(',', ''))
            return tokens
    
    # Try to estimate from context limit info
    context_match = re.search(r'Context limit: ([\d,]+) tokens', output)
    if context_match:
        # This is just context limit, not actual usage
        return None
    
    return None

def test_config(config_name):
    """Test a specific config and measure tokens"""
    
    config_path = os.path.expanduser("~/.hermes/config.yaml")
    backup_path = os.path.expanduser("~/.hermes/config.yaml.backup")
    test_config_path = f"/home/leviathan/agent-brain-bridge/{config_name}"
    
    if not os.path.exists(test_config_path):
        return {"config": config_name, "error": "config not found"}
    
    # Backup and replace config
    subprocess.run(["cp", config_path, backup_path], capture_output=True)
    subprocess.run(["cp", test_config_path, config_path], capture_output=True)
    
    print(f"\n🔧 Testing: {config_name}")
    
    try:
        # Run Hermes with verbose output
        result = subprocess.run(
            ["hermes", "chat", "--query", "What tools do you have available?", "--verbose"],
            capture_output=True,
            text=True,
            timeout=60
        )
        
        output = result.stdout + result.stderr
        
        # Extract token information
        tokens = extract_tokens_from_output(output)
        
        if tokens:
            print(f"   ✅ Tokens used: {tokens:,}")
            
            # Also check tool count
            tool_lines = [line for line in output.split('\n') if 'tools' in line.lower()]
            if tool_lines:
                print(f"   🛠️  Tools mentioned: {len(tool_lines)}")
            
            return {
                "config": config_name,
                "tokens": tokens,
                "success": True,
                "output_length": len(output)
            }
        else:
            print(f"   ⚠️  Could not extract token count")
            # Show relevant lines for debugging
            token_lines = [line for line in output.split('\n') if 'token' in line.lower()]
            if token_lines:
                print(f"   📝 Token-related lines:")
                for line in token_lines[:3]:
                    print(f"      {line.strip()}")
            
            return {
                "config": config_name,
                "error": "no token data",
                "output": output[:500] + "..." if len(output) > 500 else output
            }
            
    except subprocess.TimeoutExpired:
        print(f"   ❌ Timeout after 60 seconds")
        return {"config": config_name, "error": "timeout"}
    finally:
        # Restore original config
        subprocess.run(["cp", backup_path, config_path], capture_output=True)

def main():
    print("=" * 70)
    print("🧪 REAL HERMES TOKEN MEASUREMENT TEST")
    print("=" * 70)
    
    # List of configs to test
    configs = [
        "config-efficient.yaml",    # Default "efficient" config
        "config-toolshed.yaml",     # Our Toolshed config
        "config-minimal.yaml",      # Minimal config
        "config-coding.yaml",       # Coding profile
    ]
    
    results = []
    
    for config in configs:
        result = test_config(config)
        results.append(result)
    
    print("\n" + "=" * 70)
    print("📊 REAL TEST RESULTS")
    print("=" * 70)
    
    # Filter successful results with token data
    successful = [r for r in results if r.get('tokens')]
    
    if len(successful) >= 2:
        # Sort by token count
        successful.sort(key=lambda x: x['tokens'])
        
        print("\n📈 TOKEN USAGE COMPARISON:")
        for i, result in enumerate(successful):
            print(f"{i+1}. {result['config']}: {result['tokens']:,} tokens")
        
        # Calculate savings
        if len(successful) >= 2:
            highest = successful[-1]['tokens']
            lowest = successful[0]['tokens']
            
            if highest > 0:
                savings_pct = ((highest - lowest) / highest) * 100
                savings_tokens = highest - lowest
                
                print(f"\n💡 TOKEN SAVINGS:")
                print(f"   Highest: {highest:,} tokens ({successful[-1]['config']})")
                print(f"   Lowest: {lowest:,} tokens ({successful[0]['config']})")
                print(f"   Savings: {savings_tokens:,} tokens ({savings_pct:.1f}% reduction)")
    
    # Show errors
    errors = [r for r in results if 'error' in r]
    if errors:
        print(f"\n⚠️  ERRORS ({len(errors)} configs):")
        for error in errors:
            print(f"   {error['config']}: {error['error']}")

if __name__ == "__main__":
    main()