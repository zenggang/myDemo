//
//  QumiBannerAD.h
//  QumiAD_SDK
//
//  Created by 趣米 on 13-7-8.
//  Copyright (c) 2013年 guchangxin. All rights reserved.
//

//当前广告支持的尺寸

//For iPhone
#define QUMI_AD_SIZE_320x50 CGSizeMake(320,50)

//For iPad
#define QUMI_AD_SIZE_768x100   CGSizeMake(768,100)  

 
#import <UIKit/UIKit.h>

@protocol QumiBannerADDelegate;

@interface QumiBannerAD : UIView
{
    id<QumiBannerADDelegate>   _delegate;
    UIViewController           *_rootViewController;
}
@property (nonatomic,assign) id<QumiBannerADDelegate> delegate;
@property (nonatomic,retain) UIViewController         *rootViewController;

//初始化普通的嵌入式广告试图
- (id)initWithQumiBannerAD;  //banner条的初始化方法

//加载广告
- (void)loadBannerAd;

@end

@protocol QumiBannerADDelegate <NSObject>

//加载广告成功后，回调该方法
- (void)qmAdViewSuccessToLoadAd:(QumiBannerAD *)adView;
//加载广告失败后，回调该方法
- (void)qmAdViewFailToLoadAd:(QumiBannerAD *)adView withError:(NSError *)error;
@end
