//
//  TopicSquareView.m
//  FlatUILearning
//
//  Created by gang zeng on 13-6-6.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "MenuView.h"
#import "TTLabel.h"

@implementation MenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    //_saveMoneyLable.textColor=[UIColor colorFromHexCode:@""];
    return self;
}

-(void) setUpViewWithSetMenu:(SetMenu *) setmenu
{
    if ([APP_NAME isEqualToString:APPNAME_KFC]) {
        self.backgroundColor=[UIColor cloudsColor];
    }else if([APP_NAME isEqualToString:APPNAME_MCDONALD]){
        self.backgroundColor= [UIColor sunflowerColor];
    }
    
    ////log4Debug(setmenu.picUrl);
    for (int i=0;i<[[_setMenu.menusString componentsSeparatedByString:@","] count];i++) {
        UIView *tempView = [self viewWithTag:i+1];
        if(tempView)
            [tempView removeFromSuperview];
    }
    _setMenu=setmenu;
//    [_menuImageView setImageWithURL:[NSURL URLWithString:_setMenu.picUrl] placeholderImage:UI_SET_MENU_PLACEHOLDER_IMAGE];
    
    [self showImage];
    
    
    _titleLable.font=[UIFont boldFlatFontOfSize:20];
    
    _titleLable.text=[NSString stringWithFormat:@"%@",_setMenu.setTitle];
    
    _saveMoneyLable.font=[UIFont boldFlatFontOfSize:15];
    _saveMoneyLable.text=[NSString stringWithFormat:@"省:%@元",_setMenu.saveMoney];
    
    _priceLable.font=[UIFont boldFlatFontOfSize:35];
    _priceLable.textColor=[UIColor colorFromHexCode:@"D35400"];
    _priceLable.text=[NSString stringWithFormat:@"%@",_setMenu.price];
    [(UILabel *)[self viewWithTag:123] setTextColor:[UIColor colorFromHexCode:@"D35400"]];
    int i=0;
    for (NSString *name in [_setMenu.menusString componentsSeparatedByString:@","]) {
        UILabel *menuLable =[TTLabel createLabeWithTxt:name Frame:CGRectMake(20, 220+(i*20), 170, 24) Font:[UIFont flatFontOfSize:13] textColor:[TTColor colorWithRed:35 green:57 blue:76 alpha:1] backGroudColor:[UIColor clearColor]];
        menuLable.tag=i+1;
        menuLable.textAlignment=NSTextAlignmentLeft;
        [self addSubview:menuLable];
        i++;
    }
    
self.layer.borderWidth=0.3;

}

-(void) setProgressWithProgress:(double) progress
{
    _setMenu.progressValue=progress;
    if (progress<1) {
        _progressView.progress=progress;
        _progressLable.text=[NSString stringWithFormat:@"图片加载中....%.01f%%",progress*100];
    }else{
        [self performSelector:@selector(showImage) withObject:nil afterDelay:0.1];
    }
}

-(void) showImage
{
    if ([_setMenu checkImageFileDownLoaded]) {
        [_progressView removeFromSuperview];
        _progressView=nil;
        [_progressLable removeFromSuperview];
        _progressLable=nil;
        if (_menuImageView==nil) { 
            _menuImageView =[[UIImageView alloc ] initWithFrame:CGRectMake(0, 0, 250, 187)];
            [self addSubview:_menuImageView];
        }
        
        if(![APPDELEGATE.menuImageDict objectForKey:[_setMenu getPicFileName]])
        {
            UIImage *theImage=[UIImage imageWithContentsOfFile:[_setMenu getPicFileLocation]];
            if (theImage) {
                [APPDELEGATE.menuImageDict setObject:theImage forKey:[_setMenu getPicFileName]];
            }
            
        }

        [_menuImageView setImage:[APPDELEGATE.menuImageDict objectForKey:[_setMenu getPicFileName]]];
        
    }else{
        if (_progressLable==nil) {
        
            _progressLable =[TTLabel createLabeWithTxt:@"图片加载中....0%" Frame:CGRectMake(45, 64, 170, 24) Font:[UIFont flatFontOfSize:13] textColor:[TTColor colorWithRed:35 green:57 blue:76 alpha:1] backGroudColor:[UIColor clearColor]];
            _progressLable.textAlignment=NSTextAlignmentLeft;
        }
        [_menuImageView removeFromSuperview];
        _menuImageView=nil;
        [self addSubview:_progressLable];
        if (_progressView==nil) {
            _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(43, 98, 174, 9)];
            [self addSubview:_progressView];
        }
        [_progressView configureFlatProgressViewWithTrackColor:[UIColor silverColor] progressColor:[UIColor wisteriaColor]];
        if (_setMenu.progressValue==0) {
            _progressView.progress=0.0;
            _progressLable.text=@"图片加载中....0%";
        }
    }
}


@end
