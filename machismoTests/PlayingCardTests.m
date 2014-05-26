//
//  PlayingCardTests.m
//  machismo
//
//  Created by will hunting on 5/26/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PlayingCard.h"

@interface PlayingCardTests : XCTestCase

@end

@implementation PlayingCardTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPlayCardMatchMethod  // [1♥, 5♣, 7♣, 2♥]
{
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
    
    int point = [card1 match:@[card2, card3,card4]];
    XCTAssertEqual(point, 2, @"PlayingCard match method implemation error");
}

@end
