//
//  PlayingCardDeck.m
//  machismo
//
//  Created by will hunting on 5/11/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

- (instancetype)init
{
    self = [super init];
    if (self) {
        for (int i = 1; i <= [PlayingCard maxRank]; i++) {
            for (NSString* suit in [PlayingCard validSuits]) {
                PlayingCard* card = [[PlayingCard alloc]init];
                card.suit = suit;
                card.rank = i;
                [self addCard:card];
            }
        }
    }
    return self;
}

@end
