module poker

import arrays
import card

enum HandRanking {
	high_card
	one_pair
	two_pair
	three_of_a_kind
	straight
	flush
	full_house
	four_of_a_kind
	straight_flush
}

pub struct PokerHand {
pub:
	rank           HandRanking
	strongest_card card.Card
}

fn n_of_kind_hint(n int, hand Hand) [][]card.Card {
	list := arrays.group_by<int, card.Card>(hand.cards, fn (card card.Card) int {
		return card.num
	}).values().filter(it.len == n)
	return list
}

fn check_one_pair(hand Hand) ?PokerHand {
	pair_list := n_of_kind_hint(2, hand)
	return if pair_list.len == 0 {
		none
	} else {
		PokerHand{.one_pair, arrays.flatten(pair_list).last()}
	}
}

fn check_two_pair(hand Hand) ?PokerHand {
	pair_list := n_of_kind_hint(2, hand)
	return if pair_list.len == 2 {
		PokerHand{.two_pair, arrays.flatten(pair_list).last()}
	} else {
		none
	}
}

fn check_three_of_a_kind(hand Hand) ?PokerHand {
	pair_list := n_of_kind_hint(3, hand)
	return if pair_list.len == 0 {
		none
	} else {
		PokerHand{.three_of_a_kind, arrays.flatten(pair_list).last()}
	}
}

fn check_straight(hand Hand) ?PokerHand {
	nums := hand.cards.map(it.num)
	mut expect := []int{}
	for i in nums[0] .. nums[0] + 5 {
		expect << i
	}
	return if nums == expect {
		PokerHand{.straight, hand.cards.last()}
	} else {
		none
	}
}

fn check_flush(hand Hand) ?PokerHand {
	return if hand.cards.all(hand.cards[0].suit == it.suit) {
		PokerHand{.flush, hand.cards.last()}
	} else {
		none
	}
}

fn check_full_house(hand Hand) ?PokerHand {
	three_of_a_kind := n_of_kind_hint(3, hand)
	one_pair := n_of_kind_hint(2, hand)
	return if three_of_a_kind.len == 1 && one_pair.len == 1 {
		PokerHand{.full_house, hand.cards.last()}
	} else {
		none
	}
}

fn check_four_of_a_kind(hand Hand) ?PokerHand {
	four_of_a_kind := n_of_kind_hint(4, hand)
	return if four_of_a_kind.len == 0 {
		none
	} else {
		PokerHand{.four_of_a_kind, arrays.flatten(four_of_a_kind).last()}
	}
}

fn check_straight_flush(hand Hand) ?PokerHand {
	check_straight(hand)?
	check_flush(hand)?
	return PokerHand{.straight_flush, hand.cards.last()}
}

pub fn make_poker_hand(hand Hand) PokerHand {
	poker_hand := check_straight_flush(hand) or {
		check_four_of_a_kind(hand) or {
			check_full_house(hand) or {
				check_flush(hand) or {
					check_straight(hand) or {
						check_three_of_a_kind(hand) or {
							check_two_pair(hand) or {
								check_one_pair(hand) or { PokerHand{.high_card, hand.cards.last()} }
							}
						}
					}
				}
			}
		}
	}
	return poker_hand
}

pub fn auto_disuse_cards(hand Hand) []card.Card {
	mut n_of_kind := []card.Card{}
	n_of_kind << arrays.flatten(n_of_kind_hint(2, hand))
	n_of_kind << arrays.flatten(n_of_kind_hint(3, hand))
	n_of_kind << arrays.flatten(n_of_kind_hint(4, hand))

	return hand.cards.filter(it !in n_of_kind)
}
