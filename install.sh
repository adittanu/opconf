#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
CONFIG_FILE="$CONFIG_DIR/opencode.json"
KEY_FILE="$CONFIG_DIR/kreat.key"

mkdir -p "$CONFIG_DIR"

if [[ -n "${KREAT_API_KEY:-}" ]]; then
    printf '%s' "$KREAT_API_KEY" > "$KEY_FILE"
elif [[ -f "$KEY_FILE" ]]; then
    echo "Memakai API key yang sudah ada: $KEY_FILE"
else
    if [[ ! -r /dev/tty ]]; then
        echo "KREAT_API_KEY belum diset dan tidak ada TTY untuk prompt." >&2
        exit 1
    fi
    read -r -s -p "Kreat API key: " api_key < /dev/tty
    printf '\n'
    [[ -n "$api_key" ]] || { echo "API key kosong." >&2; exit 1; }
    printf '%s' "$api_key" > "$KEY_FILE"
fi
chmod 600 "$KEY_FILE"

if [[ -f "$CONFIG_FILE" ]]; then
    backup="$CONFIG_FILE.bak-$(date +%Y%m%d-%H%M%S)"
    cp "$CONFIG_FILE" "$backup"
    echo "Backup config lama: $backup"
fi

if [[ -f "$CONFIG_FILE" ]] && command -v jq >/dev/null 2>&1 && jq -e . "$CONFIG_FILE" >/dev/null 2>&1; then
    tmp="$(mktemp)"
    cat > "$tmp" <<'OPENCODE_CONFIG'
{
  "$schema": "https://opencode.ai/config.json",
  "providers": {
    "kreat": {
      "name": "Kreat (9r)",
      "package": "@opencode/ai/providers/openai-compatible",
      "settings": {
        "baseURL": "https://9r.kreat.id/v1",
        "apiKey": "{file:./kreat.key}"
      },
      "models": {
        "ag/claude-opus-4-6-thinking": {"name":"Claude Opus 4.6 Thinking (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":200000,"output":64000}},
        "ag/claude-opus-5-5": {"name":"Claude Opus 5.5 (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "ag/claude-opus-5-5-high": {"name":"Claude Opus 5.5 High (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "ag/claude-opus-5-5-low": {"name":"Claude Opus 5.5 Low (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "ag/claude-opus-5-5-medium": {"name":"Claude Opus 5.5 Medium (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "ag/claude-sonnet-4-6": {"name":"Claude Sonnet 4.6 (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1000000,"output":128000}},
        "ag/claude-sonnet-5-5": {"name":"Claude Sonnet 5.5 (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1000000,"output":128000}},
        "ag/claude-sonnet-5-5-high": {"name":"Claude Sonnet 5.5 High (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1000000,"output":128000}},
        "ag/claude-sonnet-5-5-low": {"name":"Claude Sonnet 5.5 Low (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1000000,"output":128000}},
        "ag/claude-sonnet-5-5-medium": {"name":"Claude Sonnet 5.5 Medium (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1000000,"output":128000}},
        "ag/gemini-3.1-pro-high": {"name":"Gemini 3.1 Pro High (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65535}},
        "ag/gemini-3.1-pro-low": {"name":"Gemini 3.1 Pro Low (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65535}},
        "ag/gemini-3.6-flash-high": {"name":"Gemini 3.6 Flash High (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-3.6-flash-low": {"name":"Gemini 3.6 Flash Low (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-3.6-flash-medium": {"name":"Gemini 3.6 Flash Medium (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-3.7-flash-high": {"name":"Gemini 3.7 Flash High (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-3.7-flash-low": {"name":"Gemini 3.7 Flash Low (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-3.7-flash-medium": {"name":"Gemini 3.7 Flash Medium (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-3.8-flash": {"name":"Gemini 3.8 Flash (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-3.8-flash-high": {"name":"Gemini 3.8 Flash High (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-3.8-flash-low": {"name":"Gemini 3.8 Flash Low (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-3.8-flash-medium": {"name":"Gemini 3.8 Flash Medium (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-4-argon-high": {"name":"Gemini 4 Argon High (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-pro-agent": {"name":"Gemini Pro Agent (ag)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false,"toggle":true}},"limit":{"context":1048576,"output":64000}},
        "ag/gpt-oss-120b-medium": {"name":"GPT OSS 120b Medium (ag)","capabilities":{"tools":true,"input":["text"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":128000,"output":64000}},
        "cu/composer-2.5": {"name":"Composer 2.5 (cu)","capabilities":{"tools":true,"input":["text"],"output":["text"],"reasoning":{"supported":false,"toggle":true}},"limit":{"context":200000,"output":64000}},
        "cu/cursor-grok-4.5-medium": {"name":"Cursor Grok 4.5 Medium (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":500000,"output":64000}},
        "cu/cursor-grok-4.6-medium": {"name":"Cursor Grok 4.6 Medium (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":500000,"output":500000}},
        "cu/grok-4.7-high": {"name":"Grok 4.7 High (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":256000,"output":64000}},
        "cu/grok-4.7-high-fast": {"name":"Grok 4.7 High Fast (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":256000,"output":64000}},
        "cu/grok-4.7-low": {"name":"Grok 4.7 Low (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":256000,"output":64000}},
        "cu/grok-4.7-low-fast": {"name":"Grok 4.7 Low Fast (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":256000,"output":64000}},
        "cu/grok-4.7-medium": {"name":"Grok 4.7 Medium (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":256000,"output":64000}},
        "cu/grok-4.7-medium-fast": {"name":"Grok 4.7 Medium Fast (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":256000,"output":64000}},
        "cu/grok-4.7-xhigh": {"name":"Grok 4.7 Xhigh (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":256000,"output":64000}},
        "cu/grok-4.7-xhigh-fast": {"name":"Grok 4.7 Xhigh Fast (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":256000,"output":64000}},
        "cx/codex-auto-review": {"name":"Codex Auto Review (cx)","capabilities":{"tools":true,"input":["text"],"output":["text"],"reasoning":{"supported":false,"toggle":true}},"limit":{"context":200000,"output":64000}},
        "cx/gpt-5.6-luna": {"name":"GPT 5.6 Luna (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":272000,"output":128000}},
        "cx/gpt-5.6-luna-review": {"name":"GPT 5.6 Luna Review (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":272000,"output":128000}},
        "cx/gpt-5.6-luna[1m]": {"name":"GPT 5.6 Luna[1m] (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":872000,"output":128000}},
        "cx/gpt-5.6-sol": {"name":"GPT 5.6 Sol (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":372000,"output":128000}},
        "cx/gpt-5.6-sol-review": {"name":"GPT 5.6 Sol Review (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":372000,"output":128000}},
        "cx/gpt-5.6-sol[1m]": {"name":"GPT 5.6 Sol[1m] (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":872000,"output":128000}},
        "cx/gpt-5.6-terra": {"name":"GPT 5.6 Terra (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":272000,"output":128000}},
        "cx/gpt-5.6-terra-review": {"name":"GPT 5.6 Terra Review (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":272000,"output":128000}},
        "cx/gpt-5.6-terra[1m]": {"name":"GPT 5.6 Terra[1m] (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":872000,"output":128000}},
        "cx/gpt-6-astra": {"name":"GPT 6 Astra (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":272000,"output":128000}},
        "cx/gpt-6-astra[1m]": {"name":"GPT 6 Astra[1m] (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":872000,"output":128000}},
        "cx/gpt-6-luna": {"name":"GPT 6 Luna (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":272000,"output":128000}},
        "cx/gpt-6-luna[1m]": {"name":"GPT 6 Luna[1m] (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":872000,"output":128000}},
        "cx/gpt-6-sol": {"name":"GPT 6 Sol (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":272000,"output":128000}},
        "cx/gpt-6-sol[1m]": {"name":"GPT 6 Sol[1m] (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":872000,"output":128000}},
        "cx/gpt-6.1-sol": {"name":"GPT 6.1 Sol (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1050000,"output":128000}},
        "cx/gpt-daybreak-blue-latest": {"name":"GPT Daybreak Blue Latest (cx)","capabilities":{"tools":true,"input":["text"],"output":["text"],"reasoning":{"supported":false,"toggle":true}},"limit":{"context":200000,"output":64000}},
        "cx/gpt-reserve": {"name":"GPT Reserve (cx)","capabilities":{"tools":true,"input":["text"],"output":["text"],"reasoning":{"supported":false,"toggle":true}},"limit":{"context":200000,"output":64000}},
        "kr/auto": {"name":"Auto (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":64000}},
        "kr/auto-thinking": {"name":"Auto Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-haiku-4.5-agentic": {"name":"Claude Haiku 4.5 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":64000}},
        "kr/claude-haiku-4.5-thinking": {"name":"Claude Haiku 4.5 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-haiku-4.5-thinking-agentic": {"name":"Claude Haiku 4.5 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.5": {"name":"Claude Opus 4.5 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.5-agentic": {"name":"Claude Opus 4.5 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.5-thinking": {"name":"Claude Opus 4.5 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.5-thinking-agentic": {"name":"Claude Opus 4.5 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.6": {"name":"Claude Opus 4.6 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-4.6-agentic": {"name":"Claude Opus 4.6 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.6-thinking": {"name":"Claude Opus 4.6 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.6-thinking-agentic": {"name":"Claude Opus 4.6 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.7": {"name":"Claude Opus 4.7 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-4.7-agentic": {"name":"Claude Opus 4.7 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.7-thinking": {"name":"Claude Opus 4.7 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.7-thinking-agentic": {"name":"Claude Opus 4.7 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.8": {"name":"Claude Opus 4.8 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-4.8-agentic": {"name":"Claude Opus 4.8 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.8-thinking": {"name":"Claude Opus 4.8 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-4.8-thinking-agentic": {"name":"Claude Opus 4.8 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-5": {"name":"Claude Opus 5 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-5-agentic": {"name":"Claude Opus 5 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-5-thinking": {"name":"Claude Opus 5 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-5-thinking-agentic": {"name":"Claude Opus 5 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-5.5": {"name":"Claude Opus 5.5 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-5.5-agentic": {"name":"Claude Opus 5.5 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-5.5-thinking": {"name":"Claude Opus 5.5 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-5.5-thinking-agentic": {"name":"Claude Opus 5.5 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-sonnet-4.5-agentic": {"name":"Claude Sonnet 4.5 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":64000}},
        "kr/claude-sonnet-4.5-thinking": {"name":"Claude Sonnet 4.5 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-sonnet-4.5-thinking-agentic": {"name":"Claude Sonnet 4.5 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-sonnet-4.6": {"name":"Claude Sonnet 4.6 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-sonnet-4.6-agentic": {"name":"Claude Sonnet 4.6 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":64000}},
        "kr/claude-sonnet-4.6-thinking": {"name":"Claude Sonnet 4.6 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-sonnet-4.6-thinking-agentic": {"name":"Claude Sonnet 4.6 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-sonnet-5": {"name":"Claude Sonnet 5 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-sonnet-5-agentic": {"name":"Claude Sonnet 5 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-sonnet-5-thinking": {"name":"Claude Sonnet 5 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-sonnet-5-thinking-agentic": {"name":"Claude Sonnet 5 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-sonnet-5.5": {"name":"Claude Sonnet 5.5 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-sonnet-5.5-agentic": {"name":"Claude Sonnet 5.5 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-sonnet-5.5-thinking": {"name":"Claude Sonnet 5.5 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-sonnet-5.5-thinking-agentic": {"name":"Claude Sonnet 5.5 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "kr/deepseek-3.2-agentic": {"name":"Deepseek 3.2 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":128000,"output":64000}},
        "kr/deepseek-3.2-thinking": {"name":"Deepseek 3.2 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":128000,"output":64000}},
        "kr/deepseek-3.2-thinking-agentic": {"name":"Deepseek 3.2 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":128000,"output":64000}},
        "kr/glm-5-agentic": {"name":"GLM 5 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":128000}},
        "kr/glm-5-thinking": {"name":"GLM 5 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":128000}},
        "kr/glm-5-thinking-agentic": {"name":"GLM 5 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":128000}},
        "kr/gpt-5.6-luna": {"name":"GPT 5.6 Luna (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-luna-agentic": {"name":"GPT 5.6 Luna Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-luna-thinking": {"name":"GPT 5.6 Luna Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-luna-thinking-agentic": {"name":"GPT 5.6 Luna Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-sol": {"name":"GPT 5.6 Sol (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-sol-agentic": {"name":"GPT 5.6 Sol Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-sol-thinking": {"name":"GPT 5.6 Sol Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-sol-thinking-agentic": {"name":"GPT 5.6 Sol Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-terra": {"name":"GPT 5.6 Terra (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-terra-agentic": {"name":"GPT 5.6 Terra Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-terra-thinking": {"name":"GPT 5.6 Terra Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-terra-thinking-agentic": {"name":"GPT 5.6 Terra Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":272000,"output":128000}},
        "kr/kimi-k3": {"name":"Kimi K3 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1048576,"output":131072}},
        "kr/kimi-k3-agentic": {"name":"Kimi K3 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1048576,"output":131072}},
        "kr/kimi-k3-thinking": {"name":"Kimi K3 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}},
        "kr/kimi-k3-thinking-agentic": {"name":"Kimi K3 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}},
        "kr/minimax-m2.1": {"name":"Minimax M2.1 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":131072}},
        "kr/minimax-m2.1-agentic": {"name":"Minimax M2.1 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":131072}},
        "kr/minimax-m2.1-thinking": {"name":"Minimax M2.1 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":131072}},
        "kr/minimax-m2.1-thinking-agentic": {"name":"Minimax M2.1 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":131072}},
        "kr/minimax-m2.5": {"name":"Minimax M2.5 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":204800,"output":131072}},
        "kr/minimax-m2.5-agentic": {"name":"Minimax M2.5 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":204800,"output":131072}},
        "kr/minimax-m2.5-thinking": {"name":"Minimax M2.5 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":204800,"output":131072}},
        "kr/minimax-m2.5-thinking-agentic": {"name":"Minimax M2.5 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":204800,"output":131072}},
        "kr/qwen3-coder-next-agentic": {"name":"Qwen3 Coder Next Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":64000}},
        "kr/qwen3-coder-next-thinking": {"name":"Qwen3 Coder Next Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":64000}},
        "kr/qwen3-coder-next-thinking-agentic": {"name":"Qwen3 Coder Next Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":64000}},
        "mimo": {"name":"Mimo","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":262144,"output":131072}},
        "mmf/mimo-auto": {"name":"Mimo Auto (mmf)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":262144,"output":131072}},
        "oc/big-pickle": {"name":"Big Pickle (oc)","capabilities":{"tools":true,"input":["text"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":200000,"output":32000}},
        "oc/deepseek-v4-flash-free": {"name":"Deepseek v4 Flash Free (oc)","capabilities":{"tools":true,"input":["text"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1000000,"output":384000}},
        "oc/jev-1.13-free": {"name":"Jev 1.13 Free (oc)","capabilities":{"tools":true,"input":["text"],"output":["text"],"reasoning":{"supported":false,"toggle":true}},"limit":{"context":200000,"output":64000}},
        "oc/mimo-v2.5-free": {"name":"Mimo v2.5 Free (oc)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}},
        "oc/muse-spark-1.2-contributor-free": {"name":"Muse Spark 1.2 Contributor Free (oc)","capabilities":{"tools":true,"input":["text","image","audio","video","pdf"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1048576,"output":131072}},
        "oc/muse-spark-1.3-contributor-free": {"name":"Muse Spark 1.3 Contributor Free (oc)","capabilities":{"tools":true,"input":["text","image","audio","video","pdf"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1048576,"output":131072}},
        "oc/north-mini-code-free": {"name":"North Mini Code Free (oc)","capabilities":{"tools":true,"input":["text"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":256000,"output":64000}},
        "oc/union-alpha": {"name":"Union Alpha (oc)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false,"toggle":true}},"limit":{"context":262144,"output":131072}},
        "oc/x-preview-f-free": {"name":"X Preview F Free (oc)","capabilities":{"tools":true,"input":["text","image","video"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1000000,"output":131072}},
        "xmtp/mimo-v2-omni": {"name":"Mimo v2 Omni (xmtp)","capabilities":{"tools":true,"input":["text","image","audio"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":262144,"output":131072}},
        "xmtp/mimo-v2-pro": {"name":"Mimo v2 Pro (xmtp)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":262144,"output":131072}},
        "xmtp/mimo-v2-tts": {"name":"Mimo v2 TTS (xmtp)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":262144,"output":131072}},
        "xmtp/mimo-v2.5": {"name":"Mimo v2.5 (xmtp)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}},
        "xmtp/mimo-v2.5-pro": {"name":"Mimo v2.5 Pro (xmtp)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}},
        "xmtp/mimo-v2.5-pro-claude": {"name":"Mimo v2.5 Pro Claude (xmtp)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":200000,"output":64000}},
        "xmtp/mimo-v2.5-tts": {"name":"Mimo v2.5 TTS (xmtp)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}},
        "xmtp/mimo-v2.5-tts-voiceclone": {"name":"Mimo v2.5 TTS Voiceclone (xmtp)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}},
        "xmtp/mimo-v2.5-tts-voicedesign": {"name":"Mimo v2.5 TTS Voicedesign (xmtp)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}},
        "xmtp/mimo-v2.6-flash": {"name":"Mimo v2.6 Flash (xmtp)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}},
        "xmtp/mimo-v2.6-pro": {"name":"Mimo v2.6 Pro (xmtp)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}}
      }
    }
  }
}
OPENCODE_CONFIG
    jq --slurpfile bundle "$tmp" \
        '.providers = ((.providers // {}) + ($bundle[0].providers // {}))' \
        "$CONFIG_FILE" > "$tmp.merged"
    install -m 600 "$tmp.merged" "$CONFIG_FILE"
    rm -f "$tmp" "$tmp.merged"
    echo "Provider kreat digabung ke config yang sudah ada."
else
    cat > "$CONFIG_FILE" <<'OPENCODE_CONFIG'
{
  "$schema": "https://opencode.ai/config.json",
  "providers": {
    "kreat": {
      "name": "Kreat (9r)",
      "package": "@opencode/ai/providers/openai-compatible",
      "settings": {
        "baseURL": "https://9r.kreat.id/v1",
        "apiKey": "{file:./kreat.key}"
      },
      "models": {
        "ag/claude-opus-4-6-thinking": {"name":"Claude Opus 4.6 Thinking (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":200000,"output":64000}},
        "ag/claude-opus-5-5": {"name":"Claude Opus 5.5 (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "ag/claude-opus-5-5-high": {"name":"Claude Opus 5.5 High (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "ag/claude-opus-5-5-low": {"name":"Claude Opus 5.5 Low (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "ag/claude-opus-5-5-medium": {"name":"Claude Opus 5.5 Medium (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "ag/claude-sonnet-4-6": {"name":"Claude Sonnet 4.6 (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1000000,"output":128000}},
        "ag/claude-sonnet-5-5": {"name":"Claude Sonnet 5.5 (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1000000,"output":128000}},
        "ag/claude-sonnet-5-5-high": {"name":"Claude Sonnet 5.5 High (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1000000,"output":128000}},
        "ag/claude-sonnet-5-5-low": {"name":"Claude Sonnet 5.5 Low (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1000000,"output":128000}},
        "ag/claude-sonnet-5-5-medium": {"name":"Claude Sonnet 5.5 Medium (ag)","capabilities":{"tools":true,"input":["text","image","pdf"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1000000,"output":128000}},
        "ag/gemini-3.1-pro-high": {"name":"Gemini 3.1 Pro High (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65535}},
        "ag/gemini-3.1-pro-low": {"name":"Gemini 3.1 Pro Low (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65535}},
        "ag/gemini-3.6-flash-high": {"name":"Gemini 3.6 Flash High (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-3.6-flash-low": {"name":"Gemini 3.6 Flash Low (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-3.6-flash-medium": {"name":"Gemini 3.6 Flash Medium (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-3.7-flash-high": {"name":"Gemini 3.7 Flash High (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-3.7-flash-low": {"name":"Gemini 3.7 Flash Low (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-3.7-flash-medium": {"name":"Gemini 3.7 Flash Medium (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-3.8-flash": {"name":"Gemini 3.8 Flash (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-3.8-flash-high": {"name":"Gemini 3.8 Flash High (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-3.8-flash-low": {"name":"Gemini 3.8 Flash Low (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-3.8-flash-medium": {"name":"Gemini 3.8 Flash Medium (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-4-argon-high": {"name":"Gemini 4 Argon High (ag)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":65536}},
        "ag/gemini-pro-agent": {"name":"Gemini Pro Agent (ag)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false,"toggle":true}},"limit":{"context":1048576,"output":64000}},
        "ag/gpt-oss-120b-medium": {"name":"GPT OSS 120b Medium (ag)","capabilities":{"tools":true,"input":["text"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":128000,"output":64000}},
        "cu/composer-2.5": {"name":"Composer 2.5 (cu)","capabilities":{"tools":true,"input":["text"],"output":["text"],"reasoning":{"supported":false,"toggle":true}},"limit":{"context":200000,"output":64000}},
        "cu/cursor-grok-4.5-medium": {"name":"Cursor Grok 4.5 Medium (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":500000,"output":64000}},
        "cu/cursor-grok-4.6-medium": {"name":"Cursor Grok 4.6 Medium (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":500000,"output":500000}},
        "cu/grok-4.7-high": {"name":"Grok 4.7 High (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":256000,"output":64000}},
        "cu/grok-4.7-high-fast": {"name":"Grok 4.7 High Fast (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":256000,"output":64000}},
        "cu/grok-4.7-low": {"name":"Grok 4.7 Low (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":256000,"output":64000}},
        "cu/grok-4.7-low-fast": {"name":"Grok 4.7 Low Fast (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":256000,"output":64000}},
        "cu/grok-4.7-medium": {"name":"Grok 4.7 Medium (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":256000,"output":64000}},
        "cu/grok-4.7-medium-fast": {"name":"Grok 4.7 Medium Fast (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":256000,"output":64000}},
        "cu/grok-4.7-xhigh": {"name":"Grok 4.7 Xhigh (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":256000,"output":64000}},
        "cu/grok-4.7-xhigh-fast": {"name":"Grok 4.7 Xhigh Fast (cu)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":256000,"output":64000}},
        "cx/codex-auto-review": {"name":"Codex Auto Review (cx)","capabilities":{"tools":true,"input":["text"],"output":["text"],"reasoning":{"supported":false,"toggle":true}},"limit":{"context":200000,"output":64000}},
        "cx/gpt-5.6-luna": {"name":"GPT 5.6 Luna (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":272000,"output":128000}},
        "cx/gpt-5.6-luna-review": {"name":"GPT 5.6 Luna Review (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":272000,"output":128000}},
        "cx/gpt-5.6-luna[1m]": {"name":"GPT 5.6 Luna[1m] (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":872000,"output":128000}},
        "cx/gpt-5.6-sol": {"name":"GPT 5.6 Sol (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":372000,"output":128000}},
        "cx/gpt-5.6-sol-review": {"name":"GPT 5.6 Sol Review (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":372000,"output":128000}},
        "cx/gpt-5.6-sol[1m]": {"name":"GPT 5.6 Sol[1m] (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":872000,"output":128000}},
        "cx/gpt-5.6-terra": {"name":"GPT 5.6 Terra (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":272000,"output":128000}},
        "cx/gpt-5.6-terra-review": {"name":"GPT 5.6 Terra Review (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":272000,"output":128000}},
        "cx/gpt-5.6-terra[1m]": {"name":"GPT 5.6 Terra[1m] (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":872000,"output":128000}},
        "cx/gpt-6-astra": {"name":"GPT 6 Astra (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":272000,"output":128000}},
        "cx/gpt-6-astra[1m]": {"name":"GPT 6 Astra[1m] (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":872000,"output":128000}},
        "cx/gpt-6-luna": {"name":"GPT 6 Luna (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":272000,"output":128000}},
        "cx/gpt-6-luna[1m]": {"name":"GPT 6 Luna[1m] (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":872000,"output":128000}},
        "cx/gpt-6-sol": {"name":"GPT 6 Sol (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":272000,"output":128000}},
        "cx/gpt-6-sol[1m]": {"name":"GPT 6 Sol[1m] (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":872000,"output":128000}},
        "cx/gpt-6.1-sol": {"name":"GPT 6.1 Sol (cx)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1050000,"output":128000}},
        "cx/gpt-daybreak-blue-latest": {"name":"GPT Daybreak Blue Latest (cx)","capabilities":{"tools":true,"input":["text"],"output":["text"],"reasoning":{"supported":false,"toggle":true}},"limit":{"context":200000,"output":64000}},
        "cx/gpt-reserve": {"name":"GPT Reserve (cx)","capabilities":{"tools":true,"input":["text"],"output":["text"],"reasoning":{"supported":false,"toggle":true}},"limit":{"context":200000,"output":64000}},
        "kr/auto": {"name":"Auto (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":64000}},
        "kr/auto-thinking": {"name":"Auto Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-haiku-4.5-agentic": {"name":"Claude Haiku 4.5 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":64000}},
        "kr/claude-haiku-4.5-thinking": {"name":"Claude Haiku 4.5 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-haiku-4.5-thinking-agentic": {"name":"Claude Haiku 4.5 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.5": {"name":"Claude Opus 4.5 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.5-agentic": {"name":"Claude Opus 4.5 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.5-thinking": {"name":"Claude Opus 4.5 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.5-thinking-agentic": {"name":"Claude Opus 4.5 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.6": {"name":"Claude Opus 4.6 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-4.6-agentic": {"name":"Claude Opus 4.6 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.6-thinking": {"name":"Claude Opus 4.6 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.6-thinking-agentic": {"name":"Claude Opus 4.6 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.7": {"name":"Claude Opus 4.7 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-4.7-agentic": {"name":"Claude Opus 4.7 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.7-thinking": {"name":"Claude Opus 4.7 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.7-thinking-agentic": {"name":"Claude Opus 4.7 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.8": {"name":"Claude Opus 4.8 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-4.8-agentic": {"name":"Claude Opus 4.8 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-4.8-thinking": {"name":"Claude Opus 4.8 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-4.8-thinking-agentic": {"name":"Claude Opus 4.8 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-opus-5": {"name":"Claude Opus 5 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-5-agentic": {"name":"Claude Opus 5 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-5-thinking": {"name":"Claude Opus 5 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-5-thinking-agentic": {"name":"Claude Opus 5 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-5.5": {"name":"Claude Opus 5.5 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-5.5-agentic": {"name":"Claude Opus 5.5 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-5.5-thinking": {"name":"Claude Opus 5.5 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-opus-5.5-thinking-agentic": {"name":"Claude Opus 5.5 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-sonnet-4.5-agentic": {"name":"Claude Sonnet 4.5 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":64000}},
        "kr/claude-sonnet-4.5-thinking": {"name":"Claude Sonnet 4.5 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-sonnet-4.5-thinking-agentic": {"name":"Claude Sonnet 4.5 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-sonnet-4.6": {"name":"Claude Sonnet 4.6 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-sonnet-4.6-agentic": {"name":"Claude Sonnet 4.6 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":64000}},
        "kr/claude-sonnet-4.6-thinking": {"name":"Claude Sonnet 4.6 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-sonnet-4.6-thinking-agentic": {"name":"Claude Sonnet 4.6 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":64000}},
        "kr/claude-sonnet-5": {"name":"Claude Sonnet 5 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-sonnet-5-agentic": {"name":"Claude Sonnet 5 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-sonnet-5-thinking": {"name":"Claude Sonnet 5 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-sonnet-5-thinking-agentic": {"name":"Claude Sonnet 5 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-sonnet-5.5": {"name":"Claude Sonnet 5.5 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-sonnet-5.5-agentic": {"name":"Claude Sonnet 5.5 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-sonnet-5.5-thinking": {"name":"Claude Sonnet 5.5 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "kr/claude-sonnet-5.5-thinking-agentic": {"name":"Claude Sonnet 5.5 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":128000}},
        "kr/deepseek-3.2-agentic": {"name":"Deepseek 3.2 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":128000,"output":64000}},
        "kr/deepseek-3.2-thinking": {"name":"Deepseek 3.2 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":128000,"output":64000}},
        "kr/deepseek-3.2-thinking-agentic": {"name":"Deepseek 3.2 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":128000,"output":64000}},
        "kr/glm-5-agentic": {"name":"GLM 5 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":128000}},
        "kr/glm-5-thinking": {"name":"GLM 5 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":128000}},
        "kr/glm-5-thinking-agentic": {"name":"GLM 5 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":128000}},
        "kr/gpt-5.6-luna": {"name":"GPT 5.6 Luna (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-luna-agentic": {"name":"GPT 5.6 Luna Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-luna-thinking": {"name":"GPT 5.6 Luna Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-luna-thinking-agentic": {"name":"GPT 5.6 Luna Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-sol": {"name":"GPT 5.6 Sol (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-sol-agentic": {"name":"GPT 5.6 Sol Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-sol-thinking": {"name":"GPT 5.6 Sol Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-sol-thinking-agentic": {"name":"GPT 5.6 Sol Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-terra": {"name":"GPT 5.6 Terra (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-terra-agentic": {"name":"GPT 5.6 Terra Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-terra-thinking": {"name":"GPT 5.6 Terra Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":272000,"output":128000}},
        "kr/gpt-5.6-terra-thinking-agentic": {"name":"GPT 5.6 Terra Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":272000,"output":128000}},
        "kr/kimi-k3": {"name":"Kimi K3 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1048576,"output":131072}},
        "kr/kimi-k3-agentic": {"name":"Kimi K3 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1048576,"output":131072}},
        "kr/kimi-k3-thinking": {"name":"Kimi K3 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}},
        "kr/kimi-k3-thinking-agentic": {"name":"Kimi K3 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}},
        "kr/minimax-m2.1": {"name":"Minimax M2.1 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":131072}},
        "kr/minimax-m2.1-agentic": {"name":"Minimax M2.1 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":200000,"output":131072}},
        "kr/minimax-m2.1-thinking": {"name":"Minimax M2.1 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":131072}},
        "kr/minimax-m2.1-thinking-agentic": {"name":"Minimax M2.1 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":200000,"output":131072}},
        "kr/minimax-m2.5": {"name":"Minimax M2.5 (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":204800,"output":131072}},
        "kr/minimax-m2.5-agentic": {"name":"Minimax M2.5 Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":204800,"output":131072}},
        "kr/minimax-m2.5-thinking": {"name":"Minimax M2.5 Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":204800,"output":131072}},
        "kr/minimax-m2.5-thinking-agentic": {"name":"Minimax M2.5 Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":204800,"output":131072}},
        "kr/qwen3-coder-next-agentic": {"name":"Qwen3 Coder Next Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false}},"limit":{"context":1000000,"output":64000}},
        "kr/qwen3-coder-next-thinking": {"name":"Qwen3 Coder Next Thinking (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":64000}},
        "kr/qwen3-coder-next-thinking-agentic": {"name":"Qwen3 Coder Next Thinking Agentic (kr)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1000000,"output":64000}},
        "mimo": {"name":"Mimo","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":262144,"output":131072}},
        "mmf/mimo-auto": {"name":"Mimo Auto (mmf)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":262144,"output":131072}},
        "oc/big-pickle": {"name":"Big Pickle (oc)","capabilities":{"tools":true,"input":["text"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":200000,"output":32000}},
        "oc/deepseek-v4-flash-free": {"name":"Deepseek v4 Flash Free (oc)","capabilities":{"tools":true,"input":["text"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1000000,"output":384000}},
        "oc/jev-1.13-free": {"name":"Jev 1.13 Free (oc)","capabilities":{"tools":true,"input":["text"],"output":["text"],"reasoning":{"supported":false,"toggle":true}},"limit":{"context":200000,"output":64000}},
        "oc/mimo-v2.5-free": {"name":"Mimo v2.5 Free (oc)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}},
        "oc/muse-spark-1.2-contributor-free": {"name":"Muse Spark 1.2 Contributor Free (oc)","capabilities":{"tools":true,"input":["text","image","audio","video","pdf"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1048576,"output":131072}},
        "oc/muse-spark-1.3-contributor-free": {"name":"Muse Spark 1.3 Contributor Free (oc)","capabilities":{"tools":true,"input":["text","image","audio","video","pdf"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1048576,"output":131072}},
        "oc/north-mini-code-free": {"name":"North Mini Code Free (oc)","capabilities":{"tools":true,"input":["text"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":256000,"output":64000}},
        "oc/union-alpha": {"name":"Union Alpha (oc)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":false,"toggle":true}},"limit":{"context":262144,"output":131072}},
        "oc/x-preview-f-free": {"name":"X Preview F Free (oc)","capabilities":{"tools":true,"input":["text","image","video"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":1000000,"output":131072}},
        "xmtp/mimo-v2-omni": {"name":"Mimo v2 Omni (xmtp)","capabilities":{"tools":true,"input":["text","image","audio"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":262144,"output":131072}},
        "xmtp/mimo-v2-pro": {"name":"Mimo v2 Pro (xmtp)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":262144,"output":131072}},
        "xmtp/mimo-v2-tts": {"name":"Mimo v2 TTS (xmtp)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":262144,"output":131072}},
        "xmtp/mimo-v2.5": {"name":"Mimo v2.5 (xmtp)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}},
        "xmtp/mimo-v2.5-pro": {"name":"Mimo v2.5 Pro (xmtp)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}},
        "xmtp/mimo-v2.5-pro-claude": {"name":"Mimo v2.5 Pro Claude (xmtp)","capabilities":{"tools":true,"input":["text","image"],"output":["text"],"reasoning":{"supported":true,"toggle":true}},"limit":{"context":200000,"output":64000}},
        "xmtp/mimo-v2.5-tts": {"name":"Mimo v2.5 TTS (xmtp)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}},
        "xmtp/mimo-v2.5-tts-voiceclone": {"name":"Mimo v2.5 TTS Voiceclone (xmtp)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}},
        "xmtp/mimo-v2.5-tts-voicedesign": {"name":"Mimo v2.5 TTS Voicedesign (xmtp)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}},
        "xmtp/mimo-v2.6-flash": {"name":"Mimo v2.6 Flash (xmtp)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}},
        "xmtp/mimo-v2.6-pro": {"name":"Mimo v2.6 Pro (xmtp)","capabilities":{"tools":true,"input":["text","image","audio","video"],"output":["text"],"reasoning":{"supported":true}},"limit":{"context":1048576,"output":131072}}
      }
    }
  }
}
OPENCODE_CONFIG
    chmod 600 "$CONFIG_FILE"
    echo "Config kreat dipasang."
fi

echo
echo "Config : $CONFIG_FILE"
echo "API key: $KEY_FILE"
echo

if command -v opencode >/dev/null 2>&1; then
    count="$(opencode models --standalone 2>/dev/null | grep -c '^kreat/' || true)"
    echo "Model kreat terdeteksi: ${count:-0}"
    echo "Tes: opencode run --model kreat/kr/auto \"Reply with exactly: OK\""
else
    echo "opencode belum terpasang. Install dulu, lalu jalankan ulang script ini."
fi
