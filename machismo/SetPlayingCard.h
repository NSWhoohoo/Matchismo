//
//  SetPlayingCard.h
//  machismo
//
//  Created by Appleseed on 8/24/14.
//  Copyright (c) 2014 Appleseed. All rights reserved.
//

#import "Card.h"

@interface SetPlayingCard : Card

@property (nonatomic)int number;
@property (nonatomic, copy)NSString* symbol;
@property (nonatomic, copy)NSString* shading;
@property (nonatomic, copy)NSString* color;

+ (int)maxNumber;
+ (NSArray *)validSymbol;
+ (NSArray *)validShading;
+ (NSArray *)validColor;

@end
