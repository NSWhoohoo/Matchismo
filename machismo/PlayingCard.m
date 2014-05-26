//
//  PlayingCard.m
//  machismo
//
//  Created by will hunting on 5/11/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard
@synthesize suit = _suit;

+ (NSArray*)validRanks
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"J", @"Q", @"K"];
}

+ (NSArray *)validSuits
{
    return @[@"♣︎", @"♥︎", @"♦︎", @"♠︎"];
}

+ (NSUInteger)maxRank
{
    return [self validRanks].count-1;
}

- (void)setRank:(int)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (NSString *)content
{
    return [NSString stringWithFormat:@"%@%@", [PlayingCard validRanks][self.rank], self.suit];
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if (otherCards.count == 1) {
        PlayingCard* card = [otherCards firstObject];
        if (card.rank == self.rank) {
            score = 4;
        } else if ([card.suit isEqualToString:self.suit]) {
            score = 1;
        }
    } else if (otherCards.count > 1) {
        for (PlayingCard* card in otherCards) score += [self match:@[card]];
        PlayingCard* card = [otherCards firstObject];
        score += [card match:[otherCards subarrayWithRange:NSMakeRange(1, otherCards.count-1)]];
    }
    
    return score;
}

@end
