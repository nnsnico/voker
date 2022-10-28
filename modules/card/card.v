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
	num  int  [required]
	suit Suit [required]
}

pub fn all_cards() []Card {
	mut tmp := []Card{}
	for num in 2 .. 15 {
		for suit in card.all_suit {
			tmp << Card{num, suit}
		}
	}
	return tmp
}

pub fn (card &Card) card_num() string {
	return match card.suit {
		.heart { '♡ ${show_card_number(card.num)}' }
		.diamond { '♢ ${show_card_number(card.num)}' }
		.club { '♧ ${show_card_number(card.num)}' }
		.spade { '♤ ${show_card_number(card.num)}' }
	}
}

fn show_card_number(i int) string {
	return match i {
		14 { 'A' }
		13 { 'K' }
		12 { 'Q' }
		11 { 'J' }
		10 { '10' }
		else { '$i' }
	}
}
