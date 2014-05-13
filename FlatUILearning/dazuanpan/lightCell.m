//
//  lightCell.m
//  FlatUILearning
//
//  Created by gang zeng on 14-5-8.
//  Copyright (c) 2014年 gang zeng. All rights reserved.
//

#import "lightCell.h"

@implementation lightCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lightImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [self.contentView addSubview:_lightImageView];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        _lightImageView.image=[UIImage imageNamed:@"light_yellow"];
        _lightImageView.tag=123;
    }
    return self;
} 

-(void) setLightImageWithType:(int) type
{
    if (type==0) {
        if (_lightImageView.tag==123) {
            _lightImageView.image=[UIImage imageNamed:@"light_white"];
            _lightImageView.tag=124;
        }else{
            _lightImageView.image=[UIImage imageNamed:@"light_yellow"];
            _lightImageView.tag=123;
        }
        
    }else{
        if (_lightImageView.tag==123) {
            _lightImageView.image=[UIImage imageNamed:@"light_yellow"];
            _lightImageView.tag=124;
        }else{
            _lightImageView.image=[UIImage imageNamed:@"light_white"];
            _lightImageView.tag=123;
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
