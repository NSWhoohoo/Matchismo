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
#import "Grid.h"

@interface CardGameViewController () <UIDynamicAnimatorDelegate>

@property (strong, nonatomic) NSMutableArray *cards;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic, strong)CardMatchingGame* game;
@property (weak, nonatomic) IBOutlet UILabel *matchingDescLabel;
@property (strong, nonatomic)NSMutableArray* historyDesc;
@property (strong, nonatomic)Grid* grid;
@property (strong, nonatomic)UIDynamicAnimator* animator;
@property (strong, nonatomic)NSMutableArray* attachmentLength;
@property (nonatomic)BOOL stacked;
@end

@implementation CardGameViewController

#pragma mark - abstract

- (Deck*)createDeck  // abstract
{
    return nil;
}

- (int)gameMode  // abstract
{
    return 0;
}

- (int)initCardNumber // abstract
{
    return 0;
}

- (void)updateCardView:(UIView *)cardView withCard:(Card *)card
{
}

- (NSArray *)getCardViewNumber:(int)number
{
    return nil;
}

#pragma mark - overridable
- (BOOL)removeMatchedCards
{
    return NO;
}

#pragma mark - lazy instantiation
- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc]initWithDeck:[self createDeck] andNumber:self.cards.count];
        _game.mode = [self gameMode];
    }
    return _game;
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc]init];
        _animator.delegate = self;
    }
    return _animator;
}

- (NSMutableArray *)attachmentLength
{
    if (!_attachmentLength) {
        _attachmentLength = [[NSMutableArray alloc]init];
    }
    return _attachmentLength;
}

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[self getCardViewNumber:[self initCardNumber]] mutableCopy];
        for (UIView* card in _cards) {
            [self.containerView addSubview:card];
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            [card addGestureRecognizer:tap];
        }
    }
    return _cards;
}

#pragma mark - animator delegate
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    self.animator = nil;
}

#pragma mark - inputs
- (IBAction)redeal:(UIButton *)sender {
    self.game = nil;
    [UIView animateWithDuration:1.0 animations:^{
        for (UIView* card in self.cards) {
            card.center = CGPointMake(0, self.view.bounds.size.height);
        }
    } completion:^(BOOL finished) {
        [self.cards makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.cards = nil;
        [self updateUI];
    }];
}

- (IBAction)deal:(UIButton *)sender {
    if ([self.game addCardsNumber:3]) {
        NSArray* arr = [self getCardViewNumber:3];
        [self.cards addObjectsFromArray:arr];
        for (UIView* view in arr) {
            [self.containerView addSubview:view];
        }
        [self updateUI];
    }
}
    
    
- (void)tap:(UITapGestureRecognizer *)sender {
    if (!_animator) {
        if (!self.stacked) {
            UIView* card = sender.view;
            NSUInteger index = [self.cards indexOfObject:card];
            [self.game chooseCardAtIndex:index];
            [self updateUI];
        }else {
            UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc] initWithItems:self.cards];
            item.resistance = 40.0;
            [self.animator addBehavior:item];
            for (int i = 0; i < self.cards.count; i++) {
                UIView* card = self.cards[i];
                card.center = self.containerView.center;
                CGPoint destination;
                int row = i / self.grid.columnCount;
                int column = i - row * (int)self.grid.columnCount;
                destination = [self.grid centerOfCellAtRow:row inColumn:column];
                UISnapBehavior* snap = [[UISnapBehavior alloc]initWithItem:card snapToPoint:destination];
                [self.animator addBehavior:snap];
                self.stacked = NO;
            }
        }
    }
}

- (void)pan:(UIPanGestureRecognizer *)sender {
    self.animator = nil;
    if (self.stacked) {
        CGPoint position = [sender locationInView:self.containerView];
        UIView* hitView = [self.containerView hitTest:position withEvent:nil];
        self.animator = nil;
        if ([self.cards containsObject:hitView]) {
            for (UIView* card in self.cards) {
                card.center = position;
            }
        }
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.animator = nil;
        for (UIView* card in self.cards) {
            UIAttachmentBehavior* attachment = [[UIAttachmentBehavior alloc]initWithItem:card attachedToAnchor:self.containerView.center];
            [self.attachmentLength addObject:@([self distanceBetween:self.containerView.center and:card.center])];
            [self.animator addBehavior:attachment];
        }
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        NSMutableArray* attachments = [[NSMutableArray alloc]init];
        for (UIDynamicBehavior* behavior in self.animator.behaviors) {
            if ([behavior isKindOfClass:[UIAttachmentBehavior class]]) {
                [attachments addObject:behavior];
            }
        }
        
        for (UIAttachmentBehavior* attach in attachments) {
            attach.length = attach.length * sender.scale;
        }
        for (int i = 0; i < attachments.count; i++) {
            UIAttachmentBehavior* attach = attachments[i];
            attach.length = [self.attachmentLength[i] floatValue] * sender.scale;
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        self.animator = nil;
        UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc] initWithItems:self.cards];
        item.allowsRotation = NO;
        [self.animator addBehavior:item];
        for (int i = 0; i < self.cards.count; i++) {
            UIView* card = self.cards[i];
            card.center = self.containerView.center;
            CGPoint destination;
            if (sender.velocity <= 0) {
                destination = self.containerView.center;
                self.stacked = YES;
            } else {
                int row = i / self.grid.columnCount;
                int column = i - row * (int)self.grid.columnCount;
                destination = [self.grid centerOfCellAtRow:row inColumn:column];
            }
            UISnapBehavior* snap = [[UISnapBehavior alloc]initWithItem:card snapToPoint:destination];
            [self.animator addBehavior:snap];
        }
        
    }
}

- (float) distanceBetween : (CGPoint) p1 and: (CGPoint)p2
{
    return sqrt(pow(p2.x-p1.x,2)+pow(p2.y-p1.y,2));
}

#pragma mark - outputs
-(void)updateUI
{
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    for (UIView* cardView in self.cards) {
        NSUInteger cardIndex = [self.cards indexOfObject:cardView];
        Card* card = [self.game cardAtIndex:cardIndex];
        if ([self removeMatchedCards] && card.isMatched) {
            [arr addObject:cardView];
            [cardView removeFromSuperview];
        }
        [self updateCardView:cardView withCard:card];
    }
    for (UIView* cardView in arr) {
        [self.cards removeObject:cardView];
    }
    [self layoutCards];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    [self updateTouchCardMatchingDescription];
}

#define CELL_ASPECT_RATION 4.0/6.0
- (void)layoutCards
{

    self.grid = [[Grid alloc]init];
    self.grid.size = self.containerView.bounds.size;
    self.grid.cellAspectRatio = CELL_ASPECT_RATION;
    self.grid.minimumNumberOfCells =  self.cards.count;
    
    if (self.grid.inputsAreValid) {
        for (int i = 0; i < self.cards.count; i++) {
            int row = i / self.grid.columnCount;
            int column = i - row * (int)self.grid.columnCount;
            UIView* card = [self.cards objectAtIndex:i];
            if (card.center.x == 0 && card.center.y == 0) {  // newly added cards
                card.center = CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height);
            }
            [UIView animateWithDuration:1.0 delay:i/10.0 options:0 animations:^{
                card.frame = [self.grid frameOfCellAtRow:row inColumn:column];
            } completion:nil];
        }
    } else{
        NSLog(@"Screen don't fit that much of cards");
    }

}

#pragma mark - viewcontroller lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cards = [[self getCardViewNumber:[self initCardNumber]] mutableCopy];
    for (UIView* card in _cards) {
        [self.containerView addSubview:card];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [card addGestureRecognizer:tap];
    }
    
    // pinch gesture to pile up cards
    UIPinchGestureRecognizer* pinchCards = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
    UIPanGestureRecognizer* panCards = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.containerView addGestureRecognizer:pinchCards];
    [self.containerView addGestureRecognizer:panCards];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [CATransaction setDisableActions:YES];
    [self updateUI];
    [CATransaction setDisableActions:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateUI];
}




#pragma mark - older code
- (NSArray *)historyDesc
{
    if (!_historyDesc) {
        _historyDesc = [[NSMutableArray alloc]init];
    }
    return _historyDesc;
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
