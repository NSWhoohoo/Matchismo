//
//  CardGameViewController.h
//  machismo
//
//  Created by will hunting on 4/15/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//  abstract class, must implement method as described below

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

// abstract
- (Deck*)createDeck;
- (int)gameMode;
- (int)initCardNumber;
- (void)updateCardView:(UIView *)cardView withCard:(Card *)card;
- (NSArray *)getCardViewNumber:(int)number;
- (NSString *)gameType;

// overridable
- (NSAttributedString*)titleofCard:(Card*)card;
- (NSAttributedString *)descriptionOfTryMatchingCards:(NSArray *)cards;
- (UIImage*)backgroundOfCard:(Card*)card;
- (BOOL)removeMatchedCards;

@end
