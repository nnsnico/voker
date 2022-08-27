module main

import poker

fn main() {
	mut deck := poker.setup_deck()?
	poker.start(mut deck)?
}
