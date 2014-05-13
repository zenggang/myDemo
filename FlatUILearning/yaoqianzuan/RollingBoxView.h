//
//  RollingBoxView.h
//  FlatUILearning
//
//  Created by gang zeng on 14-5-11.
//  Copyright (c) 2014年 gang zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RollingBoxViewDelegate <NSObject>

-(void) rollingViewWillStartRolling;
-(void) rollingViewWillEndRolling;
@end

@interface RollingBoxView : UIView

@property (nonatomic,weak) id<RollingBoxViewDelegate> delegate;

-(void) setupRollingView;
-(void) startRollingWithNumberOne:(int) one two:(int) two three:(int) three;
@end
