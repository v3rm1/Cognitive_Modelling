import poker_hands as ph
def main(hand, table):
    current_deck = 52 - (len(hand) * 2) - len(table)
    hand_value = ph.check_hand(hand)
    if hand_value == 9:
        return("Straight flush", 0)
    if hand_value == 8:
        improvement = ph.improve_four(current_deck)
        return("Four of a kind", improvement)
    if hand_value == 7:
        improvement = (ph.improve_four(current_deck) + ph.improve_three(current_deck)) / 2
        return("Full house", improvement)
    if hand_value == 6:
        improvement = (ph.improve_four(current_deck) + ph.improve_three(current_deck) + ph.improve_two(current_deck)) / 3
        return("Flush", improvement)
    if hand_value == 5:
        improvement = ph.improve_four(current_deck)
        return("Straight", improvement)
    if hand_value == 4:
        improvement = (ph.improve_four(current_deck) + ph.improve_three(current_deck)) / 2
        return("Three of a kind", improvement)
    if hand_value == 3:
        improvement = (ph.improve_four(current_deck) + ph.improve_three(current_deck) + ph.improve_two(current_deck)) / 3
        return("Two pairs", improvement)
    if hand_value == 2:
        improvement = (ph.improve_four(current_deck) + ph.improve_three(current_deck) + ph.improve_two(current_deck)) / 3
        return("One pair", improvement)
    else:
        improvement = (ph.improve_four(current_deck) + ph.improve_three(current_deck) + ph.improve_two(current_deck)) / 3
        return("High card", improvement)
    
if __name__=="__main__":
    # hand = ['Js', 'Ts', '9s', '8s', '7s']
    hand = ['6s', '6d', '6h', 'Kh', '6c']
    table=[]
    hand_std, improvement_odds = main(hand, table)
    print(hand_std)
    print(improvement_odds)