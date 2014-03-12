//
//  ADCNavigationBarView.h
//  AppDriverSDK
//
//  Created by lfr on 13-4-5.
//  Copyright (c) 2013年 adways. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADCNavigationBarViewDelegate;

@interface ADCNavigationBarView : UIView
{
    UILabel         *_titleLabel;
    UIImageView     *_titleImageView;
    UIButton        *_leftButton;
    UIButton        *_rightButton;
    UIImageView     *_bgImageView;
    id<ADCNavigationBarViewDelegate> _delegate;
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *titleImageView;
@property (nonatomic, retain) UIButton *leftButton;
@property (nonatomic, retain) UIButton *rightButton;
@property (nonatomic, assign) id<ADCNavigationBarViewDelegate> delegate;

- (ADCNavigationBarView *)initWithFrame:(CGRect)frame
                            titleString:(NSString *)titleString
                             titleImage:(UIImage *)titleImage
                             useSandBox:(BOOL)useSandBox;

- (void)addLeftButtonWithFrame:(CGRect)buttonFrame
                   buttonTitle:(NSString *)buttonTitle
         buttonBackgroundImage:(UIImage *)buttonBackgroundImage
        buttonHighLightedImage:(UIImage *)highLightedImage
                  isBackButton:(BOOL)isBackButton;

- (void)addRightButtonWithFrame:(CGRect)buttonFrame
                    buttonTitle:(NSString *)buttonTitle
          buttonBackgroundImage:(UIImage *)buttonBackgroundImage
         buttonHighLightedImage:(UIImage *)highLightedImage;
- (void)setbgImageViewFrame:(CGFloat)viewWidth;
- (void)settitleLabelText:(NSString*)_title;

@end


@protocol ADCNavigationBarViewDelegate <NSObject>

@optional

- (void)leftButtonClicked:(ADCNavigationBarView *)navigationBar;
- (void)rightButtonClicked:(ADCNavigationBarView *)navigationBar;

@end
