//
//  GameSettings.m
//  machismo
//
//  Created by Appleseed on 8/28/14.
//  Copyright (c) 2014 Appleseed. All rights reserved.
//

#import "GameSettings.h"

#define Settings @"settings"
#define MATCH_BONUS @"match_bonus"
#define MISMATCH_PANELTY @"mismatch_panelty"
#define CHOOSE_COST @"choose_cost"

@implementation GameSettings

- (void)setMatchBonus:(int)matchBonus
{
    NSMutableDictionary* settings = [[[NSUserDefaults standardUserDefaults] objectForKey:Settings] mutableCopy];
    if (!settings) {
        settings = [[NSMutableDictionary alloc]init];
        [[NSUserDefaults standardUserDefaults] setObject:settings forKey:Settings];
    }
    [settings setValue:@(matchBonus) forKey:MATCH_BONUS];
    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:Settings];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setMismatchPanelty:(int)mismatchPanelty
{
    NSMutableDictionary* settings = [[NSUserDefaults standardUserDefaults] objectForKey:Settings];
    if (!settings) {
        settings = [[NSMutableDictionary alloc]init];
    }
    [settings setValue:@(mismatchPanelty) forKey:MISMATCH_PANELTY];
    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:Settings];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setChooseCost:(int)chooseCost
{
    NSMutableDictionary* settings = [[NSUserDefaults standardUserDefaults] objectForKey:Settings];
    if (!settings) {
        settings = [[NSMutableDictionary alloc]init];
    }
    [settings setValue:@(chooseCost) forKey:CHOOSE_COST];
    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:Settings];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int)matchBonus
{
    NSDictionary* settings = [[NSUserDefaults standardUserDefaults] objectForKey:Settings];
    if (settings) {
        NSNumber* matchbonus = [settings valueForKey:MATCH_BONUS];
        if (matchbonus) {
            return [matchbonus intValue];
        }
    }
    return 4;
}

- (int)mismatchPanelty
{
    NSDictionary* settings = [[NSUserDefaults standardUserDefaults] objectForKey:Settings];
    if (settings) {
        NSNumber* mismatchbonus = [settings valueForKey:MISMATCH_PANELTY];
        if (mismatchbonus) {
            return [mismatchbonus intValue];
        }
    }
    return 2;
}

- (int)chooseCost
{
    NSDictionary* settings = [[NSUserDefaults standardUserDefaults] objectForKey:Settings];
    if (settings) {
        NSNumber* choosecost = [settings valueForKey:CHOOSE_COST];
        if (choosecost) {
            return [choosecost intValue];
        }
    }
    return 1;
}

@end
