module poker

import card

pub struct Hand {
	from_hand []card.Card
}

pub fn to_hand(mut cards []card.Card) ?Hand {
	return if cards.len == 5 {
		cards.sort()
		 Hand{cards}
	 } else {
		 error('Five or more cards in hand are specified.')
	 }
}
