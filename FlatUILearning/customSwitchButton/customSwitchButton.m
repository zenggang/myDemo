//
//  customSwitchButton.m
//  FlatUILearning
//
//  Created by gang zeng on 14-1-1.
//  Copyright (c) 2014年 gang zeng. All rights reserved.
//

#import "customSwitchButton.h"

@interface customSwitchButton ()

@property (nonatomic,assign) BOOL isOn;

@end

@implementation customSwitchButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
} 

-(void) setUpSwitchButtonWithOn:(BOOL) on
{
    _isOn=YES;
    [self setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
    [self setOn:on animated:NO];
    self.userInteractionEnabled=YES;
    _trackButton.userInteractionEnabled=YES;
    
}


- (void) handleTap:(UIPanGestureRecognizer*) recognizer
{
    [self setOn:!_isOn animated:YES];
    [_delegate didEndSwitchTap:self WithState:_isOn];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    if (on !=_isOn) {
        _isOn=on;
        if (animated) {
            [UIView animateWithDuration:0.5f animations:^{
                if (on)
                    [_trackButton setFrameOriginX:0];
                else
                    [_trackButton setFrameOriginX:29];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2f animations:^{
                    if (on) {
                        _trackBgView.image=[UIImage imageNamed:@"swith_track_on.png"];
                    }else{
                        _trackBgView.image=[UIImage imageNamed:@"swith_track_off.png"];
                    }
                    
                }];
            }];
        }else{
            if (on){
                [_trackButton setFrameOriginX:0];
                _trackBgView.image=[UIImage imageNamed:@"swith_track_on.png"];
            }else{
                [_trackButton setFrameOriginX:29];
                _trackBgView.image=[UIImage imageNamed:@"swith_track_off.png"];
            }
        }

    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
