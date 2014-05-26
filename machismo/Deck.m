//
//  Deck.m
//  machismo
//
//  Created by will hunting on 5/11/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import "Deck.h"

@interface Deck ()
@property (nonatomic, strong)NSMutableArray* cards;  // of Card;
@end

@implementation Deck

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc]init];
    }
    return _cards;
}

- (void)addCard:(Card *)card
{
    [self.cards addObject:card];
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop
{
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    } else {
        [self addCard:card];
    }
}

- (Card *)drawRandomCard
{
    Card* card = nil;
    
    if (self.cards.count) {
        int index = arc4random() % self.cards.count;
        card = self.cards[index];
        [self.cards removeObject:card];
    }
    
    return card;
}

- (Card *)drawCardFromTop
{
    Card* card = nil;
    
    if (self.cards.count) {
        card = [self.cards firstObject];
        [self.cards removeObject:card];
    }
    
    return card;
}

@end
