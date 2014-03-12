//
//  ADCRecommendView.h
//  AppDriverSDK
//
//  Created by lfr on 13-4-5.
//  Copyright (c) 2013年 adways. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADCUrlImageQueueDelegate.h"

@class ADCUrlImageQueue;

@protocol ADCRecommendViewDelegate;

@interface ADCRecommendView : UIView<UIScrollViewDelegate, ADCUrlImageQueueDelegate>
{
    UIScrollView        *_scrollView;
    UIImageView         *_recommendImageView;
    UILabel             *_recommendLabel;
    UILabel             *_tipsLabel;
    NSInteger           _contentViewX;
    NSMutableArray      *_dataArray;
    ADCUrlImageQueue    *_urlImageQueue;
    id<ADCRecommendViewDelegate>_delegate;
    NSString            *_domain;
}

@property (nonatomic, retain)NSMutableArray *dataArray;
@property (nonatomic,assign)id<ADCRecommendViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame useSandbox:(BOOL)useSandbox;
- (void)loadData:(NSMutableArray *)_appArray;
- (void)setObjectFrame:(CGFloat)viewWidth;
- (void)removeScrollView;

@end

@protocol ADCRecommendViewDelegate <NSObject>

@optional

- (void)recommendAppWasClicked:(NSInteger)index;

@end