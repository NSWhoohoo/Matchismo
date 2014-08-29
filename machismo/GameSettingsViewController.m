//
//  GameSettingsViewController.m
//  machismo
//
//  Created by Appleseed on 8/28/14.
//  Copyright (c) 2014 Appleseed. All rights reserved.
//

#import "GameSettingsViewController.h"
#import "GameSettings.h"

@interface GameSettingsViewController ()
@property (nonatomic, strong)GameSettings* gameSettings;
@property (weak, nonatomic) IBOutlet UILabel *matchBonus;
@property (weak, nonatomic) IBOutlet UILabel *mismatchPenalty;
@property (weak, nonatomic) IBOutlet UILabel *chooseCost;
@property (weak, nonatomic) IBOutlet UISlider *matchBonusSlider;
@property (weak, nonatomic) IBOutlet UISlider *mismatchPenaltySlider;
@property (weak, nonatomic) IBOutlet UISlider *chooseCostSlider;

@end

@implementation GameSettingsViewController

- (GameSettings *)gameSettings
{
    if (!_gameSettings) {
        _gameSettings = [[GameSettings alloc]init];
    }
    return _gameSettings;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.matchBonus.text = [NSString stringWithFormat:@"%i", self.gameSettings.matchBonus];
    self.matchBonusSlider.value = self.gameSettings.matchBonus;
    self.mismatchPenalty.text = [NSString stringWithFormat:@"-%i", self.gameSettings.mismatchPanelty];
    self.mismatchPenaltySlider.value = self.gameSettings.mismatchPanelty;
    self.chooseCost.text = [NSString stringWithFormat:@"%i", self.gameSettings.chooseCost];
    self.chooseCostSlider.value = self.gameSettings.chooseCost;
}

- (IBAction)matchBonusChanged:(UISlider *)sender {
    int value = (int)sender.value;
    self.matchBonus.text = [NSString stringWithFormat:@"%i", value];
    sender.value = value;
    [self.gameSettings setMatchBonus:value];
    NSLog(@"%i", self.gameSettings.matchBonus);
}

- (IBAction)mismatchPenaltyChanged:(UISlider *)sender {
    int value = (int)sender.value;
    self.mismatchPenalty.text = [NSString stringWithFormat:@"-%i", value];
    sender.value = value;
    [self.gameSettings setMismatchPanelty:value];
}

- (IBAction)chooseCostChanged:(UISlider *)sender {
    int value = (int)sender.value;
    self.chooseCost.text = [NSString stringWithFormat:@"%i", value];
    sender.value = value;
    [self.gameSettings setChooseCost:value];
}
@end
