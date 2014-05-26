//
//  Card.m
//  machismo
//
//  Created by will hunting on 5/11/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card* card in otherCards) {
        if ([self.content isEqualToString:card.content]) {
            score++;
        }
    }
    
    return score;
}

- (void)turnToUnchosen
{
    self.chosen = NO;
}

- (void)turnToMatch
{

    self.matched = YES;
}

@end
