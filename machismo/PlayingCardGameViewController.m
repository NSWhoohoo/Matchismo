//
//  PlayingCardGameViewController.m
//  machismo
//
//  Created by will hunting on 5/12/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc]init];
}

- (int)gameMode
{
    return 2;
}

- (int)initCardNumber
{
    return 35;
}

- (NSString *)gameType
{
    return @"PlayingCard";
}

- (NSArray *)getCardViewNumber:(int)number
{
    NSMutableArray* cards = [[NSMutableArray alloc]init];
    for (int i = 0; i < number; i++) {
        PlayingCardView* card = [[PlayingCardView alloc]init];
        [cards addObject:card];
    }
    return [cards copy];
}

- (void)updateCardView:(UIView *)cardView withCard:(Card *)card
{
    PlayingCardView* view = (PlayingCardView *)cardView;
    PlayingCard* playingCard = (PlayingCard *)card;
    view.rank = playingCard.rank;
    view.suit = playingCard.suit;
    if (view.faceUp != playingCard.chosen) {
        [UIView transitionWithView:view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            view.faceUp = playingCard.chosen;
        } completion:nil];
    }
    if (card.isMatched) {
        view.alpha = 0.5;
        view.userInteractionEnabled = NO;
    }
}

@end
