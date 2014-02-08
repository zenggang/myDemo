//
//  TheLightsView.h
//  FlatUILearning
//
//  Created by gang zeng on 14-1-2.
//  Copyright (c) 2014年 gang zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheLightsView : UIView
- (id)initWithFrame:(CGRect)frame withRow:(int) row withColumn:(int) column;

-(void) stopLightingAnimation;
@end
