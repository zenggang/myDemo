//
//  WeiXinShareViewCenterController.h
//  FlatUILearning
//
//  Created by gang zeng on 13-9-9.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "BaseWeiXInController.h"

@interface WeiXinShareViewCenterController : BaseViewController<sendMsgToWeChatViewDelegate>
@property (nonatomic,strong) BaseWeiXInController *weixinController;
@end
