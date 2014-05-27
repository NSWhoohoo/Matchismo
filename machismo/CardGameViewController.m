//
//  CardGameViewController.m
//  machismo
//
//  Created by will hunting on 4/15/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cards;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic, strong)CardMatchingGame* game;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControl;
@property (weak, nonatomic) IBOutlet UILabel *matchingDescLabel;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc]initWithDeck:[self createDeck] andNumber:self.cards.count];
    }
    return _game;
}

- (Deck*)createDeck  // abstract
{
    return nil;
}

-(void)updateUI
{
    for (UIButton* button in self.cards) {
        NSUInteger cardIndex = [self.cards indexOfObject:button];
        Card* card = [self.game cardAtIndex:cardIndex];
        [button setTitle:[self titleofCard:card] forState:UIControlStateNormal] ;
        [button setBackgroundImage:[self backgroundOfCard:card] forState:UIControlStateNormal];
        button.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    [self updateTouchCardMatchingDescription];
}

- (void)updateTouchCardMatchingDescription
{
        if (self.game.cardMatchingScore > 0) {  // find a match
            self.matchingDescLabel.text = [NSString stringWithFormat:@"Matched %@ for %d points", [self getMatchingCardsContent], self.game.cardMatchingScore];
        } else if (self.game.cardMatchingScore < 0) {  // did not match
            self.matchingDescLabel.text = [NSString stringWithFormat:@"%@ don't match! %d points penalty", [self getMatchingCardsContent], -self.game.cardMatchingScore];
        } else {  // not enough card to perform a match
            self.matchingDescLabel.text = [self getMatchingCardsContent];
        }
}

- (NSString*)getMatchingCardsContent
{
    NSMutableArray* cardsArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.game.cardsTryMatching.count; i++) {
        NSString* cardContent = [self.game.cardsTryMatching[i] content];
        [cardsArr addObject:cardContent];
    }
    return [cardsArr componentsJoinedByString:@" "];
}

- (IBAction)tap:(UIButton *)sender {
    self.modeControl.enabled = NO;
    self.game.mode = self.modeControl.selectedSegmentIndex+2;
    NSUInteger index = [self.cards indexOfObject:sender];
    [self.game chooseCardAtIndex:index];
    [self updateUI];
}

- (IBAction)redeal:(UIButton *)sender {
    self.game = nil;
    self.modeControl.enabled = YES;
    [self updateUI];
}
    
- (NSString*)titleofCard:(Card*)card
{
    return (card.isChosen) ? card.content : @"";
}

- (UIImage*)backgroundOfCard:(Card*)card
{
    return [UIImage imageNamed:(card.isChosen ? @"cardfront" : @"cardback")];
}

@end
