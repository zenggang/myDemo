//
//  RollingBoxView.m
//  FlatUILearning
//
//  Created by gang zeng on 14-5-11.
//  Copyright (c) 2014年 gang zeng. All rights reserved.
//

#import "RollingBoxView.h"
#import "TheRollingView.h"

@implementation RollingBoxView
{
    TheRollingView *rollingView1;
    TheRollingView *rollingView2;
    TheRollingView *rollingView3;
    NSTimer *_timer;
    int numberOne;
    int numberTwo;
    int numberThree;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setupRollingView
{
    rollingView1=[[TheRollingView alloc] initWithFrame:CGRectMake(0, 0, 78, 78)];
    rollingView2=[[TheRollingView alloc] initWithFrame:CGRectMake(0, 0, 78, 78)];
    rollingView3=[[TheRollingView alloc] initWithFrame:CGRectMake(0, 0, 78, 78)];
    rollingView1.center=CGPointMake(126, 86);
    rollingView2.center=CGPointMake(100, 175);
    rollingView3.center=CGPointMake(185, 160);
    [self addSubview:rollingView1];
    [self addSubview:rollingView2];
    [self addSubview:rollingView3];
}

-(void) startRollingWithNumberOne:(int) one two:(int) two three:(int) three
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(shouldEndRolling) userInfo:nil repeats:NO];
    [rollingView1 _startRolling];
    [rollingView2 _startRolling];
    [rollingView3 _startRolling];
    numberOne=one;
    numberTwo=two;
    numberThree=three;
    [_delegate rollingViewWillStartRolling];
}

-(void) shouldEndRolling
{
    [_delegate rollingViewWillEndRolling];
    [rollingView1 _endRollingWithNumber:numberOne];
    [rollingView2 _endRollingWithNumber:numberTwo];
    [rollingView3 _endRollingWithNumber:numberThree];
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
