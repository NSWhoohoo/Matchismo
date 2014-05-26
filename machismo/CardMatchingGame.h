//
//  CardMatchingGame.h
//  machismo
//
//  Created by will hunting on 5/11/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (nonatomic, readonly)int score;
@property (nonatomic, readonly)int cardMatchingScore;
@property (nonatomic)int mode;
- (instancetype)initWithDeck:(Deck*)deck andNumber:(NSUInteger)number;
- (NSArray*)cardsTryMatching;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card*)cardAtIndex:(NSUInteger)index;

@end
