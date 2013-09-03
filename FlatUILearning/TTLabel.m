//
//  TTLabel.m
//  Golf_fourm
//
//  Created by 张峰 on 13-4-1.
//  Copyright (c) 2013年 Âº†Â≥∞. All rights reserved.
//

#import "TTLabel.h"

@implementation TTLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark -
#pragma mark OHAttributedLabel Assistant




+(UILabel *)createLabeWithTxt:(NSString *)text Frame:(CGRect) frame Font:(UIFont *) font textColor:(UIColor *) color backGroudColor:(UIColor *) bgColor
{
    if (!font) {
        font=[UIFont flatFontOfSize:17];
    }
    if (!color) { 
        color=[UIColor colorWithRed:47/255.0f green:47/255.0f blue:47/255.0f alpha:1.0f];
    }
    if (!bgColor) {
        bgColor=[UIColor clearColor];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text=text;
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor = color;
    label.font = font;
    label.backgroundColor =bgColor;
    return label;
}
@end
