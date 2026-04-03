#!/bin/bash

# ==========================================================
# Script: Open Source Manifesto Generator
# Name: Saksham Salvi
#
# This script asks a few simple questions and creates
# a personal open-source manifesto based on your answers.
# ==========================================================

echo "=============================================================="
echo "            OPEN SOURCE MANIFESTO GENERATOR                  "
echo "=============================================================="
echo ""
echo "Let's create your own open-source manifesto."
echo "Just answer a few simple questions honestly."
echo ""

# -------- User Input --------
read -p "1. Which open-source tool do you use regularly? " tool_name
read -p "2. In one word, what does 'freedom' mean to you? " freedom_word
read -p "3. What would you like to build and share openly? " build_idea

# -------- Basic Info --------
current_date=$(date '+%d %B %Y')
user_name=$(whoami)
output_file="manifesto_${user_name}.txt"

echo ""
echo "Creating your manifesto..."
echo ""

# -------- Generate Content --------
{
echo "=============================================================="
echo "              MY OPEN SOURCE MANIFESTO                        "
echo "=============================================================="
echo "Author : $user_name"
echo "Date   : $current_date"
echo ""
echo "I believe in a world where knowledge is shared freely."
echo "Every day, I use $tool_name — something built by someone"
echo "who decided to share their work openly with everyone."
echo ""
echo "For me, freedom means $freedom_word. In software, this"
echo "means having the ability to understand, modify, and share"
echo "the tools that I use."
echo ""
echo "In the future, I want to create $build_idea and make it"
echo "available to everyone, just like others have done before me."
echo ""
echo "Open source is not just about code, it's about community,"
echo "learning, and helping others grow."
echo ""
echo "— $user_name, $current_date"
echo "=============================================================="
} > "$output_file"

# -------- Display Result --------
echo "Your manifesto has been saved as: $output_file"
echo ""

cat "$output_file"
