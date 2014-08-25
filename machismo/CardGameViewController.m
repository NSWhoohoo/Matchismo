//
//  CardGameViewController.m
//  machismo
//
//  Created by will hunting on 4/15/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "CardGameViewController.h"
#import "GameHistoryViewController.h"
#import "CardMatchingGame.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cards;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic, strong)CardMatchingGame* game;
@property (weak, nonatomic) IBOutlet UILabel *matchingDescLabel;
@property (strong, nonatomic)NSMutableArray* historyDesc;

@end

@implementation CardGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc]initWithDeck:[self createDeck] andNumber:self.cards.count];
        _game.mode = [self gameMode];
    }
    return _game;
}

- (NSArray *)historyDesc
{
    if (!_historyDesc) {
        _historyDesc = [[NSMutableArray alloc]init];
    }
    return _historyDesc;
}

- (Deck*)createDeck  // abstract
{
    return nil;
}

- (int)gameMode  // abstract
{
    return 0;
}

-(void)updateUI
{
    for (UIButton* button in self.cards) {
        NSUInteger cardIndex = [self.cards indexOfObject:button];
        Card* card = [self.game cardAtIndex:cardIndex];
        [button setAttributedTitle:[self titleofCard:card] forState:UIControlStateNormal] ;
        [button setBackgroundImage:[self backgroundOfCard:card] forState:UIControlStateNormal];
        button.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    [self updateTouchCardMatchingDescription];
}

- (void)updateTouchCardMatchingDescription
{
    NSMutableAttributedString* desc;
    
    if (self.game.cardMatchingScore > 0) {  // find a match
        desc = [[NSMutableAttributedString alloc]initWithString:@"Matched "];
        [desc appendAttributedString:[self descriptionOfTryMatchingCards:self.game.cardsTryMatching]];
        [desc appendAttributedString:[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"for %d points!", self.game.cardMatchingScore]]];
        [self.historyDesc addObject:desc];
    } else if (self.game.cardMatchingScore < 0) {  // did not match
        desc = [[self descriptionOfTryMatchingCards:self.game.cardsTryMatching] mutableCopy];
        [desc appendAttributedString:[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"don't match! %d points penalty", -self.game.cardMatchingScore]]];
        // [desc.mutableString appendFormat:@"don't match! %d points penalty", -self.game.cardMatchingScore];
        [self.historyDesc addObject:desc];
    } else {  // not enough card to perform a match
        desc = [[self descriptionOfTryMatchingCards:self.game.cardsTryMatching] mutableCopy];
    }
    
    self.matchingDescLabel.attributedText = desc;
}

- (NSAttributedString *)descriptionOfTryMatchingCards:(NSArray *)cards
{
    NSString* desc = [cards componentsJoinedByString:@", "];
    return [[NSAttributedString alloc]initWithString:desc];
}

- (IBAction)tap:(UIButton *)sender {
    NSUInteger index = [self.cards indexOfObject:sender];
    [self.game chooseCardAtIndex:index];
    [self updateUI];
}

- (IBAction)redeal:(UIBarButtonItem *)sender {
    self.game = nil;
    [self updateUI];
}
    
- (NSAttributedString*)titleofCard:(Card*)card
{
    return (card.isChosen) ? [[NSAttributedString alloc]initWithString:card.content] : nil;
}

- (UIImage*)backgroundOfCard:(Card*)card
{
    return [UIImage imageNamed:(card.isChosen ? @"cardfront" : @"cardback")];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[GameHistoryViewController class]]) {
        GameHistoryViewController* historyVC = (GameHistoryViewController *)segue.destinationViewController;
        historyVC.results = [self.historyDesc copy];
    }
}

@end
