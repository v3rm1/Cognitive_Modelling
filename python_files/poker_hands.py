from collections import defaultdict
import math

def nCr(n,r):
    f = math.factorial
    return f(n) // f(r) // f(n-r)

card_order_dict = {"2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7,
                   "8": 8, "9": 9, "T": 10, "J": 11, "Q": 12, "K": 13, "A": 14}


def check_straight_flush(hand):
    if check_flush(hand) and check_straight(hand):
        return True
    else:
        return False


def check_four_of_a_kind(hand):
    values = [i[0] for i in hand]
    value_counts = defaultdict(lambda: 0)
    for v in values:
        value_counts[v] += 1
    if sorted(value_counts.values()) == [1, 4]:
        return True
    return False


def check_full_house(hand):
    values = [i[0] for i in hand]
    value_counts = defaultdict(lambda: 0)
    for v in values:
        value_counts[v] += 1
    if sorted(value_counts.values()) == [2, 3]:
        return True
    return False


def check_flush(hand):
    suits = [i[1] for i in hand]
    if len(set(suits)) == 1:
        return True
    else:
        return False


def check_straight(hand):
    values = [i[0] for i in hand]
    value_counts = defaultdict(lambda: 0)
    for v in values:
        value_counts[v] += 1
    rank_values = [card_order_dict[i] for i in values]
    value_range = max(rank_values) - min(rank_values)
    if len(set(value_counts.values())) == 1 and (value_range == 4):
        return True
    else:
        # check straight with low Ace
        if set(values) == set(["A", "2", "3", "4", "5"]):
            return True
        return False


def check_three_of_a_kind(hand):
    values = [i[0] for i in hand]
    value_counts = defaultdict(lambda: 0)
    for v in values:
        value_counts[v] += 1
    if set(value_counts.values()) == set([3, 1]):
        return True
    else:
        return False


def check_two_pairs(hand):
    values = [i[0] for i in hand]
    value_counts = defaultdict(lambda: 0)
    for v in values:
        value_counts[v] += 1
    if sorted(value_counts.values()) == [1, 2, 2]:
        return True
    else:
        return False


def check_one_pairs(hand):
    values = [i[0] for i in hand]
    value_counts = defaultdict(lambda: 0)
    for v in values:
        value_counts[v] += 1
    if 2 in value_counts.values():
        return True
    else:
        return False

def check_hand(hand):
    if check_straight_flush(hand):
        return 9
    if check_four_of_a_kind(hand):
        return 8
    if check_full_house(hand):
        return 7
    if check_flush(hand):
        return 6
    if check_straight(hand):
        return 5
    if check_three_of_a_kind(hand):
        return 4
    if check_two_pairs(hand):
        return 3
    if check_one_pairs(hand):
        return 2
    return 1


#TODO: Evaluate 5
#TODO: Evaluate 1

# The play function to check best move based on top 5 cards of deck

hand_dict = {9:"straight-flush", 8:"four-of-a-kind", 7:"full-house", 6:"flush", 5:"straight", 4:"three-of-a-kind", 3:"two-pairs", 2:"one-pair", 1:"highest-card"}

# Odds against improving 4 good cards
def improve_four(current_deck_size):
    draw_one = nCr(current_deck_size, 1)
    to_full_house = (draw_one - 4) / 4
    to_flush = (draw_one - 9) / 9
    straight_two_end = (draw_one - 8) / 8
    straight_inside = (draw_one - 4) / 4
    total_favourable = (to_full_house + to_flush + straight_two_end + straight_inside)
    return total_favourable

# Odds against improving 3 good cards
def improve_three(current_deck_size):
    draw_two = nCr(current_deck_size, 2)
    four_kind_odds = ((nCr(2,1) * nCr(3,1)) + (nCr(4,1) * nCr(10,1)))
    full_house_odds = (nCr(2, 1) * nCr(3, 2))
    new_pair_odds = (nCr(10,1) * nCr(4,2))
    good_odds = four_kind_odds + full_house_odds + new_pair_odds
    total_favourable = (draw_two - good_odds) / good_odds 
    return total_favourable

# Odds against improving 2 good cards
def improve_two(current_deck_size):
    draw_three = nCr(current_deck_size, 3)
    four_kind_odds = current_deck_size - 2
    three_kind_odds = nCr(2,1) * (nCr(3,2) * nCr(3,1) * nCr(3,1) + nCr(9,2) * nCr(4,1) * nCr(4,1) + nCr(9,1) * nCr(4,1) * nCr(3,1) * nCr(3,1))
    two_pair_odds = (nCr(9,1) * nCr(4,2) * nCr(41,1)) + (nCr(3,1) * nCr(3,2) * nCr(42,1))
    full_house_odds = (nCr(9,1) * nCr(4,3)) + (nCr(3,1) * nCr(3,3)) + nCr(2,1) * (nCr(9,1) * nCr(4,2) + nCr(3,1) * nCr(3,2))
    good_odds = four_kind_odds + three_kind_odds + two_pair_odds + full_house_odds
    total_favourable = (draw_three - good_odds) / good_odds 
    return total_favourable
   
