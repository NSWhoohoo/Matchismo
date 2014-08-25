//
//  SetPlayingCardDedk.m
//  machismo
//
//  Created by Appleseed on 8/24/14.
//  Copyright (c) 2014 Appleseed. All rights reserved.
//

#import "SetPlayingCardDeck.h"

@implementation SetPlayingCardDeck

- (instancetype)init
{
    self = [super init];
    if (self) {
        for (int number = 1; number <= [SetPlayingCard maxNumber]; number++) {
            for (NSString* symbol in [SetPlayingCard validSymbol]) {
                for (NSString* shading in [SetPlayingCard validShading]) {
                    for (NSString* color in [SetPlayingCard validColor]) {
                        SetPlayingCard* setCard = [[SetPlayingCard alloc]init];
                        setCard.number = number;
                        setCard.symbol = symbol;
                        setCard.shading = shading;
                        setCard.color = color;
                        [self addCard:setCard];
                    }
                }
            }
        }
    }
    return self;
}

@end
