//
//  SetPlayingCardGameViewController.m
//  machismo
//
//  Created by Appleseed on 8/24/14.
//  Copyright (c) 2014 Appleseed. All rights reserved.
//

#import "SetPlayingCardGameViewController.h"

@interface SetPlayingCardGameViewController ()

@end

@implementation SetPlayingCardGameViewController

- (NSString *)symbolOfCard:(SetPlayingCard *)card
{
    if ([card.symbol isEqualToString:@"diamond"]) {
        return @"▲";
    } else if ([card.symbol isEqualToString:@"squiggle"]) {
        return @"●";
    } else if ([card.symbol isEqualToString:@"oval"]) {
        return @"■";
    }
    return nil;
}

- (UIColor *)colorOfCard:(SetPlayingCard *)card
{
    if ([card.color isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if ([card.color isEqualToString:@"green"]) {
        return [UIColor greenColor];
    } else if ([card.color isEqualToString:@"purple"]) {
        return [UIColor purpleColor];
    }
    return nil;
}

- (NSNumber *)shadingOfCard:(SetPlayingCard *)card
{
    if ([card.shading isEqualToString:@"solid"]) {
        return @1;
    } else if ([card.shading isEqualToString:@"striped"]) {
        return @0.2;
    } else if ([card.shading isEqualToString:@"open"]) {
        return @0;
    }
    return nil;
}

- (Deck *)createDeck
{
    return [[SetPlayingCardDeck alloc]init];
}

- (int)gameMode
{
    return 3;
}

- (UIImage*)backgroundOfCard:(Card *)card
{
    return [UIImage imageNamed:(card.isChosen ? @"setcardchosen" : @"cardfront")];
}

- (NSAttributedString *)titleofCard:(Card *)card
{
    SetPlayingCard* setCard = (SetPlayingCard *)card;
    
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc]init];
    int number = setCard.number;
    for (int i = 0; i < number; i++) {
        [str.mutableString appendString:[self symbolOfCard:setCard]];
    }
    UIColor* color = [self colorOfCard:setCard];
    CGFloat alpha = [[self shadingOfCard:setCard] floatValue];
    [str setAttributes:@{NSForegroundColorAttributeName: [color colorWithAlphaComponent:alpha],
                         NSStrokeColorAttributeName: color,
                         NSStrokeWidthAttributeName: alpha < 0.01 ? @3 : @-3,
                         NSFontAttributeName: [UIFont systemFontOfSize:18]}
                 range:NSMakeRange(0, number)];
    
    return str;
}

- (NSAttributedString *)descriptionOfTryMatchingCards:(NSArray *)cards
{
    NSMutableAttributedString* desc = [[NSMutableAttributedString alloc]init];

    for (SetPlayingCard* card in cards) {
        [desc appendAttributedString:[self titleofCard:card]];
        if (card != [cards lastObject]) {
            NSAttributedString* str = [[NSAttributedString alloc]initWithString:@","];
            [desc appendAttributedString:str];
        }
    }
    return desc;
}



@end