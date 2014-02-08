//
//  ScorllNumberLable.m
//  Demo
//
//  Created by gang zeng on 13-7-26.
//  Copyright (c) 2013年 ZCCStudio. All rights reserved.
//

#import "ScorllNumberLable.h"

#define kAllFullSuperviewMask      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;

@implementation ScorllNumberLable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setUpScrollViewWithNumberSize:(int) numberSize
{
    self.numberSize = numberSize;
    CGRect frame = {{0, 0}, {25, 25}};
    UIImage *image = [[UIImage imageNamed:@"number_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:14];
    self.backgroundView = [[UIImageView alloc] initWithImage:image];
    UIView *digitBackView = [[UIView alloc] initWithFrame:frame] ;
    digitBackView.backgroundColor = [UIColor clearColor];
    digitBackView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    digitBackView.autoresizesSubviews = YES;
//    image = [[UIImage imageNamed:@"money_back"] stretchableImageWithLeftCapWidth:12 topCapHeight:12];
//    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:image];
//    bgImageView.frame = frame;
//    bgImageView.autoresizingMask = kAllFullSuperviewMask;
//    [digitBackView addSubview:bgImageView];
    //image = [[UIImage imageNamed:@"money_bg_mask"] stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    //UIImageView *bgMaskImageView = [[UIImageView alloc] initWithImage:image];
    //bgMaskImageView.autoresizingMask = kAllFullSuperviewMask;
    //bgMaskImageView.frame = frame;
    //[digitBackView addSubview:bgMaskImageView];
    
    self.digitBackgroundView = digitBackView;
    self.digitColor = [UIColor whiteColor];
    self.digitFont = [UIFont systemFontOfSize:17.0];
    [self didConfigFinish];
    
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
