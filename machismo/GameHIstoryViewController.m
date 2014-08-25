//
//  GameHIstoryViewController.m
//  machismo
//
//  Created by Appleseed on 8/24/14.
//  Copyright (c) 2014 Appleseed. All rights reserved.
//

#import "GameHistoryViewController.h"

@interface GameHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;

@end

@implementation GameHistoryViewController

- (void)setResults:(NSArray *)results
{
    _results = results;
    if (self.view.window) {
        [self updateUI];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI
{ 
    for (NSAttributedString* result in self.results) {
        [self.historyTextView.textStorage appendAttributedString:result];
        [self.historyTextView.textStorage.mutableString appendString:@"\n"];
    }
}

@end
