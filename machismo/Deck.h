//
//  Deck.h
//  machismo
//
//  Created by will hunting on 5/11/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card*)card;
- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (Card*)drawRandomCard;
- (Card*)drawCardFromTop;   // for testing

@end
