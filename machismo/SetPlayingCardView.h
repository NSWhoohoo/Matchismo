//
//  SetPlayingCardView.h
//  machismo
//
//  Created by Appleseed on 8/26/14.
//  Copyright (c) 2014 Appleseed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPlayingCardView : UIView

@property (nonatomic)int number;
@property (nonatomic, copy)NSString* symbol;
@property (nonatomic, copy)NSString* shading;
@property (nonatomic, copy)NSString* color;
@property (nonatomic)BOOL chosen;

@end
