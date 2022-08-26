module main

import card
import poker
import rand

fn main() {
	println('------------------')
	println('-- simple poker --')
	println('------------------')

	mut deck := rand.shuffle_clone(card.all_cards())?
	hand := poker.to_hand(&deck[..5])?
	println(deck)
	println(hand)
}
