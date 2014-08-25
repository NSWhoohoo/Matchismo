//
//  PlayingCardGameViewController.m
//  machismo
//
//  Created by will hunting on 5/12/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

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

@end
