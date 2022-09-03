module poker

import card
import readline { read_line }
import strconv

interface Player {
	name string
mut:
	hand Hand
	result PokerHand
	play_turn(mut deck Deck) ?PokerHand
	change_cards(discard_cards []card.Card, mut deck Deck) ?
}

struct Me {
	name string
mut:
	hand   Hand
	result PokerHand
}

struct Enemy {
	name string
mut:
	hand   Hand
	result PokerHand
}

fn select_disuse_cards(hand []card.Card) ?[]card.Card {
	mut listed_input := []int{}
	outer: for {
		listed_input = input_discard() or {
			println('please select number(1 to 5) only')
			continue outer
		}
		break
	}
	return listed_input.map(hand[it - 1])
}

fn input_discard() ?[]int {
	input := read_line('-- select disuse cards: ')?
	idx_list := input.trim('\n').split('')
		.map(strconv.atoi(it)?)
	if idx_list.len > 5 || idx_list.any(it > 5) {
		return none
	}
	return idx_list
}

fn yn_question(message string) ?bool {
	mut y_or_n := false
	outer: for {
		input := read_line('$message (y/n) ')?
		if input.trim('\n') == 'y' {
			y_or_n = true
			break
		} else if input.trim('\n') == 'n' {
			y_or_n = false
			break
		} else {
			println('-- please select `y` or `n`')
			continue outer
		}
	}
	return y_or_n
}

fn (player Player) show_change_hand(discard_cards []card.Card) []string {
	mut hands_str := []string{}
	for c in player.hand.cards {
		hands_str << if discard_cards.contains(c) {
			' $c.card_num() '
		} else {
			'[$c.card_num()]'
		}
	}
	return hands_str
}

fn print_hands(discard_cards []card.Card, player Player) {
	prefix := match player {
		Me { '-- My hands' }
		Enemy { "-- Enemy's hands" }
		else { "-- No player's hands" }
	}
	println('$prefix: ${player.show_change_hand(discard_cards)}')
}

fn judge(me Player, enemy Player) {
	println('')
	println('***** RESULT *****')
	print_hands([], me)
	print_hands([], enemy)

	println("***** $me.name's poker hands is $me.result.rank.to_string(), and the strongest card is $me.result.strongest_card.card_num() *****")
	println("***** $enemy.name's poker hands is $enemy.result.rank.to_string(), and the strongest card is $enemy.result.strongest_card.card_num() *****")

	if int(me.result.rank) > int(enemy.result.rank) {
		println("***** $me.name's win *****")
	} else if int(me.result.rank) < int(enemy.result.rank) {
		println("***** $enemy.name's win *****")
	} else {
		if me.result.strongest_card.num > enemy.result.strongest_card.num {
			println("***** $me.name's win *****")
		} else if me.result.strongest_card.num < enemy.result.strongest_card.num {
			println("***** $enemy.name's win *****")
		} else {
			println('***** draw *****')
		}
	}
}

fn (mut me Me) play_turn(mut deck Deck) ?PokerHand {
	mut poker_hand := PokerHand{}
	outer: for {
		print_hands([], me)
		discard_cards := select_disuse_cards(me.hand.cards)?

		print_hands(discard_cards, me)
		y_or_n := yn_question('-- really?')?
		if y_or_n {
			me.change_cards(discard_cards, mut deck)?
			print_hands([], me)
			poker_hand = make_poker_hand(me.hand)
		} else {
			continue outer
		}
		break
	}
	return poker_hand
}

fn (mut me Me) change_cards(discard_cards []card.Card, mut deck Deck) ? {
	addtional_hands := deck.draw_hand(discard_cards.len)?
	new_hands := me.hand.change_hands(discard_cards, addtional_hands.cards)?
	me.hand = new_hands
}

fn (mut enemy Enemy) play_turn(mut deck Deck) ?PokerHand {
	print_hands([], enemy)
	discard_cards := auto_disuse_cards(enemy.hand)

	print_hands(discard_cards, enemy)
	enemy.change_cards(discard_cards, mut deck)?

	print_hands([], enemy)
	poker_hand := make_poker_hand(enemy.hand)

	return poker_hand
}

fn (mut enemy Enemy) change_cards(discard_cards []card.Card, mut deck Deck) ? {
	addtional_hands := deck.draw_hand(discard_cards.len)?
	new_hands := enemy.hand.change_hands(discard_cards, addtional_hands.cards)?
	enemy.hand = new_hands
}

pub fn start(mut deck Deck) ? {
	println('------------------')
	println('-- simple poker --')
	println('------------------')

	// my turn
	my_hand := deck.draw_hand(5)?
	mut me := Me{
		name: 'player'
		hand: my_hand
	}
	me.result = me.play_turn(mut deck)?

	// enemy's turn
	enemy_hand := deck.draw_hand(5)?
	mut enemy := Enemy{
		name: 'computer'
		hand: enemy_hand
	}
	enemy.result = enemy.play_turn(mut deck)?

	judge(me, enemy)
}
