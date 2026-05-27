# Design System

A working reference for the app's design system. The voice is editorial /
"publication" — warm paper-and-ink with a single high-tension brand accent
(cinnabar), rather than the previous high-energy dark/neon style. Italic
Bodoni Moda carries the headlines; Inter does the rest.

All tokens live in `lib/presentation/theme/`. Feature code references tokens
and `Theme.of(context)` — never raw `Color(...)` or ad-hoc `TextStyle`.

| File | Contents |
|------|----------|
| `vogue_tokens.dart` | `VogueColors`, `VogueSpace`, `VogueRadius`, `VogueElevation`, `VogueDuration` |
| `vogue_typography.dart` | `VogueTypography` — the type scale (Bodoni Moda + Inter + JetBrains Mono) |
| `program_palette.dart` | `programAccent()` / `programSurface()` per `Program` |
| `vogue_theme.dart` | `buildVogueDarkTheme()` (primary), `buildVogueLightTheme()` |

## Fonts

| Family | Role |
|--------|------|
| **Bodoni Moda** (italic, 900) | `display`, `headline` — the editorial voice |
| **Inter** | `title`, `body`, `label`, `workout` — everything else |
| **JetBrains Mono** | `timer` — tabular numerals for the workout timer |

Loaded lazily on first launch via the `google_fonts` package and cached
locally afterwards.

## Palette

The brand is dark-first. The dark surface ramp is a warm near-black; the
text ramp is a creamy bone. The single brand accent is **cinnabar** — used
sparingly. Light surfaces (`paper`, `inkOnLight`) are exposed for future
light-theme support; the app currently locks to `ThemeMode.dark`.

### Dark surface ramp

| Token | Hex | Role |
|-------|-----|------|
| `surface` | `#0A0908` | App backdrop, behind everything (jet) |
| `surfaceRaised` | `#1E1B17` | Default container (cards, sheets) — soot |
| `surfaceHigh` | `#2A2620` | Sheets, floating panels — char |
| `outline` | `#3A342C` | Hairline borders and dividers — char-2 |

### Ink ramp (text on dark)

| Token | Hex | Role | Contrast on `surface` |
|-------|-----|------|-----------------------|
| `ink` | `#F1E9D8` | Primary text — bone | ~16.4:1 |
| `inkMuted` | bone @ 62% | Secondary / supporting text | ~9.2:1 |
| `inkFaint` | bone @ 38% | Captions, timestamps | ~4.6:1 (AA Normal) |

### Light ramp (future light theme)

| Token | Hex | Role |
|-------|-----|------|
| `paper` | `#FBF8F3` | App backdrop (light) |
| `paperRaised` | `#EFE9DC` | Default container (light) |
| `inkOnLight` | `#181410` | Primary text (light) |
| `inkMutedOnLight` | ink @ 62% | Secondary text (light) |

### Brand accent

| Token | Hex | Role |
|-------|-----|------|
| `primary` | `#D85F3C` | Cinnabar — the single brand accent / primary CTA |
| `primaryDim` | `#B84F32` | Pressed / active variant |
| `primarySoft` | `#3A1F18` | Faint cinnabar wash, selected tint on dark |
| `onPrimary` | `#181410` | Text/icons on `primary` — ink (~5.1:1, AA Normal) |

### Semantic

| Token | Hex | Role |
|-------|-----|------|
| `success` | `#6B9F7E` | Confirmations, "fresh data" |
| `warning` | `#C49141` | Stale cache, "offline" |
| `error` | `#B84738` | Failed fetch / parse |
| `info` | `#587FB8` | Neutral informational accents |
| `onSemantic` | `#181410` | Text/icons on any saturated semantic / program fill |

## Program colors

Each of the five `Program` types is color-coded so a workout is identifiable
at a glance. The hues are pulled from the brand palette (blush / cinnabar /
gold / sage / cobalt) and all clear WCAG AA Normal for `ink` on top.

`programAccent()` returns the saturated hue; `programSurface()` returns a
dark-tinted wash that sits cleanly on the dark surface ramp.

| Program | Accent | Surface | Hue |
|---------|--------|---------|-----|
| VogueFit | `#E5A9A0` | `#281C18` | Blush rose |
| Metcon | `#D85F3C` | `#2C1A16` | Cinnabar |
| WOD | `#E8C77A` | `#2A2118` | Bone gold |
| Speciality | `#A8B89F` | `#1C231E` | Sage |
| Stamina | `#6B8CC4` | `#16202C` | Cobalt |

## Type scale

Bodoni Moda for editorial display, Inter for the rest, JetBrains Mono for
the timer. Colors are applied by the theme, not baked into the styles.

| Role | Family | Size | Weight | Style | Height | Tracking | Use |
|------|--------|------|--------|-------|--------|----------|-----|
| `display` | Bodoni Moda | 44 | 900 | italic | 0.95 | -1.0 | Hero date, big editorial moments |
| `headline` | Bodoni Moda | 26 | 900 | italic | 1.10 | -0.5 | Section headings |
| `title` | Inter | 18 | 600 | — | 1.30 | 0 | Card / app-bar titles |
| `body` | Inter | 15 | 400 | — | 1.50 | 0 | Running detail text |
| `label` | Inter | 11 | 700 | — | 1.20 | +1.8 | Badges, captions, button labels (uppercase) |
| `workout` | Inter | 20 | 500 | — | 1.55 | +0.1 | Workout content — readable mid-session |
| `timer` | JetBrains Mono | 96 | 800 | — | 1.00 | -2.0 | Big tabular timer numerals |

`workout` is the most important style — generous leading so a member can
read a movement at arm's length mid-session. `timer` is naturally tabular,
so digits don't jitter as seconds tick over.

## Spacing — 4-pt scale (`VogueSpace`)

| Token | px | Use |
|-------|----|----|
| `xs` | 4 | Hairline gaps, icon-to-label |
| `sm` | 8 | Tight internal padding |
| `md` | 12 | Default control padding |
| `lg` | 16 | Standard screen / card padding |
| `xl` | 24 | Section separation |
| `xxl` | 32 | Large block separation |

## Radius (`VogueRadius`)

| Token | px | Use |
|-------|----|----|
| `sm` | 8 | Chips, inputs, small controls |
| `md` | 14 | Cards, sheets, primary containers |
| `lg` | 20 | Hero containers, large surfaces |
| `pill` | 999 | Fully rounded pills (badges, buttons) |

## Elevation (`VogueElevation`)

The editorial voice avoids shadows. The scale is deliberately small.

| Token | Value | Use |
|-------|-------|-----|
| `flat` | 0 | Flush with parent |
| `low` | 2 | Resting cards |
| `medium` | 6 | App bars, sticky headers |
| `high` | 12 | Modal sheets, dialogs |

## Motion (`VogueDuration`)

| Token | Duration | Use |
|-------|----------|-----|
| `fast` | 120ms | Taps, ripples, micro-feedback |
| `medium` | 240ms | Standard transitions, fades |
| `slow` | 400ms | Page transitions, larger reveals |

Pair with `Curves.easeOutCubic` for most UI motion.

## Do / Don't

**Do**

- Reference tokens and `Theme.of(context)` for every color, text style and
  measurement.
- Reach for `display` / `headline` (italic Bodoni) for editorial moments;
  reach for `title` / `body` (Inter) for everything else.
- Color-code program UI via `programAccent()` / `programSurface()`.
- Keep workout content in the `workout` style — it must read at arm's
  length.
- Use the 4-pt spacing scale for all padding, margins and gaps.
- Keep touch targets at least 48px tall (the button themes enforce this).

**Don't**

- Hard-code `Color(...)` or build ad-hoc `TextStyle` in feature code.
- Invent spacing values off the 4-pt scale.
- Use cinnabar `primary` for a program — it is the brand color, not a
  sixth program hue. (Metcon happens to be cinnabar by design.)
- Rely on drop shadows to separate surfaces; use the surface ramp and
  `outline` borders.
- Put faint ink (`inkFaint`) on anything smaller than normal body text.

## Light theme — status

`buildVogueLightTheme()` is wired and uses the `paper` / `inkOnLight`
ramp. The app locks to `ThemeMode.dark` in `lib/app.dart` until every
widget reads colors from `Theme.of(context)` rather than referencing the
dark-keyed `VogueColors.surface` / `ink` / etc. directly. Migrating those
widgets is the next step toward shipping light mode.
