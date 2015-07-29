//
//  TGMapoxfordedit.h
//  Tailgate-All
//
//  Created by Soumarsi Kundu on 28/07/15.
//  Copyright (c) 2015 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGGlobal.h"

@interface TGMapoxfordedit : UIView<UITextViewDelegate>
{
    __weak id <TGGlobal> _delegate;
    
    UILabel *_ButtonLabel,*orderButtonLabel;
    UITextView *_DescriptionText;
    UIButton *DropDownButton,*orderDropdownButton;
    UIButton *SubmitButton,*CancelButton;
    UIImageView *Dropdown,*orderDropdownImageview;
    UIImageView *_backview;
}
@property (nonatomic, weak) id <TGGlobal> delegate;
@property(nonatomic)UILabel *ButtonLabel;
@property(nonatomic)UITextView *DescriptionText;
@property(nonatomic)UIImageView *backview;
@property(nonatomic)UIButton *submitButton;
@property(nonatomic)UIView *BackPopupView;
@property (nonatomic)UIButton *orderDropdownButton;
@property (nonatomic)UILabel *orderButtonLabel;
@property (nonatomic) UIImageView *orderDropdownImageview;

@end
