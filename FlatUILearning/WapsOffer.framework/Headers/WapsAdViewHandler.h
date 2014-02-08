//
//  WapsAdViewHandler.h
//  WapsOfferLib
//
//  Created by guang on 13-12-16.
//  Copyright (c) 2013年 celles.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WapsCallsWrapper.h"
#import "AppConnect.h"
@class WapsAdView;
@class UIViewController;

@interface WapsAdViewHandler : NSObject{
    WapsAdView *_adH5;

}
@property(nonatomic, retain) WapsAdView *adH5;

+ (void)displayAd:(UIViewController *)vController adSize:(NSString *)aSize showX:(CGFloat)x showY:(CGFloat)y ;

- (void)removeAdH5;

@end

@interface WapsCallsWrapper (WapsAdViewHandler)

- (void)displayAd:(UIViewController *)vController adSize:(NSString *)aSize showX:(CGFloat)x showY:(CGFloat)y;

@end


@interface AppConnect (WapsAdViewHandler)

+ (void)displayAd:(UIViewController *)vController adSize:(NSString *)aSize showX:(CGFloat)x showY:(CGFloat)y;

+ (void)displayAd:(UIViewController *)vController adSize:(NSString *)aSize;

+ (void)displayAd:(UIViewController *)vController;

+ (void)displayAd:(UIViewController *)vController showX:(CGFloat)x showY:(CGFloat)y;
@end


