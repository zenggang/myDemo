//
//  goldToMoneyScrollView.h
//  FlatUILearning
//
//  Created by gang zeng on 13-6-28.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface goldToMoneyScrollView : UIView
@property (nonatomic,assign) BOOL stopAnimation;
@property (nonatomic,assign) NSInteger lastIndex;
@property (nonatomic,strong) NSArray *textArray;
-(void) setUpTextScrollView:(NSArray *) array;
-(void) startScrollAnimetion;

@end
