//
//  PlayingCard.h
//  machismo
//
//  Created by will hunting on 5/11/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic, copy)NSString* suit;
@property (nonatomic)int rank;

+ (NSUInteger)maxRank;
+ (NSArray*)validSuits;

@end
