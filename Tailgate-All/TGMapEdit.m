//
//  TGMapEdit.m
//  Taligate
//
//  Created by Soumarsi Kundu on 27/03/15.
//  Copyright (c) 2015 esolz. All rights reserved.
//

#import "TGMapEdit.h"
#import "UIColor+TGGlobalColor.h"
#import "UIFont+TGGlobalFont.h"
#import "UIImage+TGGlobalImage.h"
#import "NSString+TGGlobalString.h"
@implementation TGMapEdit
@synthesize delegate = _delegate;
@synthesize ButtonLabel =_ButtonLabel;
@synthesize DescriptionText =_DescriptionText;
@synthesize backview = _backview;
@synthesize submitButton = SubmitButton;
@synthesize BackPopupView = _BackPopupView;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
        BackPopupView  = [[UIView alloc]init];
        [BackPopupView setBackgroundColor:[UIColor ClearColor]];
        [self addSubview:BackPopupView];
        
        _backview = [[UIImageView alloc]init];
        [BackPopupView addSubview:_backview];
        
        DropDownButton = [[UIButton alloc]init];
        [DropDownButton setBackgroundColor:[UIColor ClearColor]];
        [DropDownButton addTarget:_delegate action:@selector(DropDown:) forControlEvents:UIControlEventTouchUpInside];
        [BackPopupView addSubview:DropDownButton];
        
        _ButtonLabel = [[UILabel alloc]init];
        [_ButtonLabel setBackgroundColor:[UIColor ClearColor]];
        [_ButtonLabel setText:@"Select the order from list"];
        [_ButtonLabel setTextAlignment:NSTextAlignmentLeft];
        _ButtonLabel.textColor = [UIColor MapButtonColor];
        _ButtonLabel.font = [UIFont MapEditButtonLabel];
        [DropDownButton addSubview:_ButtonLabel];
        
        
        Dropdown = [[UIImageView alloc]init];
        [Dropdown setImage:[UIImage DropDwonImage]];
        [DropDownButton addSubview:Dropdown];


        
        _DescriptionText = [[UITextView alloc]init];
        _DescriptionText.font = [UIFont MapEditDescriptionLabel];
        _DescriptionText.backgroundColor = [UIColor ClearColor];
        _DescriptionText.textColor = [UIColor MapButtonColor];
        _DescriptionText.scrollEnabled = YES;
        _DescriptionText.pagingEnabled = YES;
        _DescriptionText.editable = NO;
        _DescriptionText.delegate = self;
        _DescriptionText.textAlignment = NSTextAlignmentLeft;
        [_DescriptionText setAutocorrectionType:UITextAutocorrectionTypeNo];
        [BackPopupView addSubview:_DescriptionText];
        
        
        CancelButton = [[UIButton alloc]init];
        [CancelButton setBackgroundColor:[UIColor ClearColor]];
        [CancelButton setBackgroundImage:[UIImage CancelImage] forState:UIControlStateNormal];
        [CancelButton addTarget:_delegate action:@selector(CanCel:) forControlEvents:UIControlEventTouchUpInside];
        [BackPopupView addSubview:CancelButton];
      
        
        SubmitButton = [[UIButton alloc]init];
        [SubmitButton setBackgroundColor:[UIColor ClearColor]];
        [SubmitButton setBackgroundImage:[UIImage DoneImage] forState:UIControlStateNormal];
        SubmitButton.alpha = 0.25f;
        [SubmitButton addTarget:_delegate action:@selector(Submit:) forControlEvents:UIControlEventTouchUpInside];
        [BackPopupView addSubview:SubmitButton];
        
        
        
        if ([[UIScreen mainScreen]bounds].size.width == 320)
        {
            BackPopupView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 237.5);
            _backview.frame = CGRectMake(0.0f, 0.0f, 320.0f, 237.5f);
            DropDownButton.frame = CGRectMake(25.0f, 23.0f, 320.0f, 40.0f);
            _ButtonLabel.frame = CGRectMake(10.0f, 5.0f, 290.0f, 40.0f);
            Dropdown.frame = CGRectMake(245, 13.5f, 22, 22);
            _DescriptionText.frame = CGRectMake(25,74,340,95);
            CancelButton.frame = CGRectMake(210, 175, 83.0f, 35);
            SubmitButton.frame = CGRectMake(120, 175, 83.0f, 35);
        }
        else
        {
            BackPopupView.frame = CGRectMake(0.0f, 0.0f, 387.5, 237.5);
            _backview.frame = CGRectMake(0.0f, 0.0f, 387.5f, 237.5f);
            DropDownButton.frame = CGRectMake(25.0f, 23.0f, 350.0f, 40.0f);
            _ButtonLabel.frame = CGRectMake(10.0f, 5.0f, 320.0f, 40.0f);
            Dropdown.frame = CGRectMake(300, 13.5f, 22, 22);
            _DescriptionText.frame = CGRectMake(25,74,340,95);
            CancelButton.frame = CGRectMake(270, 175, 83.0f, 35);
            SubmitButton.frame = CGRectMake(180, 175, 83.0f, 35);
        }
        
        
           }
    return self;
}

@end
