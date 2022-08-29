module poker

import rand
import card

struct Deck {
mut:
	remaining_cards []card.Card = card.all_cards()
}

struct Hand {
pub:
	cards []card.Card
}

fn to_hand(cards []card.Card) Hand {
	mut c := cards.clone()
	c.sort(a.num < b.num)
	return Hand{c}
}

fn (hand Hand) drop_cards(discard_hands []card.Card) []card.Card {
	return hand.cards.filter(!discard_hands.contains(it))
}

pub fn setup_deck() ?Deck {
	deck := Deck{}
	shuffled_deck := rand.shuffle_clone(deck.remaining_cards)?
	return Deck{
		remaining_cards: shuffled_deck
	}
}

pub fn (mut deck Deck) draw_hand(num_of_cards int) ?Hand {
	drawed_cards := deck.remaining_cards[..num_of_cards]
	deck.remaining_cards.drop(num_of_cards)
	return to_hand(drawed_cards)
}

pub fn (deck &Deck) get_remaining_cards() []card.Card {
	return deck.remaining_cards
}

pub fn (hand Hand) change_hands(discard_hands []card.Card, additional_cards []card.Card) ?Hand {
	mut new_cards := hand.drop_cards(discard_hands)
	new_cards << additional_cards
	return to_hand(new_cards)
}
