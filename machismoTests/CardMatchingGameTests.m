//
//  CardMatchingGameTests.m
//  machismo
//
//  Created by will hunting on 5/26/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CardMatchingGame.h"

@interface CardMatchingGameTests : XCTestCase
@property (nonatomic, strong)CardMatchingGame* game;
@end

@implementation CardMatchingGameTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    /// [1♥, 5♣, 7♣, 2♥]
    /// create game from the deck above
    Card* card1 = [[Card alloc]init];
    card1.content = @"1♥︎";
    
    Card* card2 = [[Card alloc]init];
    card2.content = @"5♣︎";
    
    Card* card3 = [[Card alloc]init];
    card3.content = @"7♣︎";
    
    Card* card4 = [[Card alloc]init];
    card4.content = @"2♥︎";
    
    Deck* deck = [[Deck alloc]init];
    [deck addCard:card1];
    [deck addCard:card2];
    [deck addCard:card3];
    [deck addCard:card4];
    
    self.game = [[CardMatchingGame alloc]initWithDeck:deck andNumber:4];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testChooseCardAtIndexZero
{
    [self.game chooseCardAtIndex:0];
    XCTAssertEqual(self.game.score, -1, @"wrong score");
    XCTAssertEqual(self.game.cardMatchingScore, 0, @"wrong matching score");
    Card* card = [self.game cardAtIndex:0];
    XCTAssertEqualObjects(card.content, @"1♥︎", @"chosen wrong card");
    
    NSArray* cardArray = self.game.cardsTryMatching;
    XCTAssertEqualObjects(cardArray, @[card], @"invalid cardsTryMatching");

    XCTAssertTrue(card.isChosen, @"card is not chosen");
}



@end
