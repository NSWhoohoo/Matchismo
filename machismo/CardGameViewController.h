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

- (Deck*)createDeck;

@end
