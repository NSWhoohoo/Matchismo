//
//  SetPlayingCard.m
//  machismo
//
//  Created by Appleseed on 8/24/14.
//  Copyright (c) 2014 Appleseed. All rights reserved.
//

#import "SetPlayingCard.h"

@implementation SetPlayingCard

+ (int)maxNumber
{
    return 3;
}

+ (NSArray *)validSymbol
{
    return @[@"diamond", @"squiggle", @"oval"];
}

+ (NSArray *)validShading
{
    return @[@"solid", @"striped", @"open"];
}

+ (NSArray *)validColor
{
    return @[@"red", @"green", @"purple"];
}

+ (NSArray *)features
{
    return @[@"number", @"symbol", @"shading", @"color"];
}

- (NSString *)content
{
    return nil;
}

- (int)match:(NSArray *)otherCards
{
    int score = 1;
    
    if (otherCards.count == 2) {
        for (NSString* feature in [SetPlayingCard features]) {
            if (![self match:otherCards inFeature:feature]) {
                score = 0;
                break;
            }
        }
    }
    
    return score;
}

- (BOOL)match:(NSArray *)otherCards inFeature:(NSString *)feature
{
    BOOL isMatch = NO;
    SetPlayingCard* card1 = [otherCards firstObject];
    SetPlayingCard* card2 = [otherCards lastObject];
    
        if ([self compare:card1 inFeature:feature]) {
            if ([self compare:card2 inFeature:feature]) {
                isMatch = true;
            }
        } else {
            if (![self compare:card2 inFeature:feature] && ![card1 compare:card2 inFeature:feature]) {
                isMatch = true;
            }
    }
    return isMatch;
}

- (BOOL)compare:(SetPlayingCard *)otherCard inFeature:(NSString *)feature
{
    id value1 = [self valueForKey:feature];
    id value2 = [otherCard valueForKey:feature];
    
    if ([value1 isKindOfClass:[NSNumber class]]) {
        return [value1 isEqualToNumber:value2];
    } else
        return [value1 isEqualToString:value2];
}

@end
