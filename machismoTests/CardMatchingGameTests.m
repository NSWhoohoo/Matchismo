//
//  CardMatchingGameTests.m
//  machismo
//
//  Created by will hunting on 5/26/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CardMatchingGame.h"
#import "PlayingCard.h"

@interface CardMatchingGameTests : XCTestCase
@property (nonatomic, strong)CardMatchingGame* game;
@end

@implementation CardMatchingGameTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    /// [1♥, 5♣, 7♣, 2♥]   [@"♣︎", @"♥︎", @"♦︎", @"♠︎"]
    /// create game from the deck above
    PlayingCard* card1 = [[PlayingCard alloc]init];
    card1.suit = @"♥︎";
    card1.rank = 1;
    
    PlayingCard* card2 = [[PlayingCard alloc]init];
    card2.suit = @"♣︎";
    card2.rank = 5;
    
    PlayingCard* card3 = [[PlayingCard alloc]init];
    card3.suit = @"♣︎";
    card3.rank = 7;
    
    PlayingCard* card4 = [[PlayingCard alloc]init];
    card4.suit = @"♥︎";
    card4.rank = 2;
    
    PlayingCard* card5 = [[PlayingCard alloc]init];
    card5.suit = @"♦︎";
    card5.rank = 8;
    
    Deck* deck = [[Deck alloc]init];
    [deck addCard:card1];
    [deck addCard:card2];
    [deck addCard:card3];
    [deck addCard:card4];
    [deck addCard:card5];
    
    self.game = [[CardMatchingGame alloc]initWithDeck:deck andNumber:5];
    self.game.mode = 3;
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
    XCTAssertEqualObjects(card.content, @"A♥︎", @"chosen wrong card");
    
    NSArray* cardArray = self.game.cardsTryMatching;
    XCTAssertEqualObjects(cardArray, @[card], @"invalid cardsTryMatching");

    XCTAssertTrue(card.isChosen, @"card is not chosen");
}

- (void)testChooseSecondCard
{
    [self.game chooseCardAtIndex:0];
    [self.game chooseCardAtIndex:1];
    XCTAssertEqual(self.game.score, -2, @"wrong score");
    XCTAssertEqual(self.game.cardMatchingScore, 0, @"wrong matching score");
    Card* card0 = [self.game cardAtIndex:0];
    Card* card1 = [self.game cardAtIndex:1];
    XCTAssertEqualObjects(card1.content, @"5♣︎", @"chosen wrong card");
    
    NSArray* cardArray = self.game.cardsTryMatching;
    XCTAssertEqualObjects([cardArray firstObject], card0, @"invalid cardsTryMatching");
    XCTAssertEqualObjects([cardArray lastObject], card1, @"invalid cardsTryMatching");
    
    XCTAssertTrue(card0.isChosen, @"card is not chosen");
    XCTAssertTrue(card1.isChosen, @"card is not chosen");
}

- (void)testChooseThirdCardAndMatched
{
    [self.game chooseCardAtIndex:0];
    [self.game chooseCardAtIndex:1];
    [self.game chooseCardAtIndex:2];
    XCTAssertEqual(self.game.score, -3 + 4, @"wrong score");
    XCTAssertEqual(self.game.cardMatchingScore, 4, @"wrong matching score");
    Card* card0 = [self.game cardAtIndex:0];
    Card* card1 = [self.game cardAtIndex:1];
    Card* card2 = [self.game cardAtIndex:2];
    XCTAssertEqualObjects(card2.content, @"7♣︎", @"chosen wrong card");
    
    NSArray* cardArray = self.game.cardsTryMatching;
    XCTAssertEqualObjects([cardArray firstObject], card0, @"invalid cardsTryMatching");
    XCTAssertEqualObjects(cardArray[1], card1, @"invalid cardsTryMatching");
    XCTAssertEqualObjects([cardArray lastObject], card2, @"invalid cardsTryMatching");
    
    XCTAssertTrue(card0.isChosen, @"card is not chosen");
    XCTAssertTrue(card1.isChosen, @"card is not chosen");
    XCTAssertTrue(card2.isChosen, @"card is not chosen");
    XCTAssertTrue(card0.isMatched, @"card is not chosen");
    XCTAssertTrue(card1.isMatched, @"card is not chosen");
    XCTAssertTrue(card2.isMatched, @"card is not chosen");
}

- (void)testChooseThirdCardButNoMatch
{
    [self.game chooseCardAtIndex:0];
    [self.game chooseCardAtIndex:1];
    [self.game chooseCardAtIndex:4];
    XCTAssertEqual(self.game.score, -2-1-2, @"wrong score");
    XCTAssertEqual(self.game.cardMatchingScore, -2, @"wrong matching score");
    Card* card0 = [self.game cardAtIndex:0];
    Card* card1 = [self.game cardAtIndex:1];
    Card* card2 = [self.game cardAtIndex:4];
    XCTAssertEqualObjects(card2.content, @"8♦︎", @"chosen wrong card");
    
    NSArray* cardArray = self.game.cardsTryMatching;
    XCTAssertEqualObjects([cardArray firstObject], card0, @"invalid cardsTryMatching");
    XCTAssertEqualObjects(cardArray[1], card1, @"invalid cardsTryMatching");
    XCTAssertEqualObjects([cardArray lastObject], card2, @"invalid cardsTryMatching");
    
    XCTAssertFalse(card0.isChosen, @"card should not be chosen");
    XCTAssertFalse(card1.isChosen, @"card should not be chosen");
    XCTAssertTrue(card2.isChosen, @"card should be chosen");
    XCTAssertFalse(card0.isMatched, @"card is not chosen");
    XCTAssertFalse(card1.isMatched, @"card is not chosen");
    XCTAssertFalse(card2.isMatched, @"card is not chosen");
}



@end
