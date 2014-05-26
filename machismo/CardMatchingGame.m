//
//  CardMatchingGame.m
//  machismo
//
//  Created by will hunting on 5/11/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (nonatomic, readwrite)int score;
@property (nonatomic, readwrite)int cardMatchingScore;
@property (nonatomic, strong)NSMutableArray* cards; // of Card
@property (nonatomic, strong)NSMutableArray* cardsToMatch; // chosen but unmatched cards from chooseCardAtIndex before
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc]init];
    }
    return _cards;
}

- (NSMutableArray*)cardsToMatch
{
    if (!_cardsToMatch) {
        _cardsToMatch = [[NSMutableArray alloc]init];
    }
    return _cardsToMatch;
}

-(instancetype)initWithDeck:(Deck *)deck andNumber:(NSUInteger)number
{
    self = [super init];
    
    if (self) {
        for (int i = 1; i <= number; i++) {
#warning change to drawCardFromTop for testing, should be change to drawRandomCard eventually
            Card* card = [deck drawCardFromTop];
            if (card) {
                [self.cards addObject:card];
            } else {
                self.cards = nil;
            }
        }
    }

    return self;
}

#define MATCH_BONUS 4;
#define MISMATCH_PANELTY -2;
#define CHOOSE_COST 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    if (index >= self.cards.count) {
        return;
    }
    Card* card = self.cards[index];
    
    self.cardMatchingScore = 0;
    if (!card.isMatched) {
        if (card.isChosen) {  // flip back a card
            card.chosen = NO;
            [self.cardsToMatch removeObject:card];
        } else {  // flip over a card
            if (self.cardsToMatch.count == self.mode) {  // no cards to match
                [self.cardsToMatch removeAllObjects];
            } else if(self.cardsToMatch.count == self.mode-1){  // enough cards to try a match
                int matchingScore = [card match:self.cardsToMatch];
                if (matchingScore) {  // find match, all cards marked matched
                    self.cardMatchingScore = matchingScore*MATCH_BONUS;
                    card.matched = YES;
                    [self.cardsToMatch makeObjectsPerformSelector:@selector(turnToMatch)];
                } else {  // no match, flip back other cards
                    [self.cardsToMatch makeObjectsPerformSelector:@selector(turnToUnchosen)];
                    self.cardMatchingScore = MISMATCH_PANELTY;
                }
                self.score += self.cardMatchingScore;
                [self.cardsToMatch addObject:card];
            } else {  // not enough cards to try a match
                [self.cardsToMatch addObject:card];
            }
            card.chosen = YES;
            self.score -= CHOOSE_COST;
        }
    }
}


- (Card*)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

- (NSArray *)cardsTryMatching
{
    return [self.cardsToMatch copy];
}

@end
