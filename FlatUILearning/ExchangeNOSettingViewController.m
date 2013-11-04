//
//  ExchangeNOSettingViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-6.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "ExchangeNOSettingViewController.h"
#import "Users.h"

#define BINDING_ALERVIEW_TAG 987
@interface ExchangeNOSettingViewController()

@property (nonatomic,weak) IBOutlet UITextField *qqInputField;
@property (nonatomic,weak) IBOutlet UITextField *zhifubaoInputField;
@property (nonatomic,weak) IBOutlet UITextField *cellPhoneInputField;
@property (weak, nonatomic) IBOutlet FUISegmentedControl *flatSegmentedControl;
@property (weak,nonatomic) IBOutlet UITextView *describeView;

@end

@implementation ExchangeNOSettingViewController 



-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _qqInputField.delegate=self;
    _qqInputField.layer.borderWidth=1;
    _qqInputField.textColor=GREEN_COLOR;
    _qqInputField.layer.borderColor=[GREEN_COLOR CGColor];
    if (_formType == FormtypeBingdingQqType || _formType==FormtypeAwardGoldType) {
        self.title=@"绑定QQ";
        UILabel *lable =(UILabel *)[self.view viewWithTag:1];
        if (_formType==FormtypeAwardGoldType) {
            self.title=@"推荐奖励金币";
            lable.text=@"对方绑定的QQ";
        }else{
            _describeView.text=@"绑定QQ的作用是:\n    您要遇到金币上或者兑换上的问题,可以联系微信官方公共账号,客服需要根据您绑定的QQ去查看您的相关数据,也就是说,不绑定的话客服是无法确认您的身份的,就无法协助您查找相关数据.\n    此外,绑定QQ就可以去参加各种金币奖励功能,作为您设备的证明,不绑定将无法参加类似活动!";
            lable.text=@"要绑定的QQ号";
        }
        _describeView.font = [UIFont boldFlatFontOfSize:17];
        _describeView.textColor=GREEN_COLOR;
        [_flatSegmentedControl removeFromSuperview];
        [_zhifubaoInputField removeFromSuperview];
        [_cellPhoneInputField removeFromSuperview];
    }else{
        [_describeView removeFromSuperview];
        self.title=@"绑定兑换号码(可选填)";
        _zhifubaoInputField.delegate=self;
        _cellPhoneInputField.delegate=self;
        _zhifubaoInputField.layer.borderWidth=1;
        _cellPhoneInputField.layer.borderWidth=1;
        _zhifubaoInputField.layer.borderColor=[GREEN_COLOR CGColor];
        _cellPhoneInputField.layer.borderColor=[GREEN_COLOR CGColor];
        _zhifubaoInputField.textColor=GREEN_COLOR;
        _cellPhoneInputField.textColor=GREEN_COLOR;
        
        self.flatSegmentedControl.selectedFont = [UIFont boldFlatFontOfSize:16];
        self.flatSegmentedControl.selectedFontColor = [UIColor whiteColor];
        self.flatSegmentedControl.deselectedFont = [UIFont flatFontOfSize:16];
        self.flatSegmentedControl.deselectedFontColor = [UIColor whiteColor];
        self.flatSegmentedControl.selectedColor = GREEN_COLOR;
        self.flatSegmentedControl.deselectedColor = [UIColor silverColor];
        self.flatSegmentedControl.dividerColor = CELL_SELECT_COLOR;
        self.flatSegmentedControl.cornerRadius = 1.0;
        [_flatSegmentedControl addTarget:self
                             action:@selector(changCellphoneOp:)
                   forControlEvents:UIControlEventValueChanged];
        
        _qqInputField.text=APPDELEGATE.loginUser.userExchangeNumber.qq;
        if (APPDELEGATE.loginUser.userExchangeNumber.zhifubao.length==0) {
            _zhifubaoInputField.text=@"填支付宝的注册邮箱";
        }else
            _zhifubaoInputField.text=APPDELEGATE.loginUser.userExchangeNumber.zhifubao;
        _cellPhoneInputField.text=APPDELEGATE.loginUser.userExchangeNumber.cellphone.length>0 ?APPDELEGATE.loginUser.userExchangeNumber.cellphone : @"联通";
        
//        if(APPDELEGATE.appVersionInfo && APPDELEGATE.appVersionInfo.isHide==1){
//            [_flatSegmentedControl removeFromSuperview];
//            [_zhifubaoInputField removeFromSuperview];
//            [_cellPhoneInputField removeFromSuperview];
//            [[self.view viewWithTag:2] removeFromSuperview];
//            [[self.view viewWithTag:3] removeFromSuperview];
//        }
    }
    
    
    
    
    
    for (int i=1; i<=3; i++) {
        UILabel *lable =(UILabel *)[self.view viewWithTag:i];
        if (_formType == FormtypeBingdingQqType || _formType==FormtypeAwardGoldType) {
            if (i==1) {
                lable.font = [UIFont flatFontOfSize:16];
                lable.textColor=GREEN_COLOR;
                lable.frame=CGRectMake(10, lable.frame.origin.y, 110, lable.frame.size.height);
                _qqInputField.frame=CGRectMake(125, _qqInputField.frame.origin.y, 180, _qqInputField.frame.size.height);
            }else{
                [lable removeFromSuperview];
            }
            
        }else{
            lable.font = [UIFont flatFontOfSize:17];
            lable.textColor=GREEN_COLOR;            
        }
    }
    
}

#pragma mark custom method

-(void) changCellphoneOp:(FUISegmentedControl *) sender
{
    _cellPhoneInputField.text=[_flatSegmentedControl titleForSegmentAtIndex:sender.selectedSegmentIndex];
}


#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"不能传空白!"];
        return NO;
    }
    if (textField.tag==4) {
        if (textField.text.length>20) {
            [SVProgressHUD showErrorWithStatus:@"字符过长!"];
            return NO;
        }
        if (_formType==FormtypeExchangeNumberType) {
            APPDELEGATE.loginUser.userExchangeNumber.qq=textField.text;
        }
        
    }else if (textField.tag==5) {
        if (textField.text.length>50) {
            [SVProgressHUD showErrorWithStatus:@"字符过长!"];
            return NO;
        }
        APPDELEGATE.loginUser.userExchangeNumber.zhifubao=textField.text;
    }else if (textField.tag==6) {
        if (textField.text.length>20) {
            [SVProgressHUD showErrorWithStatus:@"字符过长!"];
            return NO;
        }
        APPDELEGATE.loginUser.userExchangeNumber.cellphone=textField.text;
    }
    [textField resignFirstResponder];
    
    if (_formType==FormtypeBingdingQqType) {

        [self showFUIAlertViewWithTitle:@"提示" message:[NSString stringWithFormat:@"您确定要绑定%@吗?QQ一旦绑定就不能自行修改了,特殊情况请联系客服!",textField.text] withTag:BINDING_ALERVIEW_TAG cancleButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
    }else if(_formType==FormtypeExchangeNumberType){
        [SVProgressHUD showWithStatus:@"更新中..."];
        [Users changeUserExchangeNuberInfo:^(id json) {
            [SVProgressHUD showSuccessWithStatus:@"成功!"];
        } failure:^(id error) {
           [AppUtilities handleErrorMessage:error];
         
        }];
    }else if (_formType==FormtypeAwardGoldType){
        [SVProgressHUD showWithStatus:@"处理中..."];
         [Users QqAward:^(id json) {
             APPDELEGATE.loginUser.awardQqCount++;
             [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"恭喜!成功兑换%@金币!",[json objectForKey:@"amount"] ]];
         } failure:^(id error) {
             [AppUtilities handleErrorMessage:error];
         } withQQ:textField.text];
    }
    return YES; 
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==5) {
        textField.text=APPDELEGATE.loginUser.userExchangeNumber.zhifubao;
    }
    return YES;
}

#pragma mark FUIalertViewDelegate

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==BINDING_ALERVIEW_TAG) {
        if (buttonIndex==0) {
            [SVProgressHUD showWithStatus:@"更新中..."];
            [Users bindingUserQQ:^(id json) {
                APPDELEGATE.loginUser.qq=_qqInputField.text;
                [SVProgressHUD showSuccessWithStatus:@"绑定成功!"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } failure:^(id error) {
                [AppUtilities handleErrorMessage:error];
            } withQQ:_qqInputField.text];
            
        }
    }
}

@end
