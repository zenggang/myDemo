//
//  TheRollingView.m
//  BoBing
//
//  Created by gang zeng on 14-3-19.
//  Copyright (c) 2014年 xmhouse. All rights reserved.
//

#import "TheRollingView.h"

@interface TheRollingView ()
{
    BOOL isRolling;
}

@property (nonatomic,strong) UIImageView *theRollingImageView;
@property (nonatomic,strong) UIImageView *theEndImageView;
@end

@implementation TheRollingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isRolling=NO;
        _theEndImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 78, 78)];
        _theEndImageView.image=[UIImage imageNamed:@"touzi_stop_6"];
        [self addSubview:_theEndImageView];
        _theEndImageView.center=CGPointMake(frame.size.width/2, frame.size.height/2);
        _theRollingImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 78,78)];
        [self addSubview:_theRollingImageView];
        NSArray *rollingImages = [NSArray arrayWithObjects:
                                  [UIImage imageNamed:@"touzi_rolling_1"],
                                  [UIImage imageNamed:@"touzi_rolling_2"],
                                  [UIImage imageNamed:@"touzi_rolling_3"],
                                  [UIImage imageNamed:@"touzi_rolling_4"],
                                  [UIImage imageNamed:@"touzi_rolling_5"],nil];
        
        _theRollingImageView.animationImages=rollingImages;
        _theRollingImageView.animationDuration=0.4;
        _theRollingImageView.center=CGPointMake(frame.size.width/2, frame.size.height/2);
    }
    return self;
}

-(void)_startRolling
{
    if (isRolling) {
        return;
    }
    _theRollingImageView.hidden=NO;
    isRolling=YES;
    _theEndImageView.hidden=YES;
    [_theRollingImageView startAnimating];
}

-(void) _endRollingWithNumber:(int) number
{
    
    _theEndImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"touzi_stop_%d",number]];
    isRolling=NO;
    [_theRollingImageView stopAnimating];
    _theRollingImageView.hidden=YES;
    _theEndImageView.hidden=NO;
    
}

@end
