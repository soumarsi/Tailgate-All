//
//  TGMapoxfordedit.m
//  Tailgate-All
//
//  Created by Soumarsi Kundu on 28/07/15.
//  Copyright (c) 2015 esolz. All rights reserved.
//

#import "TGMapoxfordedit.h"

#import "UIColor+TGGlobalColor.h"
#import "UIFont+TGGlobalFont.h"
#import "UIImage+TGGlobalImage.h"
#import "NSString+TGGlobalString.h"
@implementation TGMapoxfordedit
@synthesize delegate = _delegate;
@synthesize ButtonLabel =_ButtonLabel;
@synthesize DescriptionText =_DescriptionText;
@synthesize backview = _backview;
@synthesize submitButton = SubmitButton;
@synthesize BackPopupView = _BackPopupView;
@synthesize orderDropdownButton = _orderDropdownButton;
@synthesize orderButtonLabel = _orderButtonLabel;
@synthesize orderDropdownImageview = _orderDropdownImageview;
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
        
        _BackPopupView  = [[UIView alloc]init];
        [_BackPopupView setBackgroundColor:[UIColor ClearColor]];
        [self addSubview:_BackPopupView];
        
        _backview = [[UIImageView alloc]init];
        [_BackPopupView addSubview:_backview];
        
        DropDownButton = [[UIButton alloc]init];
        [DropDownButton setBackgroundColor:[UIColor MapSaveBackgroundColor]];
        DropDownButton.layer.cornerRadius = 4.0f;
        [DropDownButton addTarget:_delegate action:@selector(DropDownoxfordevent:) forControlEvents:UIControlEventTouchUpInside];
        [_BackPopupView addSubview:DropDownButton];
        
        _ButtonLabel = [[UILabel alloc]init];
        [_ButtonLabel setBackgroundColor:[UIColor ClearColor]];
        [_ButtonLabel setText:@"Select the event from list"];
        [_ButtonLabel setTextAlignment:NSTextAlignmentLeft];
        _ButtonLabel.textColor = [UIColor MapButtonColor];
        _ButtonLabel.font = [UIFont MapEditButtonLabel];
        [DropDownButton addSubview:_ButtonLabel];

        
        Dropdown = [[UIImageView alloc]init];
        [Dropdown setImage:[UIImage DropDwonImage]];
        [DropDownButton addSubview:Dropdown];
        
        _orderDropdownButton = [[UIButton alloc]init];
        [_orderDropdownButton setBackgroundColor:[UIColor MapSaveBackgroundColor]];
        _orderDropdownButton.layer.cornerRadius = 4.0f;
        [_orderDropdownButton addTarget:_delegate action:@selector(DropDownoxfordorder:) forControlEvents:UIControlEventTouchUpInside];
        [_BackPopupView addSubview:_orderDropdownButton];
        
        
        _orderButtonLabel = [[UILabel alloc]init];
        [_orderButtonLabel setBackgroundColor:[UIColor ClearColor]];
        [_orderButtonLabel setText:@"Select the order from list"];
        [_orderButtonLabel setTextAlignment:NSTextAlignmentLeft];
        _orderButtonLabel.textColor = [UIColor MapButtonColor];
        _orderButtonLabel.font = [UIFont MapEditButtonLabel];
        [_orderDropdownButton addSubview:_orderButtonLabel];
        
        _orderDropdownImageview = [[UIImageView alloc]init];
        [_orderDropdownImageview setImage:[UIImage DropDwonImage]];
        [_orderDropdownButton addSubview:_orderDropdownImageview];

        
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
        [_BackPopupView addSubview:_DescriptionText];

        
        CancelButton = [[UIButton alloc]init];
        [CancelButton setBackgroundColor:[UIColor ClearColor]];
        [CancelButton setBackgroundImage:[UIImage CancelImage] forState:UIControlStateNormal];
        [CancelButton addTarget:_delegate action:@selector(CanCeloxford:) forControlEvents:UIControlEventTouchUpInside];
        [_BackPopupView addSubview:CancelButton];
        
        
        SubmitButton = [[UIButton alloc]init];
        [SubmitButton setBackgroundColor:[UIColor ClearColor]];
        [SubmitButton setBackgroundImage:[UIImage DoneImage] forState:UIControlStateNormal];
        SubmitButton.alpha = 0.25f;
        [SubmitButton addTarget:_delegate action:@selector(Submitoxford:) forControlEvents:UIControlEventTouchUpInside];
        [_BackPopupView addSubview:SubmitButton];
        
        
        if ([[UIScreen mainScreen]bounds].size.width == 320)
        {
            _BackPopupView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 300.5);
            _backview.frame = CGRectMake(0.0f, 0.0f, 320.0f, 300.5f);
            DropDownButton.frame = CGRectMake(25.0f, 34.0f, 270.0f, 40.0f);
            _ButtonLabel.frame = CGRectMake(10.0f, 0.0f, 290.0f, 40.0f);
            Dropdown.frame = CGRectMake(245, 8.5f, 22, 22);
            _DescriptionText.frame = CGRectMake(25,74,340,95);
            CancelButton.frame = CGRectMake(210, 232, 83.0f, 35);
            SubmitButton.frame = CGRectMake(120, 232, 83.0f, 35);
            _orderDropdownButton.frame = CGRectMake(25.0f,78.0f, 270.0f, 40.0f);
            _orderButtonLabel.frame = CGRectMake(10.0f, 0.0f, 300.0f, 40.0f);
            _orderDropdownImageview.frame = CGRectMake(245, 8.5f, 22, 22);
        }
        else
        {
            _BackPopupView.frame = CGRectMake(0.0f, 0.0f, 387.5, 300.5);
            _backview.frame = CGRectMake(0.0f, 0.0f, 387.5f, 300.5f);
            DropDownButton.frame = CGRectMake(25.0f, 34.0f, 337.0f, 40.0f);
            _ButtonLabel.frame = CGRectMake(10.0f, 0.0f, 320.0f, 40.0f);
            Dropdown.frame = CGRectMake(300, 8.5f, 22, 22);
            _DescriptionText.frame = CGRectMake(25,74,340,95);
            CancelButton.frame = CGRectMake(270, 232, 83.0f, 35);
            SubmitButton.frame = CGRectMake(180, 232, 83.0f, 35);
            _orderDropdownButton.frame = CGRectMake(25.0f, 78.0f, 337.0f, 40.0f);
            _orderButtonLabel.frame = CGRectMake(10.0f, 0.0f, 320.0f, 40.0f);
            _orderDropdownImageview.frame = CGRectMake(300, 8.5f, 22, 22);
        }
    }
    return self;
}

@end
