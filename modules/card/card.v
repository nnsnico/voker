module card

pub enum Suit {
	heart
	diamond
	club
	spade
}

const all_suit = [Suit.heart, Suit.diamond, Suit.club, Suit.spade]

pub struct Card {
pub:
	num  int
	suit Suit
}

pub fn all_cards() []Card {
	mut tmp := []Card{}
	for num in 2 .. 15 {
		for suit in all_suit {
			tmp << Card {num, suit}
		}
	}
	return tmp
}

pub fn all_str_cards() []string {
	return all_cards().map(it.card_num())
}

pub fn (card &Card) card_num() string {
	return match card.suit {
		.heart { 'H${show_card_number(card.num)}' }
		.diamond { 'D${show_card_number(card.num)}' }
		.club { 'C${show_card_number(card.num)}' }
		.spade { 'S${show_card_number(card.num)}' }
	}
}

pub fn (card &Card) card_strength() int {
	return card.num
}

// TODO: merge sort with card.num
pub fn (mut cards []Card) sort() []Card {
	mut tmp := []Card{}
	mut center := cards.len / 2

	return cards
}

fn show_card_number(i int) string {
	return match i {
		14 { 'A_' }
		13 { 'K_' }
		12 { 'Q_' }
		11 { 'J_' }
		10 { '10' }
		else { '${i}_' }
	}
}
