class_name DraftArea
extends Node2D


const DRAFT_CARD = preload("res://scenes/card/draft_card.tscn")

@export var draftpile : CardPile
@export var draft_size:= 6

@onready var cards = %Cards
@onready var refresh_button = $RefreshButton
@onready var available_cards: Array[Card] = draftpile.duplicate_cards()
@onready var status_handler: StatusHandler = $StatusHandler
@onready var modifier_handler: ModifierHandler = $ModifierHandler

var refresh_cost := 4
var player: Node2D
var modified_refresh_cost = refresh_cost



func _ready():
	if not is_node_ready():
		await ready
	player = get_tree().get_first_node_in_group("player")
	#	clear test cards
	for draft_card: DraftCard in cards.get_children():
		draft_card.queue_free()
	
	_generate_draft_cards()
	_fill_draft_area(draft_size)
	Events.stats_changed_delay.connect(_update_stats)
	refresh_button.text = str(refresh_cost)
	Events.player_turn_ended.connect(refill_cards)


func _generate_draft_cards():
	available_cards = draftpile.duplicate_cards()
	RNG.array_shuffle(available_cards)


func _fill_draft_area(amount: int):
	var draft_cards_array: Array[Card] = []
	for i in amount:
		if available_cards.size() < 1:
			_generate_draft_cards()
			
		#move cards from deck to draft pile
		draft_cards_array.append(available_cards.pop_front())
	
	
	for card: Card in draft_cards_array:
			#create new draftcard interface
		var new_draft_card := DRAFT_CARD.instantiate() as DraftCard
			#add new interface to draft grid
		cards.add_child(new_draft_card)
			#new draftcard to card
		new_draft_card.card = card
	
	update_cards()


func load_draft_area(draft_cards_array: Array[Card]):
	for draftcard: DraftCard in cards.get_children():
		draftcard.queue_free()
	
	
	for card: Card in draft_cards_array:
			#create new draftcard interface
		var new_draft_card := DRAFT_CARD.instantiate() as DraftCard
			#add new interface to draft grid
		cards.add_child(new_draft_card)
			#new draftcard to card
		new_draft_card.card = card
	
	update_cards()


func _on_refresh_button_pressed():
	#modified_refresh_cost = modifier_handler.get_modified_value(refresh_cost, Modifier.Type.DRAFT_REFRESH)
	print(modified_refresh_cost)
	if player.stats.buy < modified_refresh_cost:
		return
	player.stats.buy -= modified_refresh_cost
	for draft_card: DraftCard in cards.get_children():
		draft_card.queue_free()
	_fill_draft_area(draft_size)
	Events.draft_refresh_button_pressed.emit()
	


func _update_stats():
	update_cards()
	update_button()


func update_button():
	modified_refresh_cost = modifier_handler.get_modified_value(refresh_cost, Modifier.Type.DRAFT_REFRESH)
	
	refresh_button.text = str(modified_refresh_cost)
	
	if player.stats.buy < modified_refresh_cost:
		refresh_button.disabled = true
	else:
		refresh_button.disabled = false


func update_cards():
	for draft_card: DraftCard in cards.get_children():
		if not draft_card.is_queued_for_deletion():
			draft_card.update()


func refill_cards():
	
	var cards_to_replace = 0
	
	for draftcard: DraftCard in cards.get_children():
		if not draftcard.draft_button:
			draftcard.queue_free()
			cards_to_replace += 1
	
	_fill_draft_area(cards_to_replace)
	
	
	#update_cards()

