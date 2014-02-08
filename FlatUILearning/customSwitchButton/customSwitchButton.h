//
//  customSwitchButton.h
//  FlatUILearning
//
//  Created by gang zeng on 14-1-1.
//  Copyright (c) 2014年 gang zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomSwitchButtonDelegate <NSObject>
-(void) didEndSwitchTap:(id) swithcButton WithState:(BOOL) on;
@end


@interface customSwitchButton : UIView
@property (nonatomic,weak) IBOutlet UIImageView *trackBgView;
@property (nonatomic,weak) IBOutlet UIImageView *trackButton;

@property (nonatomic,weak) id<CustomSwitchButtonDelegate> delegate;

-(void) setUpSwitchButtonWithOn:(BOOL) on;

@end

