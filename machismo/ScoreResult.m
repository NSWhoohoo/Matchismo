//
//  ScoreResult.m
//  machismo
//
//  Created by Appleseed on 8/28/14.
//  Copyright (c) 2014 Appleseed. All rights reserved.
//

#import "ScoreResult.h"

#define ALLRESULTS @"all_results_key"
#define GAMETYPE @"game_type_key"
#define SCORE @"score_key"
#define START @"start_key"
#define END @"end_key"
#define DURATION @"duraton"

@interface ScoreResult ()

@property (nonatomic, strong)NSDate* start;

@end

@implementation ScoreResult


+ (NSArray *)allResults
{
    NSMutableArray* resultsArr = [[NSMutableArray alloc]init];
    NSDictionary* results = [[NSUserDefaults standardUserDefaults] objectForKey:ALLRESULTS];

    if (results) {
        for (NSString* key in [results allKeys]) {
            NSDictionary* result = results[key];
            [resultsArr addObject:[self resultFromPropertyList:result]];
        }
    }
    return [resultsArr copy];
}

+ (ScoreResult *)resultFromPropertyList:(NSDictionary *)plist
{
    ScoreResult* result = [[ScoreResult alloc]initWithPlist:plist];

    return result;
}

- (instancetype)initWithPlist:(NSDictionary *)plist
{
    self = [super init];
    if (self) {
        _gameType = plist[GAMETYPE];
        _score = [plist[SCORE] intValue];
        _start = plist[START];
        _end = plist[END];
        _duration = [plist[DURATION] doubleValue];
    }
    return self;
}

- (NSDictionary *)resultAsPropertyList
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    dict[GAMETYPE] = self.gameType;
    dict[SCORE] = @(self.score);
    dict[START] = self.start;
    dict[END] = self.end;
    dict[DURATION] = @(self.duration);
    return [dict copy];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.start = [NSDate date];
    }
    return self;
}


- (void)setScore:(int)score
{
    _score = score;
    self.end = [NSDate date];
    self.duration = [self.end timeIntervalSinceDate:self.start];
    [self sync];
}

- (void)sync
{
    NSMutableDictionary* results = [[[NSUserDefaults standardUserDefaults] objectForKey:ALLRESULTS] mutableCopy];
    if (!results) {
        results = [[NSMutableDictionary alloc]init];
    }
    NSString* key = [NSString stringWithFormat:@"%lf", [self.start timeIntervalSince1970]];
    key = [key substringToIndex:12];
    results[key] = [self resultAsPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:results forKey:ALLRESULTS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSComparisonResult)sortResultsByDate:(ScoreResult *)result
{
    return [self.end compare:result.end];
}

- (NSComparisonResult)sortResultsByScore:(ScoreResult *)result
{
    return [@(self.score) compare:@(result.score)];
}

- (NSComparisonResult)sortResultsByDuration:(ScoreResult *)result
{
    return [@(self.duration) compare:@(result.duration)];
}

@end
