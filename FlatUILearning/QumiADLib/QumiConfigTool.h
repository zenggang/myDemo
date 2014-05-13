//
//  QumiConfigTool.h
//  QumiAD_SDK
//
//  Created by 趣米 on 13-9-7.
//  Copyright (c) 2013年 guchangxin. All rights reserved.
//

#define QUMI_CONNECT_SUCCESS @"QUMI_CONNECT_SUCCESS"
#define QUMI_CONNECT_FAILED  @"QUMI_CONNECT_FAILED"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QumiConfigTool : NSObject

- (void)connectWithAppID:(NSString *)publisherId  secretKey:(NSString *)secretKey appChannel:(NSUInteger)channel;  //开发者ID 密钥 应用所在的渠道号

//开发者ID
- (void)setPublisherId:(NSString *)aQumiAppcodeId;
- (NSString *)qumiAppcodeId;

//密钥
- (void)setSecretKey:(NSString *)aQumiSecretKey;
- (NSString*)qumiSecretKey;

//渠道号
- (void)setChannelID:(NSUInteger)aQumiChannelID;
- (NSUInteger)qumiChannelID;

+ (QumiConfigTool *)sharedInstance;

@end
