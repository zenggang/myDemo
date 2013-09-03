//
//  TTColor.m
//  Golf_fourm
//
//  Created by gang zeng on 13-4-23.
//  Copyright (c) 2013年 Âº†Â≥∞. All rights reserved.
//

#import "TTColor.h"

@implementation TTColor
+(UIColor *) colorWithRed:(int) red  green:(int) green  blue:(int) blue alpha:(float) alpha
{
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}
@end
