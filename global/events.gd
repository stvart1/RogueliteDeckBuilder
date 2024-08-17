extends Node


signal game_finished

# view events
signal tooltip_requested(icon: Texture, title: String, text: String, array: Array)
signal tooltip_hide_requested
signal cardpile_view_requested(title: String, cardpile: CardPile)

# Card-related events
signal card_drag_started(card_ui: CardUI)
signal card_drag_ended(card_ui: CardUI)
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_played(card: Card)
signal discard_card

# Player-related events
signal player_hand_drawn(player: Player)
signal player_hand_discarded
signal player_turn_ended
signal player_hit
signal player_died
signal stats_changed
signal stats_changed_delay
signal stats_update(stats: Stats)
signal player_gain_move(move: int)
signal player_gain_buy(buy: int)
signal player_draw_cards(draw: int)

# Draft events
signal card_drafted(card: Card)
signal alter_card_cost(change: int)
signal draft_refresh_button_pressed

 # Enemy-related events
signal enemy_died(enemy: Enemy)
signal enemy_with_slow_died()
#signal enemy_action_completed(enemy: Enemy)
signal enemy_turn_ended
signal spawn_enemy(type: EnemyStats.Type)
signal spawn_specific_enemy(enemystats: EnemyStats)

## Battle-related events
#signal battle_over_screen_requested(text: String, type: BattleOverPanel.Type)
#signal battle_won
#signal status_tooltip_requested(statuses: Array[Status])
#
# Map-related events
signal generate_map
signal new_map_generated(elevator_pos: Vector2)
signal room_clicked(room: Room)
signal level_enetered(level: int)
signal floor_mods_selected(mods: Array[FloorModifier])
signal floor_exited

# Shop-related events
#signal shop_entered(shop: Shop)
#signal shop_relic_bought(relic: Relic, gold_cost: int)
#signal shop_card_bought(card: Card, gold_cost: int)
#signal shop_exited

## Campfire-related events
#signal campfire_exited
#
## Battle Reward-related events
#signal battle_reward_exited
#
## Treasure Room-related events
#signal treasure_room_exited(found_relic: Relic)
#
# Relic-related events
signal  relic_gained(relic: Relic)
signal activate_start_of_turn_relics
#signal relic_tooltip_requested(relic: Relic)

#
## Random Event room-related events
#signal event_room_exited
