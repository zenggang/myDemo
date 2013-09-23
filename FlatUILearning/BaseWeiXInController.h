//
//  BaseWeiXInViewController.h
//  FlatUILearning
//
//  Created by gang zeng on 13-7-11.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//


@protocol sendMsgToWeChatViewDelegate <NSObject>
-(void) didSendMessageSuccess;
-(void) didSendMessageError;
@end

@interface BaseWeiXInController : NSObject{
    enum WXScene _scene;
}

@property (nonatomic, weak) id<sendMsgToWeChatViewDelegate> delegate;

- (void) sendImageContentWithThumbData:(NSData *) thumbData withImageData:(NSData *) imageData;
-(void) changeScene:(NSInteger)scene;
- (void) sendAppContentWithThumbData:(UIImage *) thumbImage withMessage:(NSString *) content withDescription:(NSString *) descripe andLink:(NSString *) url;
@end
