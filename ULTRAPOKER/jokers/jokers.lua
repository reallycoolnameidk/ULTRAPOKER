SMODS.Joker{ --Into the Fire
    name = "Into the Fire",
    key = "intothefire",
    config = {
        extra = {
            xmult = 1,
        }
    },
    loc_txt = {
        ['name'] = 'Into the Fire',
        ['text'] = {
            [1] = 'If {C:attention}played hand{} triggers {C:red}fire effect{},',
            [2] = 'destroys all {C:attention}Glass Cards{} held in hand and',
            [3] = 'adds {X:red,C:white}X0.5{} Mult for each card destroyed',
            [4] = '{C:inactive}(Currently{} {X:red,C:white}X#1#{} {C:inactive}Mult){}',
        }
    },
    pos = {
        x = 0,
        y = 0
    },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                Xmult = card.ability.extra.xmult
            }
        end
        if G.ARGS.chip_flames.real_intensity then
            if context.end_of_round and context.cardarea == G.hand and not context.other_card.debuff and SMODS.get_enhancements(context.other_card)["m_glass"] and not context.blueprint then
                card.ability.extra.xmult = card.ability.extra.xmult + 0.5
                SMODS.destroy_cards(context.other_card)
                return {
                    message = "Fire!",
                    colour = G.C.RED,
                    message_card = card
                }
            end
        end
    end
}

SMODS.Joker{ --The Meatgrinder
    name = "The Meatgrinder",
    key = "themeatgrinder",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'The Meatgrinder',
        ['text'] = {
            [1] = '{C:red}+20{} Mult if played hand',
            [2] = 'contains a {C:attention}flush{}',
            [3] = 'and a {C:attention}pair{}'
        }
    },
    pos = {
        x = 1,
        y = 0
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.joker_main and (next(context.poker_hands["Pair"]) and next(context.poker_hands["Flush"])) then
            return {
                mult = 20
            }
        end
    end
}

SMODS.Joker{ --Double Down
    name = "Double Down",
    key = "doubledown",
    config = {
        extra = {
            mult = 0
        }
    },
    loc_txt = {
        ['name'] = 'Double Down',
        ['text'] = {
            [1] = 'This Joker gains {C:red}+3{} Mult if played',
            [2] = 'hand contais a {C:attention}Stone Card{}',
            [3] = '{C:inactive}(Currently{} {C:red}+#1#{} {C:inactive}Mult){}'
        }
    },
    pos = {
        x = 2,
        y = 0
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if (function()
    local count = 0
    for _, pcard in pairs(context.full_hand) do
        if SMODS.get_enhancements(pcard)["m_stone"] then
            count = count + 1
        end
    end
    return count >= 1
end)() then
                card.ability.extra.mult = card.ability.extra.mult + 3
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.ATTENTION
                }
            end
        end
        if context.joker_main then
            return {
                    mult = card.ability.extra.mult
                }
        end
    end
}

SMODS.Joker{ --A One-Machine Army
    name = "A One-Machine Army",
    key = "aonemachinearmy",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'A One-Machine Army',
        ['text'] = {
            [1] = 'If played hand contains a {C:attention}Straight{}',
            [2] = 'and a {C:attention}4{}, gives {C:chips}+170{} Chips and',
            [3] = 'creates a random {C:purple}Tarot{} card',
            [4] = '{C:inactive}(Must have room){}'
        }
    },
    pos = {
        x = 3,
        y = 0
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.joker_main then
            if (next(context.poker_hands["Straight"]) and (function()
    local rankCount = 0
    for i, c in pairs(context.full_hand) do
        if c:get_id() == 4 then
            rankCount = rankCount + 1
        end
    end
    
    return rankCount >= 1
end)()) then
                local created_consumable = false
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    created_consumable = true
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card{set = 'Tarot', key = nil, key_append = 'joker_forge_tarot'}
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                end
                return {
                    chips = 170,
                    extra = {
                        message = created_consumable and localize('k_plus_tarot') or nil,
                        colour = G.C.PURPLE
                        }
                }
            end
        end
    end
}

SMODS.Joker{ --Cerberus
    name = "Cerberus",
    key = "cerberus",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Cerberus',
        ['text'] = {
            [1] = 'On {C:attention}Boss Blinds{}, gives {X:red,C:white}X5{} Mult if',
            [2] = 'played hand contains a {C:attention}Two Pair{}'
        }
    },
    pos = {
        x = 4,
        y = 0
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.joker_main then
            if G.GAME.blind.boss and next(context.poker_hands["Two Pair"]) then
                return {
                    Xmult = 5
                }
            end
        end
    end
}

SMODS.Joker{ --Heart of the Sunrise
    key = "heartofthesunrise",
    config = {
        extra = {
            money = 1
        }
    },
    loc_txt = {
        ['name'] = 'Heart of the Sunrise',
        ['text'] = {
            [1] = 'Earn {C:money}$#1#{} at end of round,',
            [2] = 'payout increased by {C:money}$1{} for',
            [3] = 'each scored {C:attention}Ace{}. Resets on',
            [4] = '{C:attention}Boss Blinds{}'
        }
    },
    pos = {
        x = 5,
        y = 0
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money}}
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 14 and not context.other_card.debuff then
                card.ability.extra.money = card.ability.extra.money + 1
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.MONEY})
            end
        end
        if context.setting_blind and G.GAME.blind.boss and not card.getting_sliced and card.ability.extra.money > 1 then
            card.ability.extra.money = 1
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_reset'), colour = G.C.MONEY})
        end
        function card:calculate_dollar_bonus()
            return card.ability.extra.money
        end
    end
}

SMODS.Joker{ --The Burning World
    key = "theburningworld",
    config = {
        extra = {
            triggered = 0
        }
    },
    loc_txt = {
        ['name'] = 'The Burning World',
        ['text'] = {
            [1] = 'If played hand triggers {C:red}fire{}',
            [2] = '{C:red}effect{}, {C:green}#1# in 2{} chance to upgrade',
            [3] = 'level of played {C:attention}poker hand{}'
        }
    },
    pos = {
        x = 6,
        y = 0
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1)}}
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval then
            if G.ARGS.chip_flames.real_intensity and card.ability.extra.triggered == 0 then
                if SMODS.pseudorandom_probability(card, 'group_0_f9879afd', 1, 2, 'j_uk_theburningworld') then
                    card.ability.extra.triggered = 1
                    target_hand = context.scoring_name
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_level_up_ex'), colour = G.C.RED})
                    SMODS.calculate_effect({level_up = 1, level_up_hand = target_hand}, card)
                end
            end
        end
        --there was a weird bug where it just kept leveling up hands indefenitely, this is my makeshift solution to it
        --there's probably a better way to go about it but if it works it works
        --you'll see me use this "triggered" system a lot in the future
        if card.ability.extra.triggered == 1 and context.starting_shop and not context.blueprint then
            card.ability.extra.triggered = 0
        end
    end
}

SMODS.Joker{ --Halls of Sacred Remains
    key = "hallsofsacredremains",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Halls of Sacred Remains',
        ['text'] = {
            [1] = 'If all cards held in hand are {C:hearts}Hearts{}',
            [2] = 'or {C:clubs}Clubs{}, creates the {C:planet}Planet{} card',
            [3] = 'for your most played {C:attention}poker hand{}',
            [4] = '{C:inactive}(Must have room){}'
        }
    },
    pos = {
        x = 7,
        y = 0
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        --thx to #modding-dev on the official game discord for this entire joker's code
        --they also helped me with a fuckton more jokers, lowkey goated people
        local _handname, _played, _order = "High Card", -1, 100
        for k, v in pairs(G.GAME.hands) do
            if v.played > _played or (v.played == _played and _order > v.order) then
                _played = v.played
                _handname = k
            end
        end
        G.GAME.current_round.most_played_hand = _handname
        if context.joker_main then
            local is_all_h_or_c = true
            for _, pcard in ipairs(G.hand.cards) do
                if not (pcard:is_suit("Hearts") or pcard:is_suit("Clubs")) then
                    is_all_h_or_c = false
                break
            end
        end
            if is_all_h_or_c then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    local _planet = 0
                    for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                        if v.config.hand_type == G.GAME.current_round.most_played_hand then
                            _planet = v.key
                        end
                    end
                    SMODS.add_card{type = "Planet", key = _planet}
                end
            end
        end
    end
}

SMODS.Joker{ --Clair de Lune
    key = "clairdelune",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Clair de Lune',
        ['text'] = {
            [1] = '{C:green}#1# in 4{} chance to add',
            [2] = 'a {C:attention}Blue Seal{} to each',
            [3] = 'scoring, non-sealed card'
        }
    },
    pos = {
        x = 9,
        y = 0
    },
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1)}}
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff then
            if not context.other_card:get_seal() then
                if SMODS.pseudorandom_probability(card, 'group_0_aab089d2', 1, 4, 'j_uk_clairdelune') then
                    context.other_card:set_seal("Blue", true)
                end
            end
        end
    end
}

SMODS.Joker{ --Bridgeburner
    key = "bridgeburner",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Bridgeburner',
        ['text'] = {
            [1] = 'If played hand contains a',
            [2] = '{C:attention}Stone Card{}, {C:green}#1# in 2{} chance',
            [3] = 'to create a random',
            [4] = '{C:purple}Tarot{} card'
        }
    },
    pos = {
        x = 8,
        y = 0
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1)}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if (function()
    local count = 0
    for _, playing_card in pairs(context.scoring_hand or {}) do
        if SMODS.get_enhancements(playing_card)["m_stone"] then
            count = count + 1
        end
    end
    return count >= 1
end)() then
                if SMODS.pseudorandom_probability(card, 'group_0_b0fb9b47', 1, 2, 'j_uk_bridgeburner') then
                    local created_consumable = false
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    created_consumable = true
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card{set = 'Tarot', key = nil, key_append = 'joker_forge_tarot'}
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                end
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = created_consumable and localize('k_plus_tarot') or nil, colour = G.C.PURPLE})
                  end
            end
        end
    end
}

SMODS.Joker{ --Death at 20,000 Volts
    key = "deathat20kv",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Death at 20 KV',
        ['text'] = {
            [1] = 'Retriggers each played {C:attention}2{}',
            [2] = 'twice and adds a',
            [3] = 'random {C:attention}Enhancement{}'
        }
    },
    pos = {
        x = 0,
        y = 1
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if context.other_card:get_id() == 2 then
                local other_card = context.other_card
                return {
                    repetitions = 2,
                    func = function ()
                        if not next(SMODS.get_enhancements(other_card)) and not other_card.debuff then
                            other_card:set_ability(SMODS.poll_enhancement{guaranteed = true}, nil, true)
                        end
                    end
                }
            end
        end
    end
}

SMODS.Joker{ --Sheer Heart Attack
    key = "sheerheartattack",
    config = {
        extra = {
            xmult = 1,
        }
    },
    loc_txt = {
        ['name'] = 'Sheer Heart Attack',
        ['text'] = {
            [1] = 'This joker gains {X:red,C:white}X0.2{} Mult if played',
            [2] = 'hand contains {C:attention}3{} or more scoring',
            [3] = 'cards with {C:hearts}Hearts{} suit',
            [4] = '{C:inactive}(Currently {}{X:red,C:white}X#1#{} {C:inactive}Mult){}'
        }
    },
    pos = {
        x = 1,
        y = 1
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,

    calculate = function(self, card, context)
        if context.joker_main and not context.blueprint then
            if (function()
                local suitCount = 0
                for i, c in ipairs(context.scoring_hand) do
                if c:is_suit("Hearts") and not c.debuff then
                    suitCount = suitCount + 1
                end
            end
            return suitCount >= 3
        end)()
        then
            card.ability.extra.xmult = card.ability.extra.xmult + 0.2
            end
	        if context.joker_main then
                return {
                    Xmult = card.ability.extra.xmult
                }
            end
        end
    end
}

SMODS.Joker{ --Court of the Corpse King
    key = "corpseking",
    config = {
        extra = {
            round = 0,
            juiced = 0
        }
    },
    loc_txt = {
        ['name'] = 'Court of the Corpse King',
        ['text'] = {
            [1] = 'After {C:attention}4{} rounds, sell this card to create',
            [2] = '{C:attention}2{} {C:uncommon}uncommon{} {C:dark_edition}negative{} Jokers',
            [3] = '{C:inactive}(Currently{} {C:attention}#1#{}{C:inactive}/4){}'
        }
    },
    pos = {
        x = 2,
        y = 1
    },
    cost = 10,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.round}}
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval then
            if card.ability.extra.round ~= 4 then
                card.ability.extra.round = card.ability.extra.round + 1
                return {
                    message = (card.ability.extra.round < 4) and
                    (card.ability.extra.round .. '/' .. 4) or
                    localize('k_active_ex'),
                    colour = G.C.FILTER
                }
            end
        end
        if context.selling_self and not card.getting_sliced then
            if card.ability.extra.round == 4 then
                return {
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local joker_card = SMODS.add_card({ set = 'Joker', rarity = 'Uncommon' })
                                if joker_card then
                                    joker_card:set_edition("e_negative", true)
                                end
                                return true
                            end
                        }))
                    end,
                    extra = {
                        func = function()
                            G.E_MANAGER:add_event(Event({
                            func = function()
                                local joker_card = SMODS.add_card({ set = 'Joker', rarity = 'Uncommon' })
                                if joker_card then
                                    joker_card:set_edition("e_negative", true)
                                end
                                return true
                            end
                            }))
                        end,
                    }
                }
            end
        end
        if card.ability.extra.round == 4 and card.ability.extra.juiced == 0 then
            --told you the "triggered" thingy will be back, even if it's now called juiced
            card.ability.extra.juiced = 1
            local eval = function(card) return not card.REMOVED end
            juice_card_until(card, eval, true)
        end
    end
}

SMODS.Joker{ --Belly of the Beast
    key = "bellyofthebeast",
    config = {
        extra = {
            mult = 0,
        }
    },
    loc_txt = {
        ['name'] = 'Belly of the Beast',
        ['text'] = {
            [1] = '{C:red}+3{} Mult for each card with',
            [2] = '{C:clubs}Clubs{} suit scored this round',
            [3] = '{C:inactive}(Currently{} {C:red}+#1#{} {C:inactive}Mult)'
        }
    },
    pos = {
        x = 4,
        y = 1
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint and not context.other_card.debuff then
            if context.other_card:is_suit("Clubs") then
                card.ability.extra.mult = card.ability.extra.mult + 3
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.RED})
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.mult = 0
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_reset'), colour = G.C.ATTENTION})
        end
    end
}

SMODS.Joker{ --In the Flesh
    key = "intheflesh",
    config = {
        extra = {
            triggers = 3,
        }
    },
    loc_txt = {
        ['name'] = 'In the Flesh',
        ['text'] = {
            [1] = 'Prevents death, costs {C:red}-$20{}',
            [2] = 'per trigger. {C:red}Self destructs{}',
            [3] = 'after {C:attention}3{} triggers',
            [4] = '{C:inactive}#1# remaining{}'
        }
    },
    pos = {
        x = 3,
        y = 1
    },
    cost = 10,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.triggers}}
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over then
            ease_dollars(-20)
            card.ability.extra.triggers = card.ability.extra.triggers - 1
            G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand_text_area.blind_chips:juice_up()
                        G.hand_text_area.game_chips:juice_up()
                        play_sound('tarot1')
                        return true
                    end
                })) 
                return {
                    message = localize('k_saved_ex'),
                    saved = true,
                    colour = G.C.RED
                }
        end
        if card.ability.extra.triggers == 0 then
            card:start_dissolve()
            return true
        end
    end
}

SMODS.Joker{ --Soul Survivor
    key = "soulsurvivor",
    config = {
        extra = {
            xmult = 1,
            triggered = 0
        }
    },
    loc_txt = {
        ['name'] = 'Soul Survivor',
        ['text'] = {
            [1] = 'This Joker gains {X:red,C:white}X3{} Mult if played',
            [2] = 'hand triggers {C:attention}Boss Blind{} ability',
            [3] = 'triggers only {C:attention}once{} per Blind',
            [4] = '{C:inactive}(Currently{} {X:red,C:white}X#1#{} {C:inactive}Mult){}'
        }
    },
    pos = {
        x = 5,
        y = 1
    },
    cost = 20,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,

    calculate = function(self, card, context)
        if G.GAME.blind.triggered and not context.blueprint and context.joker_main and card.ability.extra.triggered == 0 then
            card.ability.extra.xmult = card.ability.extra.xmult + 3
            card.ability.extra.triggered = 1
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.RED})
        end
        if context.joker_main then
            return {
                Xmult = card.ability.extra.xmult
            }
        end
        if card.ability.extra.triggered == 1 and context.end_of_round and context.main_eval and not context.game_over then
            card.ability.extra.triggered = 0
        end
    end
}

SMODS.Joker{ --Slaves to Power
    key = "slavestopower",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Slaves to Power',
        ['text'] = {
            [1] = 'When {C:attention}Blind{} is selected, gain {C:red}+4{}',
            [2] = 'discards and {C:blue}+1{} hand, lose {C:red}-$2{}',
            [3] = 'every hand played'
        }
    },
    pos = {
        x = 6,
        y = 1
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            return {
                func = function()
                    ease_hands_played(1)
                    ease_discard(4, nil, true)
                return true
                end,
                colour = G.C.ORANGE
            }
        end
        if context.joker_main then
            return {
                dollars = -2,
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker{ --God Damn the Sun
    key = "goddamnthesun",
    config = {
        extra = {
            triggered = 0
        }
    },
    loc_txt = {
        ['name'] = 'God Damn the Sun',
        ['text'] = {
            [1] = 'If {C:attention}first played{} hand of round',
            [2] = 'contains exactly {C:attention}2{} cards with',
            [3] = '{C:diamonds}Diamonds{} suit, destroy them',
            [4] = 'and earn {C:money}$4{}'
        }
    },
    pos = {
        x = 7,
        y = 1
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.destroy_card and context.destroy_card.should_destroy then
            return { remove = true }
        end
        if context.individual and context.cardarea == G.play and not context.blueprint then
            context.other_card.should_destroy = false
            if ((function()
    local suitCount = 0
    for i, c in ipairs(context.scoring_hand) do
        if c:is_suit("Diamonds") then
            suitCount = suitCount + 1
        end
    end
    return suitCount == 2
end)() and context.other_card:is_suit("Diamonds") and G.GAME.current_round.hands_played == 0) then
                context.other_card.should_destroy = true
                card.ability.extra.triggered = 1
            end
        end
        --card.ability.extra.triggered my beloved
        if context.joker_main and card.ability.extra.triggered == 1 then
            card.ability.extra.triggered = 0
            return {
                dollars = 4
            }
        end
    end
}

SMODS.Joker{ --A Shot in The Dark
    key = "ashotinthedark",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'A Shot in The Dark',
        ['text'] = {
            [1] = 'Retrigger the {C:attention}first scored{} card',
            [2] = '{C:attention}4{} additional times and the {C:attention}first{}',
            [3] = '{C:attention}held in hand{} card {C:attention}3{} times in {C:attention}final{}',
            [4] = '{C:attention}hand{} of round if no discards remain'
        }
    },
    pos = {
        x = 8,
        y = 1
    },
    cost = 10,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and not context.other_card.debuff then
            if (G.GAME.current_round.hands_left == 0 and G.GAME.current_round.discards_left == 0 and context.other_card == context.scoring_hand[1]) then
                return {
                    repetitions = 4,
                    message = localize('k_again_ex')
                }
            end
        end
        if context.repetition and context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) then
            if (G.GAME.current_round.hands_left == 0 and G.GAME.current_round.discards_left == 0 and context.other_card == G.hand.cards[1]) then
                return {
                    repetitions = 3,
                    message = localize('k_again_ex')
                }
            end
        end
    end
}

SMODS.Joker{ --Clair de Soleil
    key = "clairdesoleil",
    config = {
        extra = {
            triggered = 0
        }
    },
    loc_txt = {
        ['name'] = 'Clair de Soleil',
        ['text'] = {
            [1] = '{C:attention}+4{} hand size when',
            [2] = 'opening a {C:attention}Booster Pack{}'
        }
    },
    pos = {
        x = 9,
        y = 1
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        --dear old triggered is back everybody
        if card.ability.extra.triggered == 0 and (context.starting_shop or context.open_booster) then
            card.ability.extra.triggered = 1
            G.hand:change_size(4)
        end
        if card.ability.extra.triggered == 1 and (context.ending_shop or context.selling_self) then
            card.ability.extra.triggered = 0
            G.hand:change_size(-4)
        end
    end
}

SMODS.Joker{ --In The Wake of Poseidon
    key = "inthewakeofposeidon",
    config = {
        extra = {
            handsleft = 5,
        }
    },
    loc_txt = {
        ['name'] = 'In The Wake of Poseidon',
        ['text'] = {
            [1] = 'If {C:attention}0{} discards remain, retrigger all',
            [2] = 'played cards {C:attention}one{} additional time in',
            [3] = 'the next {C:attention}#1#{} hands'
        }
    },
    pos = {
        x = 0,
        y = 2
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.handsleft}}
    end,

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and not context.other_card.debuff then
            if G.GAME.current_round.discards_left == 0 then
                return {
                    repetitions = 1,
                    message = localize('k_again_ex')
                }
            end
        end
        if context.after and G.GAME.current_round.discards_left == 0 and not context.blueprint then
            if card.ability.extra.handsleft - 1 <= 0 then
                G.E_MANAGER:add_event(Event({
                                func = function()
                                    play_sound('tarot1')
                                    card.T.r = -0.2
                                    card:juice_up(0.3, 0.4)
                                    card.states.drag.is = true
                                    card.children.center.pinch.x = true
                                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                        func = function()
                                                G.jokers:remove_card(card)
                                                card:remove()
                                                card = nil
                                            return true; end}))
                                    return true
                                end
                            }))
                return {
                    message = 'Drained!',
                    colour = G.C.FILTER
                }
            else
                card.ability.extra.handsleft = card.ability.extra.handsleft - 1
                return {
                    message = card.ability.extra.handsleft..'',
                    colour = G.C.FILTER
                }
            end
        end
    end
}

SMODS.Joker{ --Waves of The Starless Sea
    key = "wavesofthestarlesssea",
    config = {
        extra = {
            chips = 0,
        }
    },
    loc_txt = {
        ['name'] = 'Waves of The Starless Sea',
        ['text'] = {
            [1] = 'Adds {C:attention}double{} the rank of the {C:attention}first{}',
            [2] = '{C:attention}scored{} card with {C:spades}Spades{} suit to this',
            [3] = 'Joker\'s {C:blue}Chips{}',
            [4] = '{C:inactive}(Currently{} {C:blue}+#1#{} {C:inactive}Chips){}'
        }
    },
    pos = {
        x = 1,
        y = 2
    },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips}}
    end,

    calculate = function(self, card, context)
        if context.before then
            for _, pcard in ipairs(context.scoring_hand) do
                if pcard:is_suit("Spades") and not pcard.debuff then
                    card.ability.extra.chips = card.ability.extra.chips + (pcard.base.nominal*2)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.BLUE})
                    break
                end
            end
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}

SMODS.Joker{ --Ship of Fools
    key = "shipoffools",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Ship of Fools',
        ['text'] = {
            [1] = '{C:green}#1# in 5{} chance for cards to be',
            [2] = 'drawn {C:attention}face down{}, face down',
            [3] = 'cards count as {C:attention}every suit{}'
        }
    },
    pos = {
        x = 2,
        y = 2
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1)}}
    end,

    --almost all code from #modding-dev again
    calculate = function(self, card, context)
        --except this, it's from the wheel boss blind
        if context.stay_flipped and context.to_area == G.hand and SMODS.pseudorandom_probability(card, 'group_0_aab089d2', 1, 5, 'j_uk_shipoffools') and not card.getting_sliced then
            return {
                stay_flipped = true,
            }
        end
        --and this, i made this myself
        if context.after then
            for _, c in pairs(context.full_hand) do
                if c.markaswild then
                    c.markaswild = false
                end
            end
        end
    end,
    --this function's from #modding-dev tho
    func = (function()
        local is_suitRef = Card.is_suit
        function Card:is_suit(suit, bypass_debuff, flush_calc)
            if self.facing == "back" and self.area == G.hand then
                self.markaswild = true
            end
            if SMODS.find_card('j_uk_shipoffools')[1] and (bypass_debuff or not self.debuff) and self.markaswild then
                if G.GAME.blind.debuff.suit then
                    self.debuff = true
                else
                    return true
                end
            end
            return is_suitRef(self, suit, bypass_debuff, flush_calc)
        end
    end)()
}

SMODS.Joker{ --Leviathan
    key = "leviathan",
    config = {
        extra = {
            mult = 0
        }
    },
    loc_txt = {
        ['name'] = 'Leviathan',
        ['text'] = {
            [1] = 'This Joker gains {C:red}+1{} Mult per',
            [2] = '{C:attention}consecutive{} hand played with at',
            [3] = 'least {C:attention}1{} non-scoring card',
            [4] = '{C:inactive}(Currently{} {C:red}+#1#{} {C:inactive}Mult)'
        }
    },
    pos = {
        x = 3,
        y = 2
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if #context.full_hand > #context.scoring_hand then
                card.ability.extra.mult = card.ability.extra.mult + 1
                return {
                    message = localize("k_upgrade_ex")
                }
            elseif #context.full_hand == #context.scoring_hand and card.ability.extra.mult > 0 then
                card.ability.extra.mult = 0
                return {
                    message = localize("k_reset")
                }
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker{ --Cry for the Weeper
    key = "cryfortheweeper",
    config = {
        extra = {
            mult = 0,
            every = 5,
            loyalty_remaining = 5
        }
    },
    loc_txt = {
        ['name'] = 'Cry for the Weeper',
        ['text'] = {
            [1] = 'Destroys a {C:attention}random{} scoring card every {C:attention}6{}',
            [2] = 'hands played and gains its {C:attention}rank{} as {C:red}Mult{}',
            [3] = '{C:inactive}(Currently{} {C:red}+#1#{} {C:inactive}Mult){}',
            [4] = '{C:inactive}#2#{}'
        }
    },
    pos = {
        x = 4,
        y = 2
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, localize{type = 'variable', key = (card.ability.extra.loyalty_remaining == 0 and 'loyalty_active' or 'loyalty_inactive'), vars = {card.ability.extra.loyalty_remaining}}}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.loyalty_remaining = (card.ability.extra.every - 1 - (G.GAME.hands_played - card.ability.hands_played_at_create)) % (card.ability.extra.every + 1)
            if not context.blueprint then
                if card.ability.extra.loyalty_remaining == 0 then
                    local eval = function(card) return card.ability.extra.loyalty_remaining == 0 and not G.RESET_JIGGLES end
                    juice_card_until(card, eval, true)
                end
            end
            if card.ability.extra.loyalty_remaining == card.ability.extra.every then
                for _, pcard in ipairs(context.scoring_hand) do
                    local targ = math.random(#context.scoring_hand)
                    if pcard == context.scoring_hand[targ] and not pcard.debuff then
                        local mult_gain = pcard.base.nominal
                        card.ability.extra.mult = card.ability.extra.mult + mult_gain
                        SMODS.destroy_cards(pcard)
                        break
                    end
                end
            end
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker{ --Aesthetics of Hate
    key = "aestheticsofhate",
    config = {
        extra = {
            hands = 6
        }
    },
    loc_txt = {
        ['name'] = 'Aesthetics of Hate',
        ['text'] = {
            [1] = 'After {C:attention}6 consecutive{} hands without playing',
            [2] = 'your most played {C:attention}poker hand{}, gain {C:money}$20{}',
            [3] = '{C:red}self destructs{}',
            [4] = '{C:inactive}#1# remaining{}'
        }
    },
    pos = {
        x = 5,
        y = 2
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.hands}}
    end,

    calculate = function(self, card, context)
        if context.before then
            local reset = true
            local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
            for k, v in pairs(G.GAME.hands) do
                if k ~= context.scoring_name and v.played >= play_more_than and v.visible then
                    reset = false
                end
            end
            if reset then
                if card.ability.extra.hands < 6 then
                    card.ability.extra.hands = 6
                    return {
                        message = localize('k_reset')
                    }
                end
            else
                card.ability.extra.hands = card.ability.extra.hands - 1
                return {
                    message = card.ability.extra.hands..''
                }
            end
        end
        if context.after and card.ability.extra.hands == 0 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_dollars(20)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('$')..20, colour = G.C.MONEY})
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 2.5, blockable = false,
                        func = function ()
                            card:start_dissolve()
                            return true
                        end}))
                    return true
                end
            }))
        end
    end
}

SMODS.Joker{ --Wait of the World
    key = "waitoftheworld",
    config = {
        extra = {
            xmult = 1,
        }
    },
    loc_txt = {
        ['name'] = 'Wait of the World',
        ['text'] = {
            [1] = 'This Joker gains {X:red,C:white}X0.25{} Mult every',
            [2] = 'hand played, {C:green}#1# in 6{} chance to reset',
            [3] = 'every discard',
            [4] = '{C:inactive}(Currently{} {X:red,C:white}X#2#{} {C:inactive}Mult){}'
        }
    },
    pos = {
        x = 6,
        y = 2
    },
    cost = 20,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card) 
        return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.xmult}}
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult + 0.25
        end
        if context.joker_main then
            return {
                Xmult = card.ability.extra.xmult
            }
        end
        if context.pre_discard and not context.hook and not context.blueprint and card.ability.extra.xmult > 1 then
            if SMODS.pseudorandom_probability(card, 'group_0_b0e957bd', 1, 6, 'j_ultrakil_waitoftheworld') then
                card.ability.extra.xmult = 1
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED,
                    message_card = card
                }
            else
                return {
                    message = localize('k_safe_ex'),
                    colour = G.C.RED,
                    message_card = card
                }
            end
        end
    end
}
