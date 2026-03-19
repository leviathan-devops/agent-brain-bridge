#!/usr/bin/env python3
"""
ACTUAL TEST: Measure Hermes token usage with different configs
This runs real Hermes commands and measures token consumption
"""

import subprocess
import json
import os
import time
import re

def run_hermes_with_config(config_name, prompt="Hello, what tools do you have available?"):
    """Run Hermes with a specific config and measure token usage"""
    
    # Backup current config
    config_path = os.path.expanduser("~/.hermes/config.yaml")
    backup_path = os.path.expanduser("~/.hermes/config.yaml.backup")
    
    # Copy test config to main config
    test_config = f"/home/leviathan/agent-brain-bridge/{config_name}"
    if not os.path.exists(test_config):
        print(f"❌ Config not found: {test_config}")
        return None
    
    # Backup current config
    subprocess.run(["cp", config_path, backup_path], capture_output=True)
    
    # Copy test config
    subprocess.run(["cp", test_config, config_path], capture_output=True)
    
    print(f"\n🔧 Testing config: {config_name}")
    
    # Run Hermes with a simple prompt
    start_time = time.time()
    try:
        # Use timeout to prevent hanging
        result = subprocess.run(
            ["hermes", "chat", "--message", prompt],
            capture_output=True,
            text=True,
            timeout=30
        )
        elapsed = time.time() - start_time
        
        # Extract token information from output
        output = result.stdout + result.stderr
        
        # Look for token patterns in Hermes output
        tokens_used = None
        cost = None
        
        # Pattern 1: "Tokens: X" pattern
        token_match = re.search(r'Tokens:\s*(\d+)', output)
        if token_match:
            tokens_used = int(token_match.group(1))
        
        # Pattern 2: "Cost: $X" pattern  
        cost_match = re.search(r'Cost:\s*\$([\d\.]+)', output)
        if cost_match:
            cost = float(cost_match.group(1))
        
        # Pattern 3: "≈ X tokens" pattern
        approx_match = re.search(r'≈\s*(\d+)\s*tokens', output)
        if approx_match and not tokens_used:
            tokens_used = int(approx_match.group(1))
        
        print(f"   ⏱️  Time: {elapsed:.1f}s")
        print(f"   📤 Output length: {len(output)} chars")
        
        if tokens_used:
            print(f"   🪙 Tokens used: {tokens_used:,}")
            if cost:
                print(f"   💰 Cost: ${cost:.6f}")
        else:
            print(f"   ❓ Could not extract token count")
            # Try to estimate from output length
            estimated_tokens = len(output) // 4  # Rough estimate
            print(f"   📊 Estimated tokens: {estimated_tokens:,} (based on output length)")
        
        return {
            "config": config_name,
            "tokens": tokens_used,
            "cost": cost,
            "time": elapsed,
            "output_length": len(output),
            "success": result.returncode == 0
        }
        
    except subprocess.TimeoutExpired:
        print(f"   ⚠️  Timeout after 30 seconds")
        return {"config": config_name, "error": "timeout"}
    finally:
        # Restore original config
        subprocess.run(["cp", backup_path, config_path], capture_output=True)

def main():
    print("=" * 60)
    print("🧪 HERMES TOKEN USAGE TEST - REAL MEASUREMENTS")
    print("=" * 60)
    
    # Test different configs
    configs_to_test = [
        "config-efficient.yaml",  # Default "efficient" config
        "config-toolshed.yaml",   # Our Toolshed config
        "config-minimal.yaml",    # Minimal config
        "config-coding.yaml",     # Task-specific: coding
    ]
    
    results = []
    
    for config in configs_to_test:
        result = run_hermes_with_config(config)
        if result:
            results.append(result)
    
    print("\n" + "=" * 60)
    print("📊 TEST RESULTS SUMMARY")
    print("=" * 60)
    
    for result in results:
        if "error" in result:
            print(f"{result['config']}: ❌ {result['error']}")
        else:
            tokens = result.get('tokens', 'N/A')
            if tokens:
                print(f"{result['config']}: {tokens:,} tokens, {result['time']:.1f}s")
            else:
                print(f"{result['config']}: No token data, {result['output_length']} chars, {result['time']:.1f}s")
    
    # Calculate savings if we have data
    if len(results) >= 2 and results[0].get('tokens') and results[1].get('tokens'):
        default_tokens = results[0]['tokens']
        toolshed_tokens = results[1]['tokens']
        
        if default_tokens and toolshed_tokens:
            savings = ((default_tokens - toolshed_tokens) / default_tokens) * 100
            print(f"\n💡 TOKEN SAVINGS: {savings:.1f}% reduction")
            print(f"   Default: {default_tokens:,} tokens")
            print(f"   Toolshed: {toolshed_tokens:,} tokens")
            print(f"   Savings: {default_tokens - toolshed_tokens:,} tokens")

if __name__ == "__main__":
    main()