//
//  ScoreResultViewController.m
//  machismo
//
//  Created by Appleseed on 8/28/14.
//  Copyright (c) 2014 Appleseed. All rights reserved.
//

#import "ScoreResultViewController.h"
#import "ScoreResult.h"

@interface ScoreResultViewController ()

@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (strong, nonatomic)NSArray* results;
@property (strong, nonatomic)NSString* sortType;

@end

@implementation ScoreResultViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.results = [[ScoreResult allResults] mutableCopy];
    if (!self.sortType) {
        [self updateOrderingby:@"byDate"];
    }
}

- (void)updateOrderingby:(NSString *)sortType
{
    if ([sortType isEqualToString:@"byDate"]) {
        self.results = [self.results sortedArrayUsingSelector:@selector(sortResultsByDate:)];
    } else if ([sortType isEqualToString:@"byScore"]) {
        self.results = [self.results sortedArrayUsingSelector:@selector(sortResultsByScore:)];
    } else if ([sortType isEqualToString:@"byDuration"]) {
        self.results = [self.results sortedArrayUsingSelector:@selector(sortResultsByDuration:)];
    }
    [self updateUI];
}

- (void)updateUI
{
    NSMutableString* str = [[NSMutableString alloc]init];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    for (ScoreResult* result in self.results) {
        NSString* date = [dateformat stringFromDate:result.end];
        [str appendFormat:@"%@: %i, (%@, %.0lfs)\n",result.gameType, result.score, date, result.duration];
    }

    [self.resultTextView.textStorage.mutableString replaceCharactersInRange:NSMakeRange(0, self.resultTextView.textStorage.mutableString.length) withString:str];
}

- (IBAction)sortResultsByDate:(UIButton *)sender {
    [self updateOrderingby:@"byDate"];
}

- (IBAction)sortResultsByScore:(UIButton *)sender {
    [self updateOrderingby:@"byScore"];
}

- (IBAction)sortResultsByDuration:(UIButton *)sender {
    [self updateOrderingby:@"byDuration"];
}

@end
