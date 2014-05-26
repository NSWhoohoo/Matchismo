//
//  Card.h
//  machismo
//
//  Created by will hunting on 5/11/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, copy)NSString* content;
@property (nonatomic, getter = isMatched)BOOL matched;
@property (nonatomic, getter = isChosen)BOOL chosen;

- (int)match:(NSArray*)otherCards;
- (void)turnToUnchosen;
- (void)turnToMatch;

@end
