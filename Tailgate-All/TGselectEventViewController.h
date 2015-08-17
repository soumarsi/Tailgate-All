//
//  TGselectEventViewController.h
//  Tailgate-All
//
//  Created by Soumarsi Kundu on 13/08/15.
//  Copyright (c) 2015 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGGlobalClass.h"
@interface TGselectEventViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *selectEventPicker;
@property (nonatomic, strong) TGGlobalClass *globalClass;
@property (nonatomic, strong) NSArray *eventArray;
@property (nonatomic, weak) NSString *eventName;
@property (nonatomic, weak) NSString *eventDate;
@property (nonatomic, weak) NSString *eventID;
@property (weak, nonatomic) IBOutlet UIButton *eventDone;
- (IBAction)eventSubmit:(UIButton *)sender;
- (IBAction)Back:(UIButton *)sender;

@property (nonatomic,strong)NSString *VenueName;
@property (nonatomic, strong)NSString *locationId;
@property (nonatomic) float LocationLattitude;
@property (nonatomic) float LocationLongitude;
@property (nonatomic, strong)NSString *Type;
@end
