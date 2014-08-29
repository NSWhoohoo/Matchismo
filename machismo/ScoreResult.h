//
//  ScoreResult.h
//  machismo
//
//  Created by Appleseed on 8/28/14.
//  Copyright (c) 2014 Appleseed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreResult : NSObject

@property (nonatomic)int score;
@property (nonatomic, strong)NSDate* end;
@property (nonatomic, copy)NSString* gameType;
@property (nonatomic)NSTimeInterval duration;

+ (NSArray *)allResults;
+ (ScoreResult *)resultFromPropertyList:(NSDictionary *)plist;
- (NSComparisonResult)sortResultsByDate:(ScoreResult *)result;
- (NSComparisonResult)sortResultsByScore:(ScoreResult *)result;
- (NSComparisonResult)sortResultsByDuration:(ScoreResult *)result;

@end
