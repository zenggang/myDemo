//
//  BaseWeiXInViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-11.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "BaseWeiXInController.h"

@interface BaseWeiXInController ()

@end

@implementation BaseWeiXInController



- (id)init
{
    self = [super init];
    if (self) {
        //默认朋友圈
        _scene=WXSceneTimeline;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWeiXinMessage:) name:WEI_XIN_DID_RETURN object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WEI_XIN_DID_RETURN object:nil];
}

#pragma mark action
-(void) changeScene:(NSInteger)scene{
    _scene = scene;
}


#pragma mark handleMessage receive
-(void) handleWeiXinMessage:(NSNotification *) notify
{
    SendMessageToWXResp *receiveData= [notify.userInfo objectForKey:@"sendMessageToWXResp"];
    if (receiveData.errCode==0) {
        [_delegate didSendMessageSuccess];
    }else
        [_delegate didSendMessageError];
}

#pragma mark WeiXin action

//发送图片
- (void) sendImageContentWithThumbData:(NSData *) thumbData withImageData:(NSData *) imageData
{ 
    //发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    message.thumbData=thumbData;
    
    WXImageObject *ext = [WXImageObject object];
    
    ext.imageData = imageData;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message; 
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

@end
