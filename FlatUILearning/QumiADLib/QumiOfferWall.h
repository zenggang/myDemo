//
//  QumiOfferWall.h
//  QumiAdWall
//
//  Created by 趣米 on 14-2-28.
//  Copyright (c) 2014年 Qumi_SDK. All rights reserved.
//

#import <UIKit/UIKit.h>

#define QUMI_GET_POINTS_STATES      @"GET_POINTS_STATES"
#define QUMI_GET_POINTS_SUCCESS     @"success"
#define QUMI_GET_POINTS_FAILED      @"fail"
#define QUMI_GET_POINTS_ERROR       @"error"
#define QUMI_GET_POINTS_KEY_STATES  @"state"

@protocol QMOfferWallDelegate;

@interface QumiOfferWall : UIViewController
{
    id<QMOfferWallDelegate>   _delegate;
    UIViewController         *_rootViewController;
}
@property (nonatomic,retain) id<QMOfferWallDelegate> delegate;
@property (nonatomic,retain) UIViewController       *rootViewController;


// 使用Publisher ID和应用当前登陆用户的User ID（或其它的在应用中唯一标识用户的ID）
//初始化积分墙，如果是游戏类的应用，注意要传递积分账户ID
//如果你希望在几部不同的设备中间共用积分，比如你的app是游戏类的，用户注册了一个游戏账号，当这个用户换另一部手机，用该账号登陆，期望使用该账户的积分。这种情况可以设置用户id，用户id的优先级高于设备序列号，所以请谨慎设置，有问题可以咨询我们商务或者技术
- (id)initwithPointUserID:(NSString *)pointUserId;

//弹出趣米的积分墙
- (void)presentQumiOfferWall;

//检查领取积分
- (void)getPointsQueue;

//查询剩余积分
- (void)queryRemainPoints;

//消费积分
- (void)consumePoints:(NSInteger)points;

//追加积分
- (void)appendPoints:(NSInteger)points;

@end

@protocol QMOfferWallDelegate <NSObject>

@optional
#pragma mark QumiAdWall Methods
/**********************************
 *   积分墙加载，展示，关闭的回调方法   *
 **********************************/
//积分墙加载成功，回调该方法
- (void)QumiAdWallSuccessToLoaded:(QumiOfferWall *)qumiAdWall;

//加载广告失败后，回调该方法
- (void)QumiAdWallFailToLoaded:(QumiOfferWall *)qumiAdWall withError:(NSError *)error;

//积分墙开始展示，回调该方法
- (void)QumiAdWallPresent:(QumiOfferWall *)qumiAdWall;

//积分墙关闭，回调该方法
- (void)QumiAdWallDismiss:(QumiOfferWall *)qumiAdWall;


#pragma mark QumiAdWall CheckPoints Methods
/************************************************
 *   检查积分，获取积分，消费积分，追加积分的回调方法   *
 ************************************************/
@required
/*
 *注意：该方法必选，否则无法正常获取积分
 */
//从积分墙上领取积分，回调该方法，领取成功或者失败的状态 注意：领取积分成功请填写1，领取失败请填写0
- (void)QumiADWallGetPointsFromWall:(NSInteger)points;

@optional
//请求领取积分成功方法的回调
- (void)qumiAdWallGetPointSuccess:(NSString *)getPointState;

//请求领取积分失败方法的回调
- (void)qumiAdWallGetPointFailed:(NSError *)error;

//请求检查剩余积分成功后，回调该方法，获得总积分数和返回的积分数。
- (void)QumiAdWallCheckPointsSuccess:(NSInteger)remainPoints;

//请求检查剩余积分失败后，回调该方法，返回检查积分失败信息
-(void)QumiAdWallCheckPointsFailWithError:(NSError *)error;

#pragma mark QumiAdWall ConsumePoints Mehtods
//消费请求成功之后，回调该方法，返回消费情况(消费成功，或者当前的积分不足)，以及当前的总积分数
- (void)QumiAdWallConsumePointsSuccess:(NSString *)ConsumeState remainPoints:(NSInteger)points;

//消费请求失败之后，回调该方法，返回失败信息。
- (void)QumiAdWallConsumePointsFailWithError:(NSError *)error;

#pragma mark QumiAdWall AppendPoints Mehtods
//追加积分成功后，回调该方法，返回追加积分的情况(追加积分成功)，以及当前的总积分数
- (void)QumiAdWallAppendPointsSuccess:(NSString *)appendState remainPoints:(NSInteger)points;

//追加积分失败后，回调该方法，返回失败信息
- (void)QumiAdWallAppendPointsFailWithError:(NSError *)error;

@end
