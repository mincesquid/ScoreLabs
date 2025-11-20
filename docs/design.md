# ScoreLabs Visual Design

This document outlines the visual identity and design specifications for ScoreLabs, incorporating the "Glitch Security" aesthetic with a professional cyberpunk theme.

## Overview

ScoreLabs features a unique KDE Plasma desktop environment with a distinctive red/black/grey color palette and subtle glitch effects, designed for security professionals who need both functionality and a professional appearance.

## Color Palette

- **Primary Red**: `#FF0033` (vibrant security alert red)
- **Dark Red**: `#330000` (deep background red)
- **Glitch Grey**: `#1a1a1a` (primary dark background)
- **Accent Grey**: `#2d2d2d` (secondary backgrounds, panels)
- **Text Primary**: `#dcdcdc` (light grey for main text)
- **Text Secondary**: `#787878` (disabled/inactive text)

## Desktop Environment

- **Window Manager**: KDE Plasma with KWin
- **Display Manager**: SDDM
- **Theme**: Custom "GlitchSec" theme
- **Dock**: Latte Dock with security-focused design
- **Icons**: Papirus with red accent modifications
- **Fonts**: Hack, Fira Code for monospace elements

## Key Visual Elements

### Wallpapers

- Default: Abstract glitch pattern with red accents and hexadecimal overlays
- Lock Screen: More aggressive glitch with centered lock icon
- Alternatives: Network topology, terminal aesthetic, circuit board patterns

### Window Decorations

- Title bars: Dark grey with thin red top border for active windows
- Buttons: Minimal flat design with red hover effects
- Shadows: Subtle red glow for active windows

### Effects and Animations

- Glitch transitions between windows
- Subtle RGB split effects
- Red accent animations
- Professional timing (150-200ms transitions)

## Implementation

The visual design is implemented through:

- Custom KDE theme configurations
- Kvantum theme engine
- Modified icon sets
- Custom KWin scripts for effects
- Latte Dock configuration

## Asset Generation

Visual assets can be generated using AI tools with the specifications in `config/airootfs/root/CHATGPT_DESIGN_PROMPT.txt`.

## Customization

Users can modify colors and effects through:

- KDE System Settings
- Kvantum theme manager
- Latte Dock configuration
- Custom KWin scripts
