//
//  WeiXinGoldShareViewController.h
//  FlatUILearning
//
//  Created by gang zeng on 13-7-11.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "BaseWeiXInController.h"

@interface WeiXinGoldShareViewController : BaseViewController<sendMsgToWeChatViewDelegate>
{
    
}

@property (nonatomic,strong) BaseWeiXInController *weixinController;
@property (nonatomic,assign) enum WXScene scene;
@end
