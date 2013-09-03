//
//  TTLabel.h
//  Golf_fourm
//
//  Created by 张峰 on 13-4-1.
//  Copyright (c) 2013年 Âº†Â≥∞. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MESSAGE_COLOR_STRONG [UIColor colorWithRed:0.14f green:0.15f blue:0.17f alpha:1.00f]
#define MESSAGE_COLOR_AT [UIColor colorWithRed:0.07f green:0.47f blue:0.82f alpha:1.00f]
#define MESSAGE_COLOR_LINK [UIColor colorWithWhite:0.000 alpha:1.000]
#define MESSAGE_FONT_SIZE 14.0f
#define MESSAGE_COLOR_TEXT [UIColor colorWithWhite:0.396 alpha:1.000]
#define MESSAGE_COLOR_COVER [UIColor lightGrayColor]
#define MESSAGE_FONT_TEXT [UIFont fontWithName:@"Helvetica" size:14.0]

@interface TTLabel : UILabel


//+(CGSize)getStringSize:(NSString *)text width:(CGFloat)width fontSize:(CGFloat)fontSize;

+(UILabel *)createLabeWithTxt:(NSString *)text Frame:(CGRect) frame Font:(UIFont *) font textColor:(UIColor *) color backGroudColor:(UIColor *) bgColor; 
@end
