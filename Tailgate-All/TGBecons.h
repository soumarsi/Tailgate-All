//
//  TGBecons.h
//  Taligate
//
//  Created by Soumarsi Kundu on 30/03/15.
//  Copyright (c) 2015 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGGlobal.h"
#import <Foundation/Foundation.h>
@class TGBecons;
@protocol TGBecons <NSObject>

@optional
- (void)dragAndDrop:(UIPanGestureRecognizer *)gestureRecognizer  targetView:(TGBecons *)targetView;

@end
@interface TGBecons : UIView<UIGestureRecognizerDelegate>
{

    
    UIView *RedBeconsView;
    BOOL _tLocked;
    BOOL _isTLocked;
    NSString *_ButtonLabel;
    NSString *_DescriptionText;
}

@property(assign)id<TGBecons> TgDelegate;
@property (nonatomic) BOOL tLocked;
@property (nonatomic) BOOL isTLocked;
@property (nonatomic) NSString *ButtonLabel;
@property (nonatomic) NSString *DescriptionText;
- (void)configure;
-(void)backcolor;
- (BOOL)isTLocked;
- (NSString *)ButtonLabel;
- (NSString *)DescriptionText;
@end
