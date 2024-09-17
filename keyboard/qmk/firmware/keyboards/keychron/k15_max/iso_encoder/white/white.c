/* Copyright 2024 @ Keychron (https://www.keychron.com)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "quantum.h"

// clang-format off
#ifdef LED_MATRIX_ENABLE
const snled27351_led_t g_snled27351_leds[LED_MATRIX_LED_COUNT] = {
/* Refer to snled27351manual for these locations
 *   driver
 *   |  LED address
 *   |  | */
    {0, F_2},
    {0, F_3},
    {0, F_4},
    {0, F_5},
    {0, F_6},
    {0, F_7},
    {0, F_8},
    {0, F_9},
    {0, F_10},
    {0, F_11},
    {0, F_12},
    {0, F_13},
    {0, F_14},
    {0, F_15},
    {0, F_16},

    {0, E_1},
    {0, E_2},
    {0, E_3},
    {0, E_4},
    {0, E_5},
    {0, E_6},
    {0, E_7},
    {0, E_8},
    {0, E_9},
    {0, E_10},
    {0, E_11},
    {0, E_12},
    {0, E_13},
    {0, E_14},
    {0, E_15},
    {0, E_16},

    {0, D_1},
    {0, D_2},
    {0, D_3},
    {0, D_4},
    {0, D_5},
    {0, D_6},
    {0, D_7},
    {0, D_8},
    {0, D_9},
    {0, D_10},
    {0, D_11},
    {0, D_12},
    {0, D_13},
    {0, D_14},
    {0, D_15},
    {0, D_16},

    {0, C_1},
    {0, C_2},
    {0, C_3},
    {0, C_4},
    {0, C_5},
    {0, C_6},
    {0, C_7},
    {0, C_9},
    {0, C_10},
    {0, C_11},
    {0, C_12},
    {0, C_13},
    {0, C_14},
    {0, C_15},
    {0, C_16},

    {0, B_1},
    {0, B_2},
    {0, B_3},
    {0, B_4},
    {0, B_5},
    {0, B_6},
    {0, B_7},
    {0, B_8},
    {0, B_9},
    {0, B_10},
    {0, B_11},
    {0, B_12},
    {0, B_13},
    {0, B_14},
    {0, B_15},
    {0, B_16},

    {0, A_1},
    {0, A_2},
    {0, A_3},
    {0, A_4},
    {0, A_5},
    {0, A_7},
    {0, A_10},
    {0, A_11},
    {0, A_12},
    {0, A_14},
    {0, A_15},
    {0, A_16},
};

#define __ NO_LED

led_config_t g_led_config = {
    {
        // Key Matrix to LED Index
        { __,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14 },
        { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
        { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46 },
        { 47, 48, 49, 50, 51, 52, __, 53, 54, 55, 56, 57, 58, 59, 60, 61 },
        { 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77 },
        { 78, 79, 80, 81, __, 82, __, 83, __, 84, 85, 86, __, 87, 88, 89 },
    },
    {
        // LED Index to Physical Position
                {19, 0}, {34, 0}, {46, 0}, {59, 1}, {71, 3}, {86, 6}, { 98, 8}, {121, 8}, {133, 6}, {147, 3}, {159, 1}, {173, 0}, {185, 0}, {203, 0}, {220, 0},
        {5,14}, {24,14}, {36,14}, {48,13}, {61,15}, {73,17}, {85,20}, { 97,22}, {116,22}, {128,20}, {140,17}, {152,15}, {165,13}, {177,14}, {195,14}, {220,14},
        {4,24}, {24,24}, {40,24}, {53,24}, {65,27}, {77,29}, {89,31}, {113,33}, {125,31}, {137,29}, {149,26}, {161,24}, {174,24}, {186,24}, {201,29}, {222,24},
        {2,34}, {23,34}, {40,34}, {53,35}, {65,37}, {77,39}, {89,42},           {118,42}, {130,40}, {142,38}, {154,36}, {167,34}, {179,34}, {192,34}, {224,35},
        {0,45}, {18,45}, {33,45}, {44,45}, {57,46}, {69,48}, {81,51}, { 93,53}, {112,54}, {124,52}, {136,50}, {148,48}, {160,46}, {173,45}, {190,45}, {210,47},
        {0,55}, {18,55}, {33,55}, {56,57},          {77,61},          { 96,64},           {125,63}, {147,58}, {159,56},           {198,58}, {210,58}, {222,58}
    },
    {
        // LED LED Index to Flag
           1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1,    1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1,    1,    1,    1, 1, 1,    1, 1, 1
    }
};
#endif