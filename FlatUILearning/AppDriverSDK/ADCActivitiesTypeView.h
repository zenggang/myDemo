//
//  ADCActivitiesTypeView.h
//  AppDriverSDK
//
//  Created by li fengrong on 13-4-7.
//  Copyright (c) 2013年 adways. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum
{
    ADCAppActivities = 1,
    ADCWebActivities,
    ADCECommerceActivities,
    ADCRecommendActivities
}ADCActivitiesType;

@protocol ADCActivitiesTypeViewDelegate;

@interface ADCActivitiesTypeView : UIView
{
    UIButton        *_appActivityButton;
    UIButton        *_webActivityButton;
    UIButton        *_ecommerceActivityButton;
    UIButton        *_recommendButton;
    
    id<ADCActivitiesTypeViewDelegate>_delegate;
}

@property (nonatomic, assign)id<ADCActivitiesTypeViewDelegate>delegate;

-(void)setVerticalFrame:(CGFloat)viewWidth;
-(void)setHorizontalFrame:(CGFloat)viewWidth;
- (id)initWithFrame:(CGRect)frame useSandbox:(BOOL)useSandbox;

@end

@protocol ADCActivitiesTypeViewDelegate <NSObject>

@optional

- (void)activitiesTypeButtonClick:(NSInteger)_selectedAppType;

@end