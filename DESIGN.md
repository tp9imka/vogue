# Design System

A working reference for the app's design system. The audience is a
functional-fitness / CrossFit box: the visual language is **bold,
energetic, high-contrast and dark-first**. The app's job is to let a member glance at their phone
before/during a session and instantly read today's workout.

All tokens live in `lib/presentation/theme/`. Feature code references tokens
and `Theme.of(context)` — never raw `Color(...)` or ad-hoc `TextStyle`.

| File | Contents |
|------|----------|
| `vogue_tokens.dart` | `VogueColors`, `VogueSpace`, `VogueRadius`, `VogueElevation`, `VogueDuration` |
| `vogue_typography.dart` | `VogueTypography` — the type scale |
| `program_palette.dart` | `programAccent()` / `programSurface()` per `Program` |
| `vogue_theme.dart` | `buildVogueDarkTheme()` (primary), `buildVogueLightTheme()` |

## Palette

Dark-first. The surface ramp is a faintly cool near-black so it reads as
deliberate athletic black, not flat console grey. One high-energy brand
accent: **volt lime**.

### Dark surface ramp

| Token | Hex | Role |
|-------|-----|------|
| `surface` | `#0C0E11` | App backdrop, behind everything |
| `surfaceRaised` | `#15181D` | Default container (cards, sheets) |
| `surfaceHigh` | `#1E222A` | Nested / hovered / floating surfaces |
| `outline` | `#2C313B` | Hairline borders and dividers |

### Ink ramp (text on dark)

| Token | Hex | Role | Contrast on `surface` |
|-------|-----|------|-----------------------|
| `ink` | `#F4F6F8` | Primary text | ~17.8:1 |
| `inkMuted` | `#AEB6C2` | Secondary / supporting text | ~9.2:1 |
| `inkFaint` | `#7C8593` | Captions, timestamps | ~4.7:1 (AA normal) |

### Brand accent

| Token | Hex | Role |
|-------|-----|------|
| `primary` | `#C8FA4B` | Volt-lime brand accent, primary CTA |
| `primaryDim` | `#A6D62F` | Pressed / active variant |
| `primarySoft` | `#1F2A12` | Faint accent wash, selected tint |
| `onPrimary` | `#0C0E11` | Text/icons on `primary` (~14.6:1) |

### Semantic

| Token | Hex | Role |
|-------|-----|------|
| `success` | `#36D399` | Fresh data, confirmations |
| `warning` | `#FFC247` | Stale cache, "updated a while ago" |
| `error` | `#FF5A5F` | Failed fetch / parse |
| `info` | `#4FA8FF` | Neutral informational accents |
| `onSemantic` | `#0C0E11` | Text/icons on any semantic fill |

## Program colors

Each of the five `Program` types is color-coded so a workout is identifiable
at a glance. The five hues are mutually distinct and distinct from the volt
brand accent. `programAccent()` returns the saturated hue;
`programSurface()` returns a soft dark-tinted background for badge fills and
card washes.

| Program | Accent | Surface | Hue |
|---------|--------|---------|-----|
| VogueFit | `#FF6A2B` | `#2A1810` | Orange |
| Metcon | `#F4364C` | `#2C1216` | Red |
| WOD | `#2E8BFF` | `#111E2E` | Blue |
| Speciality | `#9B5CF6` | `#1C162C` | Violet |
| Stamina | `#27C281` | `#0F2419` | Green |

## Type scale

`VogueTypography` — built on the bundled platform font. The bold, athletic
character comes from heavy weights and tracking, not a custom typeface.
Colors are applied by the theme, not baked into the styles.

| Role | Size | Weight | Height | Tracking | Use |
|------|------|--------|--------|----------|-----|
| `display` | 34 | 800 | 1.1 | -0.5 | Date header, hero numbers |
| `headline` | 24 | 700 | 1.2 | -0.25 | Section headings |
| `title` | 18 | 700 | 1.3 | 0 | Card / app-bar titles |
| `body` | 15 | 400 | 1.45 | 0 | Running detail text |
| `label` | 12 | 700 | 1.2 | +0.8 | Badges, captions, button labels |
| `workout` | 20 | 600 | 1.55 | +0.1 | Workout content — readable mid-session |

`workout` is the most important style: large with generous line-height so a
member can read a movement at arm's length.

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

Dark UIs lean on surface tint and borders more than shadows — the set is
small.

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
- Color-code program UI via `programAccent()` / `programSurface()`.
- Keep workout content in the `workout` style — it must read at arm's length.
- Use the 4-pt spacing scale for all padding, margins and gaps.
- Keep touch targets at least 48px tall (the button themes already enforce
  this).
- Treat dark as the primary theme; verify new UI there first.

**Don't**

- Hard-code `Color(...)` or build ad-hoc `TextStyle` in feature code.
- Invent spacing values off the 4-pt scale.
- Use the volt `primary` accent for a program — it is the brand color, not a
  sixth program hue.
- Rely on drop shadows to separate surfaces; use the surface ramp and
  `outline` borders.
- Put light/faint ink (`inkFaint`) on anything smaller than normal body text.
