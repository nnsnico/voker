module poker

import card

const high_cards_hands = to_hand([
	card.Card{2, .spade},
	card.Card{3, .heart},
	card.Card{9, .club},
	card.Card{8, .spade},
	card.Card{5, .spade},
])

const one_pair_hands = to_hand([
	card.Card{2, .spade},
	card.Card{2, .spade},
	card.Card{3, .club},
	card.Card{4, .spade},
	card.Card{5, .spade},
])

const two_pair_hands = to_hand([
	card.Card{2, .spade},
	card.Card{2, .spade},
	card.Card{3, .club},
	card.Card{3, .spade},
	card.Card{5, .spade},
])

const three_of_a_kind_hands = to_hand([
	card.Card{2, .spade},
	card.Card{2, .spade},
	card.Card{2, .club},
	card.Card{3, .spade},
	card.Card{5, .spade},
])

const straight_hands = to_hand([
	card.Card{1, .spade},
	card.Card{2, .spade},
	card.Card{3, .spade},
	card.Card{4, .club},
	card.Card{5, .spade},
])

const flush_hands = to_hand([
	card.Card{3, .spade},
	card.Card{2, .spade},
	card.Card{4, .spade},
	card.Card{12, .spade},
	card.Card{5, .spade},
])

const full_house_hands = to_hand([
	card.Card{3, .heart},
	card.Card{2, .spade},
	card.Card{3, .club},
	card.Card{2, .spade},
	card.Card{3, .spade},
])

const four_of_a_kind_hands = to_hand([
	card.Card{3, .heart},
	card.Card{3, .spade},
	card.Card{3, .club},
	card.Card{2, .spade},
	card.Card{3, .spade},
])

const straight_flush_hands = to_hand([
	card.Card{1, .spade},
	card.Card{2, .spade},
	card.Card{3, .spade},
	card.Card{4, .spade},
	card.Card{5, .spade},
])

fn test_check_one_pair() ? {
	mut result := check_one_pair(poker.one_pair_hands)?

	assert result.rank == .one_pair
	assert result.strongest_card == card.Card{2, .spade}
}

fn test_check_two_pair() ? {
	mut result := check_two_pair(poker.two_pair_hands)?

	assert result.rank == .two_pair
	assert result.strongest_card == card.Card{3, .club}
}

fn test_check_three_of_a_kind() ? {
	mut result := check_three_of_a_kind(poker.three_of_a_kind_hands)?

	assert result.rank == .three_of_a_kind
	assert result.strongest_card == card.Card{2, .spade}
}

fn test_check_straight() ? {
	mut result := check_straight(poker.straight_hands)?

	assert result.rank == .straight
	assert result.strongest_card == card.Card{5, .spade}
}

fn test_check_flush() ? {
	mut result := check_flush(poker.flush_hands)?

	assert result.rank == .flush
	assert result.strongest_card == card.Card{12, .spade}
}

fn test_check_full_house() ? {
	mut result := check_full_house(poker.full_house_hands)?

	assert result.rank == .full_house
	assert result.strongest_card == card.Card{3, .heart}
}

fn test_check_four_of_a_kind() ? {
	mut result := check_four_of_a_kind(poker.four_of_a_kind_hands)?

	assert result.rank == .four_of_a_kind
	assert result.strongest_card == card.Card{3, .heart}
}

fn test_check_straight_flush() ? {
	mut result := check_straight_flush(poker.straight_flush_hands)?

	assert result.rank == .straight_flush
	assert result.strongest_card == card.Card{5, .spade}
}

fn test_check_make_poker_hand() ? {
	mut result := make_poker_hand(poker.straight_flush_hands)

	assert result.rank == .straight_flush
	assert result.strongest_card == card.Card{5, .spade}

	result = check_one_pair(poker.one_pair_hands)?
	assert result.rank == .one_pair
	assert result.strongest_card == card.Card{2, .spade}
}
