#pragma once

// Vial's setting was ~50 ms; 30 ms reduces accidental triggers on letter pairs (er, we, io, gh...).
#define COMBO_TERM 30

// Needed for combo_should_trigger() in keymap.c (base-layer-only combos).
#define COMBO_SHOULD_TRIGGER
