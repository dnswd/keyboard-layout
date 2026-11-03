#include QMK_KEYBOARD_H

enum layers { _BASE = 0, _NAV = 1, _SYM = 2, _FN = 3, _GAME = 4, _GNUM = 5, _GCHAT = 6 };

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [_BASE] = LAYOUT_split_3x6_3(
    KC_TAB,        KC_Q,          KC_W,          KC_E,          KC_R,          KC_T,          KC_Y,          KC_U,          KC_I,          KC_O,          KC_P,          KC_BSPC,
    KC_LCTL,       KC_A,          KC_S,          KC_D,          KC_F,          KC_G,          KC_H,          KC_J,          KC_K,          KC_L,          KC_QUOT,       KC_BTN2,
    KC_LSFT,       KC_Z,          KC_X,          KC_C,          KC_V,          KC_B,          KC_N,          KC_M,          KC_COMM,       KC_DOT,        KC_SLSH,       KC_RSFT,
                                                 KC_LGUI,       MO(_SYM),      KC_SPC,        KC_ENT,        MO(_NAV),      KC_LALT
  ),
  [_NAV] = LAYOUT_split_3x6_3(
    _______,       _______,       _______,       _______,       _______,       _______,       KC_MPRV,       KC_MSTP,       KC_MPLY,       KC_MNXT,       _______,       KC_MUTE,
    _______,       OSM(MOD_LGUI), OSM(MOD_LALT), OSM(MOD_LSFT), OSM(MOD_LCTL), _______,       KC_LEFT,       KC_DOWN,       KC_UP,         KC_RGHT,       _______,       KC_VOLU,
    _______,       _______,       _______,       _______,       _______,       _______,       KC_END,        KC_PGDN,       KC_PGUP,       KC_HOME,       _______,       KC_VOLD,
                                                 _______,       _______,       _______,       _______,      _______,      _______
  ),                                                                      OSM(MOD_LCTL)
  [_SYM] = LAYOUT_split_3x6_3(
    _______,       _______,       S(KC_6),       S(KC_8),       S(KC_7),       S(KC_MINS),    KC_PAST,       KC_P7,         KC_P8,         KC_P9,         KC_PPLS,       _______,
    _______,       _______,       S(KC_3),       S(KC_5),       S(KC_4),       KC_PEQL,       KC_PSLS,       KC_P4,         KC_P5,         KC_P6,         KC_PMNS,       _______,
    _______,       _______,       S(KC_BSLS),    S(KC_2),       S(KC_1),       KC_PMNS,       KC_PDOT,       KC_P1,         KC_P2,         KC_P3,         KC_PENT,       _______,
                                                 _______,       _______,       _______,       _______,       KC_P0,         _______
  ),
  [_FN] = LAYOUT_split_3x6_3(
    KC_F18,        KC_F15,        KC_F7,         KC_F8,         KC_F9,         KC_F12,        _______,       _______,       _______,       _______,       _______,       TG(_GAME),
    KC_F17,        KC_F14,        KC_F4,         KC_F5,         KC_F6,         KC_F11,        _______,       _______,       _______,       _______,       _______,       _______,
    KC_F16,        KC_F13,        KC_F1,         KC_F2,         KC_F3,         KC_F10,        _______,       _______,       _______,       _______,       _______,       _______,
                                                 _______,       _______,       _______,       _______,       _______,       _______
  ),

  /**
   * GAMING SPECIFIC LAYERS 
   */ 

  [_GAME] = LAYOUT_split_3x6_3(
    // NOTE: KC_P also at left-outer bottom
    // TODO: ENTER for submitting comms
    KC_ESC,        KC_T,          KC_Q,          KC_W,          KC_E,          KC_R,          KC_Y,          KC_U,          KC_I,          KC_O,          KC_P,          TG(_GAME),
    KC_TAB,        KC_LSFT,       KC_A,          KC_S,          KC_D,          KC_F,          KC_H,          KC_J,          KC_K,          KC_L,          S(KC_1),       KC_NO,
    KC_P,          KC_LCTL,       KC_Z,          KC_X,          KC_C,          KC_V,          KC_N,          KC_M,          KC_PCMM,       KC_PDOT,       S(KC_SLSH),    KC_RSFT,
                                                 KC_WH_U,       MO(_GNUM),     KC_SPC,        KC_SPC,        MO(_GCHAT),    KC_WH_D
  ),
  [_GNUM] = LAYOUT_split_3x6_3(
    _______,       KC_P6,         KC_P7,         _______,       KC_P8,         KC_P9,         _______,       _______,       _______,       _______,       _______,       _______,
    _______,       _______,       _______,       _______,       _______,       KC_P0,         _______,       _______,       _______,       _______,       _______,       _______,
    _______,       KC_P1,         KC_P2,         KC_P3,         KC_P4,         KC_P5,         _______,       _______,       _______,       _______,       _______,       _______,
                                                 _______,       _______,       _______,       _______,       _______,       _______
  ),
  // TODO: Should this be normal qwerty layer? Seems awkward
  [_GCHAT] = LAYOUT_split_3x6_3(
    _______,       KC_Q,          KC_W,          KC_E,          KC_R,          KC_T,          _______,       _______,       _______,       _______,       _______,       _______,
    _______,       KC_A,          KC_S,          KC_D,          KC_F,          KC_G,          _______,       _______,       _______,       _______,       _______,       _______,
    _______,       KC_Z,          KC_X,          KC_C,          KC_V,          KC_B,          _______,       _______,       _______,       _______,       _______,       _______,
                                                 _______,       _______,       _______,       _______,       _______,       _______
  )
};

layer_state_t layer_state_set_user(layer_state_t state) {
    return update_tri_layer_state(state, _NAV, _SYM, _FN);
}

// Combos only on the base layer: any other active layer (thumb layers, tri-layer, game toggle) blocks them.
bool combo_should_trigger(uint16_t combo_index, combo_t *combo, uint16_t keycode, keyrecord_t *record) {
    return get_highest_layer(layer_state | default_layer_state) == _BASE;
}